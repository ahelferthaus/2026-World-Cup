import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/domain/app_user.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;

  ProfileRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<AppUser?> watchUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromFirestore(doc.id, doc.data()!);
    });
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc.id, doc.data()!);
  }

  Future<void> updateDisplayName(String uid, String newName) async {
    await _firestore.collection('users').doc(uid).update({
      'displayName': newName.trim(),
    });
  }
}
