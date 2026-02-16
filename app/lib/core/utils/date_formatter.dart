import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String kickoffTime(String isoDate) {
    final dt = DateTime.parse(isoDate).toLocal();
    return DateFormat('h:mm a').format(dt);
  }

  static String matchDate(String isoDate) {
    final dt = DateTime.parse(isoDate).toLocal();
    return DateFormat('MMM d, yyyy').format(dt);
  }

  static String relativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(dateTime);
  }

  static String elapsed(int? minutes) {
    if (minutes == null) return '';
    return "$minutes'";
  }
}
