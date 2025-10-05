import 'package:flutter/material.dart';
import 'package:islam/quran/arabic_sura_number.dart';

import 'constant.dart'; // ملف الثوابت
import 'mydrawer.dart'; // القائمة الجانبية
import 'surah_builder.dart'; // صفحة عرض السورة

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  String searchQuery = ""; // النص المكتوب في البحث

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Go to bookmark',
        child: const Icon(
          Icons.bookmark,
          color: Colors.amber ),
        backgroundColor: const Color(0xff00a2b5),
        onPressed: () async {
          fabIsClicked = true;
          if (await readBookmark() == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SurahBuilder(
                  arabic: quran[0],
                  sura: bookmarkedSura - 1,
                  suraName: arabicName[bookmarkedSura - 1]['name'],
                  ayah: bookmarkedAyah,
                ),
              ),
            );
          }
        },
      ),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff00a2b5),
        title: TextField(
          decoration: const InputDecoration(
            // hintStyle: TextStyle(color: Colors.white,
            hintText: "...ابحث عن سورة",
            border: InputBorder.none,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
      ),

      body: FutureBuilder(
        future: readJson(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return indexCreator(snapshot.data, context);
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }

  // دالة تبني قائمة السور باستخدام ListView.builder + البحث
  Widget indexCreator(quran, context) {
    // فلترة السور حسب البحث
    final filteredList = arabicName
        .where((sura) => sura['name'].toString().contains(searchQuery))
        .toList();

    return Container(
      color: const Color.fromARGB(255, 221, 250, 236),
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          // نجيب السورة الأصلية (من الفهرس الأساسي)
          int suraIndex =
              arabicName.indexOf(filteredList[index]); // موقعها الحقيقي

          return Container(
    color: index % 2 == 0
    ? const Color(0xFFF0F0F0) // رمادي فاتح دافئ
    : const Color(0xFFE0E0E0), // رمادي فاتح أكثر دقة

            child: TextButton(
              child: Row(
                children: [
                  ArabicSuraNumber(i: suraIndex),
                  const SizedBox(width: 5),
                  const Expanded(child: SizedBox()),
                  Text(
                    filteredList[index]['name'],
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color.from(alpha: 1, red: 0.157, green: 0.212, blue: 0.094),
                      fontFamily: 'UthmanTNB_v2-0',
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              onPressed: () {
                fabIsClicked = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurahBuilder(
                      arabic: quran[0],
                      sura: suraIndex,
                      suraName: arabicName[suraIndex]['name'],
                      ayah: 0,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
