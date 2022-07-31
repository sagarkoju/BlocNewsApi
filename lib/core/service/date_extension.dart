import 'package:intl/intl.dart';

extension DateExtension on String {
  String articleEventDate() {
    final dateFormat = DateTime.parse(this);
    final formattedDate = DateFormat('yyyy-MM-dd').format(dateFormat);
    return formattedDate;
  }

  String articleTime() {
    final dateFormat = DateTime.parse(this);
    final formattedDate = DateFormat('HH:mm a ').format(dateFormat);
    return formattedDate;
  }
}
