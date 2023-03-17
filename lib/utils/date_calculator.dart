class DateTimeCalculator {
  static final monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static String calculateTime(DateTime dt) {
    Duration diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) {
      return "now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m";
    } else if (diff.inHours < 60) {
      return "${diff.inHours}h";
    } else if (diff.inDays < 30) {
      return "${diff.inDays}d";
    } else {
      return "${dt.day} ${monthNames[dt.month - 1]} ${dt.year}";
    }
  }
}
