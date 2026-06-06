import 'package:intl/intl.dart';

class Formatters {
  static String currency(double amount) {
    return NumberFormat.currency(
      symbol: 'R\$ ',
      decimalDigits: 2,
      locale: 'pt_BR',
    ).format(amount);
  }

  static String date(DateTime date) {
    return DateFormat('dd MMM yyyy', 'pt_BR').format(date);
  }

  static String dateShort(DateTime date) {
    return DateFormat('dd/MM', 'pt_BR').format(date);
  }

  static String monthYear(DateTime date) {
    return DateFormat('MMMM yyyy', 'pt_BR').format(date);
  }

  static String dayShort(DateTime date) {
    return DateFormat('E', 'pt_BR').format(date).substring(0, 1).toUpperCase();
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final diff = today.difference(dateDay).inDays;

    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Ontem';
    if (diff < 7) return 'Há $diff dias';
    return DateFormat('dd MMM', 'pt_BR').format(date);
  }
}
