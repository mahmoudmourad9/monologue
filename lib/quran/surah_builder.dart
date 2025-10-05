import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';
import 'constant.dart'; //
// ignore: must_be_immutable
class SurahBuilder extends StatefulWidget {
  // بيانات السورة
  final sura; // رقم السورة
  final arabic; // النصوص العربية (الآيات)
  final suraName; // اسم السورة
  int ayah; // الآية اللي عايزين نبدأ منها

  SurahBuilder({
    Key? key,
    this.sura,
    this.arabic,
    this.suraName,
    required this.ayah,
  }) : super(key: key);

  @override
  _SurahBuilderState createState() => _SurahBuilderState();
}

class _SurahBuilderState extends State<SurahBuilder> {
  bool view = true; // متغير علشان نتحكم في طريقة العرض (عادي أو مصحف)

  @override
  void initState() {
    // بعد ما الصفحة تجهز، يقفز للآية اللي متحددة
    WidgetsBinding.instance.addPostFrameCallback((_) => jumbToAyah());
    super.initState();
  }

  // دالة للقفز للآية المطلوبة
  jumbToAyah() {
    if (fabIsClicked) {
      itemScrollController.scrollTo(
        index: widget.ayah,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutCubic,
      );
    }
    fabIsClicked = false;
  }

  // تبني شكل كل آية (نص الآية بخط عربي)
  Row verseBuilder(int index, previousVerses) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // محاذاة يمين
            children: [
              Text(
                widget.arabic[index + previousVerses]['aya_text'], // نص الآية
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: arabicFontSize,
                  fontFamily: arabicFont,
                  color: const Color.fromARGB(196, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // دالة تبني السورة بالكامل
  SafeArea SingleSuraBuilder(LenghtOfSura) {
    String fullSura = ''; // لنص السورة بالكامل (في وضع المصحف)
    int previousVerses = 0; // عدد الآيات قبل السورة دي

    // نحسب عدد الآيات اللي قبل السورة دي علشان نجيب بداية السورة صح
    if (widget.sura + 1 != 1) {
      for (int i = widget.sura - 1; i >= 0; i--) {
        previousVerses = previousVerses + noOfVerses[i];
      }
    }

    // لو العرض "مصحف" يبني نص السورة كامل كسلسلة واحدة
    if (!view)
      for (int i = 0; i < LenghtOfSura; i++) {
        fullSura += (widget.arabic[i + previousVerses]['aya_text']);
      }

    return SafeArea(
      child: Container(
        color: const Color.fromARGB(255, 253, 251, 240), // خلفية فاتحة
        child: view
            ? ScrollablePositionedList.builder(
                // وضع العرض العادي: قائمة آيات واحدة واحدة
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      // عرض البسملة في بداية السورة (مع استثناء الفاتحة والتوبة)
                      (index != 0) || (widget.sura == 0) || (widget.sura == 8)
                          ? const Text('')
                          : const RetunBasmala(),
                      Container(
                        color: index % 2 != 0
                            ? const Color.fromARGB(255, 253, 251, 240)
                            : const Color.fromARGB(255, 253, 247, 230),
                        child: GestureDetector(
                          onLongPress: () {
                            saveBookMark(widget.sura + 1, index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('تم حفظ الآية في الإشارة المرجعية.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: PopupMenuButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: verseBuilder(index, previousVerses),
                            ),
                            itemBuilder: (context) => [
                              // إضافة Bookmark
                              PopupMenuItem(
                                onTap: () {
                                  saveBookMark(widget.sura + 1, index);
                                },
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.bookmark_add,
                                      color: Color(0xff00a2b5),
                                    ),
                                    SizedBox(width: 10),
                                    Text('Bookmark'),
                                  ],
                                ),
                              ),
                              // مشاركة الآية
                              PopupMenuItem(
                                onTap: () {
                                  // **تم التعديل هنا: استخدام حقل 'aya_text_emlaey'**
                                  final verseText =
                                      widget.arabic[index + previousVerses]
                                          ['aya_text_emlaey'];
                                  Share.share(
                                    '$verseText\n\n[من تطبيق مناجاة للقرآن الكريم]\nhttps://play.google.com/store/apps/details?id=com.example.quran',
                                  );
                                },
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.share,
                                      color: Color(0xff00a2b5),
                                    ),
                                    SizedBox(width: 10),
                                    Text('Share'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemCount: LenghtOfSura,
              )
            : ListView(
                // وضع عرض المصحف (كل السورة نص واحد في الوسط)
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // البسملة (ما عدا الفاتحة والتوبة)
                            widget.sura + 1 != 1 && widget.sura + 1 != 9
                                ? const RetunBasmala()
                                : const Text(''),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                fullSura,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: mushafFontSize,
                                  fontFamily: arabicFont,
                                  color: const Color.fromARGB(196, 44, 44, 44),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int LengthOfSura = noOfVerses[widget.sura]; // عدد الآيات في السورة

    return Scaffold(
      appBar: AppBar(
        leading: Tooltip(
          message: 'Mushaf Mode',
          child: TextButton(
            child: const Icon(
              Icons.chrome_reader_mode,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              // نغير وضع العرض (عادي ↔ مصحف)
              setState(() {
                view = !view;
              });
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.suraName, // اسم السورة
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontFamily: 'UthmanTNB_v2-0',
          ),
        ),
        backgroundColor: const Color(0xff00a2b5),
      ),
      body: SingleSuraBuilder(LengthOfSura), // محتوى السورة
    );
  }
}

// ويدجت ثابتة بتعرض "بسم الله الرحمن الرحيم"
class RetunBasmala extends StatelessWidget {
  const RetunBasmala({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, top: 15),
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
              style: TextStyle(fontFamily: 'me_quran', fontSize: 30),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ],
    );
  }
}
