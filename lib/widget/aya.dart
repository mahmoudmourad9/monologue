import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Aya extends StatefulWidget {
  const Aya({super.key});

  @override
  State<Aya> createState() => _AyaState();
}

class _AyaState extends State<Aya> {
  List<Map<String, dynamic>> tips = [];
  Map<String, dynamic>? currentTip;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadTips();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> loadTips() async {
    final String response = await rootBundle.loadString('assets/aya.json');
    final List<dynamic> data = json.decode(response);
    tips = data.cast<Map<String, dynamic>>();
    setRandomTip();

    // تغيير النص تلقائيًا كل 30 ثانية
    timer = Timer.periodic(const Duration(seconds: 30), (_) {
      setRandomTip();
    });
  }

  void setRandomTip() {
    final random = Random();
    setState(() {
      currentTip = tips[random.nextInt(tips.length)];
    });
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
            // عنوان صغير (Chip)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 16, color: Color(0xff00a2b5),),
                  const SizedBox(width: 6),
                  Text(
                    "آية قرآنية",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:  const Color(0xffF8672F),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // نص الآية
            if (currentTip != null) ...[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Text(
  currentTip!['aya'],
  key: ValueKey(currentTip!['aya']),
  textAlign: TextAlign.center,
  softWrap: true,      // يخلي النص يلف
  maxLines: null,      // عدد سطور غير محدود
  style: const TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'UthmanTNB_v2-0',
  ),
),

              ),

              const SizedBox(height: 10),

              // عنوان السورة والآية
              Text(
                currentTip!['title'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.brown.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],

            const SizedBox(height: 15),

            // زر التبديل
            ElevatedButton.icon(
              onPressed: setRandomTip,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff00a2b5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                elevation: 0,
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text(
                "الآية التالية",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
