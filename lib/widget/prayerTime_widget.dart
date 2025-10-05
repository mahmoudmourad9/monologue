import 'dart:async';
import 'package:flutter/material.dart';
import 'package:islam/screens/prayerTime.dart';
import 'package:islam/services/hijri_helper.dart';

class Card_prayer extends StatefulWidget {
  const Card_prayer({
    super.key,
    required this.prayerTimes,
  });

  final Map<String, String> prayerTimes;

  @override
  _Card_prayerState createState() => _Card_prayerState();
}

class _Card_prayerState extends State<Card_prayer> {
  late Timer _timer;
  String _nextPrayerArabic = ''; // لتخزين اسم الصلاة بالعربي
  String _timeLeft = ''; // الوقت المتبقي
  final hijriDate = HijriHelper.getFullHijriDate();

  // // للترجمة من العربي للإنجليزي في الواجهة
  // final Map<String, String> _prayerNameMapping = {
  //   'الفجر': 'Fajr',
  //   'الظهر': 'Dhuhr',
  //   'العصر': 'Asr',
  //   'المغرب': 'Maghrib',
  //   'العشاء': 'Isha'
  // };

  @override
  void initState() {
    super.initState();
    // نقوم بتحديث البيانات أول مرة عند بدء التشغيل
    _updateTimeLeft();
    // ثم نقوم بتحديثها كل ثانية لعرض العداد التنازلي
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // نتأكد أن الـ виджет ما زال موجوداً
        _updateTimeLeft();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // مهم لإيقاف التايمر عند الخروج من الصفحة
    super.dispose();
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    final prayerDateTimes = <String, DateTime>{};
    widget.prayerTimes.forEach((name, time) {
      prayerDateTimes[name] = _getPrayerDateTime(time);
    });

    // ترتيب الصلوات حسب الوقت للعثور على الصلاة القادمة
    final sortedPrayers = prayerDateTimes.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    String nextPrayerName = '';
    DateTime? nextPrayerTime;

    for (var entry in sortedPrayers) {
      if (entry.value.isAfter(now)) {
        nextPrayerName = entry.key;
        nextPrayerTime = entry.value;
        break;
      }
    }

    // إذا انتهت كل صلوات اليوم، فالصلاة القادمة هي الفجر في اليوم التالي
    if (nextPrayerTime == null) {
      nextPrayerName = 'الفجر';
      nextPrayerTime = prayerDateTimes['الفجر']!.add(const Duration(days: 1));
    }

    final timeDifference = nextPrayerTime.difference(now);

    // تحديث الحالة لعرضها في الواجهة
    setState(() {
      _nextPrayerArabic = nextPrayerName;
      _timeLeft = _formatDuration(timeDifference);
    });
  }

  DateTime _getPrayerDateTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // الانتظار حتى يتم تحميل البيانات لأول مرة
    if (_nextPrayerArabic.isEmpty) {
      return const SizedBox.shrink(); // عرض عنصر فارغ مؤقتًا
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrayerScreen(prayerTimes: widget.prayerTimes),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xff00a2b5), // لون الخلفية الأخضر
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            // عمود النصوص
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  hijriDate,
                  style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 30,
                      // fontWeight: FontWeight.w800,
                      fontFamily: 'jomhuria'),
                ),

                const SizedBox(height: 12),

                //  الوقت المتبقي
                Text(
                  _timeLeft,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //  اسم الصلاة القادمة
                Text(
                  _nextPrayerArabic,
                  style: const TextStyle(color: Colors.amber, fontSize: 26,fontFamily: 'jomhuria'),
                ),
                const SizedBox(height: 14),

                // 4. الصلاة التالية (جزء ثابت)

                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    const Text(
                      'إضغط لعرض أوقات الصلاه',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
 fontFamily: 'UthmanTNB_v2-0'
                          ),
                    ),
                  ],
                )
              ],
            ),

            // صورة المسجد
            Positioned(
              right: 0,
              bottom: 0,
              top: 0,
              child: Image.asset(
                'assets/Ge.png',
                height: 80,
                color: Colors.white30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
