class Validators {
  Validators._();

  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Display name is required';
    }
    if (value.trim().length > 20) {
      return 'Display name must be 20 characters or less';
    }
    if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value.trim())) {
      return 'Only letters, numbers, and spaces allowed';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? wager(String? value, int maxTokens) {
    if (value == null || value.isEmpty) {
      return 'Enter a wager amount';
    }
    final num = int.tryParse(value);
    if (num == null) return 'Enter a valid number';
    if (num < 1) return 'Minimum wager is 1 token';
    if (num > 20) return 'Maximum wager is 20 tokens';
    if (num > maxTokens) return 'You only have $maxTokens tokens';
    return null;
  }
}
