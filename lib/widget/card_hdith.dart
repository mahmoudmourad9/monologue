import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islam/screens/AhadithPage.dart';

class Hdith extends StatefulWidget {
  const Hdith({super.key});

  @override
  State<Hdith> createState() => _HdithState();
}

class _HdithState extends State<Hdith> {
  List<Map<String, dynamic>> hadiths = [];
  Map<String, String> currentHadith = {};
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadHadiths();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadHadiths() async {
    final String response = await rootBundle.loadString('assets/hadiths.json');
    final List<dynamic> data = json.decode(response);
    hadiths = List<Map<String, dynamic>>.from(data.map((item) => {
          'narrator': item['narrator'] ?? '',
          'hadith': item['hadith'] ?? '',
          'source': item['source'] ?? '',
        }));
    setRandomHadith();

    timer = Timer.periodic(const Duration(minutes: 5), (_) {
      setRandomHadith();
    });
  }

  void setRandomHadith() {
    final random = Random();
    setState(() {
      currentHadith = {
        'narrator': hadiths[random.nextInt(hadiths.length)]['narrator'] ?? '',
        'hadith': hadiths[random.nextInt(hadiths.length)]['hadith'] ?? '',
        'source': hadiths[random.nextInt(hadiths.length)]['source'] ?? '',
      };
    });
  }

  // دالة لفتح صفحة جديدة عند الضغط على زر
  void openNewPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AhadithPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 370,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lightbulb_outline,
                      size: 16, color: Color(0xff00a2b5)),
                  const SizedBox(width: 6),
                  Text(
                    "حديث شريف",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffF8672F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Column(
                key: ValueKey(currentHadith),
                children: [
                  Text(
                    currentHadith['narrator'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentHadith['hadith'] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'UthmanTNB_v2-0',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '- ${currentHadith['source'] ?? ''}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // زر الحديث التالي
                ElevatedButton.icon(
                  onPressed: setRandomHadith,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff00a2b5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.refresh, size: 14),
                  label: const Text(
                    "الحديث التالي",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                // زر الصفحة الجديدة
                ElevatedButton.icon(
                  onPressed: () => openNewPage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffF8672F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 14),
                  label: const Text(
                    "كل الاحاديث ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

