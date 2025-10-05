import 'package:hijri/hijri_calendar.dart';

class HijriHelper {
  // لتحويل الأرقام الإنجليزية إلى عربية
  static String toArabicNumbers(String input) {
    const englishNums = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicNums = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < englishNums.length; i++) {
      input = input.replaceAll(englishNums[i], arabicNums[i]);
    }
    return input;
  }

  // دالة للحصول على التاريخ الهجري كامل بالعربي بصيغة نص
  static String getFullHijriDate() {
    final todayHijri = HijriCalendar.now();
    final day = toArabicNumbers(todayHijri.hDay.toString());
    final month = todayHijri.getLongMonthName(); // اسم الشهر بالعربي
    final year = toArabicNumbers(todayHijri.hYear.toString());

    return '$day $month $year هـ';
  }
}
