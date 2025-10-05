import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islam/quran/index.dart';
import 'package:islam/screens/support_page.dart';
import 'package:islam/widget/aya.dart';
import 'package:islam/widget/card_hdith.dart';
import 'package:islam/services/Location.dart';
import 'package:islam/services/PrayerTimes.dart'; // السيرفس بتاع Hive
import 'package:islam/widget/bottm_vi.dart';
import 'package:islam/widget/prayerTime_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> prayerTimes = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrayerData();
  }

  Future<void> fetchPrayerData() async {
    final now = DateTime.now();
    final storedTimes = PrayerApiService.getPrayerForDay(now);

    if (storedTimes != null) {
      setState(() {
        prayerTimes = storedTimes;
        isLoading = false;
      });
    }

    //  في الخلفية → حاول تحدث البيانات من الـ API
    Position? position = await getCurrentLocation();
    if (position != null) {
      await PrayerApiService.fetchMonthlyPrayerTimes(
        position.latitude,
        position.longitude,
      );
//تعديل 
      final todayTimes = PrayerApiService.getPrayerForDay(now);
      if (todayTimes != null) {
        setState(() {
          prayerTimes = todayTimes;
          isLoading = false;
        });
      }
    } else {
      print('برجاء تفعيل الموقع تعذر الحصول على اوقات الصلاة');
      setState(() => isLoading = false);
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
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [

           
            const SizedBox(height: 80),

            // كرت مواقيت الصلاة
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.brown),
              )
            else if (prayerTimes.isNotEmpty)
              Card_prayer(prayerTimes: prayerTimes)
            else
              const Center(
                child: Text(
                  "تعذر تحميل مواقيت الصلاة",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),

            const SizedBox(height: 10),

            // كرت القرآن الكريم
             CardBig(
              reqCard: BottmV(
                name: 'القرآن الكريم',
                img: 'assets/qlogo.png',
                nav: IndexPage(),
              ),
            ),


           const Grid_Bottom(),
           const SizedBox(height: 15),
            const Hdith(),
            const SizedBox(height: 25),

            // كرت دعم التطبيق
            CardBig(
              reqCard: BottmV(
                name: 'دعم التطبيق',
                img: 'assets/support.png',
                nav: SupportPage(),
              ),
            ),

            const SizedBox(height: 25),
            const Aya(),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
