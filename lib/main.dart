import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islam/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  تهيئة Hive
  await Hive.initFlutter();

  //  افتح صناديق التخزين
  await Hive.openBox('tasbihBox');   // لتخزين التسابيح
  await Hive.openBox('prayerBox');   // لتخزين مواقيت الصلاة
  await Hive.openBox('hadithBox');   //  لتخزين الأحاديث

  //  ظبط لغة التقويم الهجري
  HijriCalendar.setLocal("ar");

  runApp(const Quran());
}

class Quran extends StatelessWidget {
  const Quran({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
