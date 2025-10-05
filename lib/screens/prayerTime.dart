import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islam/services/hijri_helper.dart';

class PrayerScreen extends StatefulWidget {
  final Map<String, String> prayerTimes;

  const PrayerScreen({super.key, required this.prayerTimes});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  late Timer _timer;
  String _nextPrayer = '';
  // ignore: unused_field
  String _timeLeft = '';
  final hijriDate = HijriHelper.getFullHijriDate();

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeLeft();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimeLeft() {
    DateTime now = DateTime.now();

    Map<String, DateTime> prayerDateTimes = {
      'الفجر': _getPrayerDateTime(widget.prayerTimes['الفجر']!),
      'الظهر': _getPrayerDateTime(widget.prayerTimes['الظهر']!),
      'العصر': _getPrayerDateTime(widget.prayerTimes['العصر']!),
      'المغرب': _getPrayerDateTime(widget.prayerTimes['المغرب']!),
      'العشاء': _getPrayerDateTime(widget.prayerTimes['العشاء']!),
    };

    var sortedPrayers = prayerDateTimes.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    String nextPrayer = '';
    DateTime? nextPrayerTime;

    for (var entry in sortedPrayers) {
      if (entry.value.isAfter(now)) {
        nextPrayer = entry.key;
        nextPrayerTime = entry.value;
        break;
      }
    }

    if (nextPrayerTime == null) {
      nextPrayer = 'الفجر';
      nextPrayerTime = prayerDateTimes['الفجر']!.add(const Duration(days: 1));
    }

    Duration timeDifference = nextPrayerTime.difference(now);

    setState(() {
      _nextPrayer = nextPrayer;
      _timeLeft = _formatDuration(timeDifference);
    });
  }

  DateTime _getPrayerDateTime(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  String formatTime12h(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? "PM" : "AM";
    hour = hour % 12;
    if (hour == 0) hour = 12;

    String minuteStr = minute.toString().padLeft(2, '0');
    return "$hour:$minuteStr $period";
  }

  // تحديد الأيقونات المناسبة لكل صلاة باستخدام Cupertino Icons
  IconData _getPrayerIcon(String prayer) {
    switch (prayer) {
      case 'الفجر':
        return CupertinoIcons.sunrise; // شروق الشمس
      case 'الظهر':
        return CupertinoIcons.sun_max; // ساعة
      case 'العصر':
        return CupertinoIcons.time; // ساعة
      case 'المغرب':
        return CupertinoIcons.sunset; // قمر
      case 'العشاء':
        return CupertinoIcons.moon; // نجمة
      default:
        return CupertinoIcons.clock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bac.jpg"), // حط الصورة هنا
            fit: BoxFit.cover, // تخلي الصورة تغطي الشاشة
          ),


        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(height: 100,),
            // كونتينر التاريخ الهجري والميلادي في أول الصفحة
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    hijriDate,
                    style: TextStyle(
                      color: Colors.amber[700],
                      fontSize: 34,
                      fontFamily: 'jomhuria',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // قائمة الصلوات مع الأيقونات
            Expanded(
              child: ListView(
                children: widget.prayerTimes.entries.map((entry) {
                  bool isNext = entry.key == _nextPrayer;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isNext ? Color(0xff00a2b5) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: ListTile(
                      leading: Icon(
                        _getPrayerIcon(entry.key), // استخدام الأيقونة المناسبة من Cupertino
                        color: isNext ? Colors.white : Colors.grey[700],
                      ),
                      title: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                          color: isNext ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: Text(
                        formatTime12h(entry.value),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                          color: isNext ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
