import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive/hive.dart';

class PrayerApiService {
  // جلب مواقيت الصلاة لشهر كامل وتخزينها
  static Future<void> fetchMonthlyPrayerTimes(
      double latitude, double longitude) async {
    try {
      final box = Hive.box('prayerBox');
      final now = DateTime.now();

      String url =
          "https://api.aladhan.com/v1/calendar/${now.year}/${now.month}?latitude=$latitude&longitude=$longitude&method=5";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        //  نعمل cast للـ JSON
        final Map<String, dynamic> jsonData =
            Map<String, dynamic>.from(jsonDecode(response.body));

        // امسح بيانات الشهر القديم
        await box.clear();

     
        final List<dynamic> data = jsonData['data'];

        // خزّن كل الأيام
        for (var day in data) {
          final dayData = Map<String, dynamic>.from(day);

          String date = dayData['date']['gregorian']['date']; 

          final timings =
              Map<String, dynamic>.from(dayData['timings']); //  مهم

          final Map<String, String> prayerTimes = {
            'الفجر': timings['Fajr'].toString().split(" ")[0],
            'الظهر': timings['Dhuhr'].toString().split(" ")[0],
            'العصر': timings['Asr'].toString().split(" ")[0],
            'المغرب': timings['Maghrib'].toString().split(" ")[0],
            'العشاء': timings['Isha'].toString().split(" ")[0],
          };

          await box.put(date, prayerTimes);
        }

        print(" تم تخزين مواقيت الصلاة للشهر كامل");
      } else {
        print(" فشل الاتصال بالـ API: ${response.statusCode}");
      }
    } catch (e) {
      print(" خطأ أثناء جلب البيانات: $e");
    }
  }

  // جلب أوقات يوم محدد من التخزين
  static Map<String, String>? getPrayerForDay(DateTime date) {
    final box = Hive.box('prayerBox');

    String today = "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";

    print(" بجيب البيانات لليوم: $today");

    final data = box.get(today);

    if (data == null) return null;

    //  نعمل cast هنا كمان
    return Map<String, String>.from(data);
  }
}
