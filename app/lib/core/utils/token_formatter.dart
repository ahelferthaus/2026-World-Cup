import 'package:intl/intl.dart';

class TokenFormatter {
  TokenFormatter._();

  static final _formatter = NumberFormat('#,###');

  static String format(int tokens) {
    return _formatter.format(tokens);
  }

  static String withLabel(int tokens) {
    return '${format(tokens)} tokens';
  }

  static String payout(int wager, double multiplier) {
    final result = (wager * multiplier).toInt();
    return format(result);
  }
}
