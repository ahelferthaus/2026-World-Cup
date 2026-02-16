import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/async_value_extensions.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../auth/presentation/providers/auth_providers.dart';
import 'providers/profile_providers.dart';

class EditNameScreen extends ConsumerStatefulWidget {
  const EditNameScreen({super.key});

  @override
  ConsumerState<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends ConsumerState<EditNameScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProfileProvider).valueOrNull;
    if (user != null) {
      _controller.text = user.displayName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final uid = ref.read(currentUidProvider);
      if (uid == null) throw Exception('Not signed in');

      await ref.read(profileRepositoryProvider).updateDisplayName(
            uid,
            _controller.text.trim(),
          );

      if (mounted) {
        context.showSuccessSnackBar('Display name updated!');
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to update name.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Display Name')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  hintText: 'Enter your display name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: Validators.displayName,
                textCapitalization: TextCapitalization.words,
                maxLength: 20,
              ),
              const SizedBox(height: AppSpacing.xl),
              GradientButton(
                label: 'Save',
                onPressed: _isLoading ? null : _save,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
