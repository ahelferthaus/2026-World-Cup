import 'dart:convert';
import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<String?> getIdToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  // Google Sign-In (google_sign_in 7.x API)
  Future<UserCredential> signInWithGoogle() async {
    final gsi = GoogleSignIn.instance;
    await gsi.initialize();
    final account = await gsi.authenticate();

    final idToken = account.authentication.idToken;

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final result = await _auth.signInWithCredential(credential);
    await _ensureUserDoc();
    return result;
  }

  // Apple Sign-In
  Future<UserCredential> signInWithApple() async {
    final rawNonce = _generateNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );

    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );
    final result = await _auth.signInWithCredential(oauthCredential);
    await _ensureUserDoc();
    return result;
  }

  // Email/Password Sign-In
  Future<UserCredential> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _ensureUserDoc();
    return result;
  }

  // Email/Password Registration
  Future<UserCredential> registerWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(displayName);
    await _ensureUserDoc();
    return credential;
  }

  // Initialize user profile doc in Firestore (idempotent — safe to call on every sign-in)
  Future<void> _ensureUserDoc() async {
    try {
      await _functions.httpsCallable('onUserCreated').call();
    } catch (_) {
      // Non-fatal — profile will be created on next sign-in
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }
}
