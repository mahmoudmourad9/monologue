import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart'; // تأكد من إضافة الحزمة في pubspec.yaml

class AhadithPage extends StatelessWidget {
  // دالة لتحميل الأحاديث من ملف JSON
  Future<List<Map<String, dynamic>>> loadAhadith() async {
    final String response = await rootBundle.loadString('assets/hadiths.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) {
      return {
        'narrator': item['narrator'] ?? 'غير معروف', // التأكد من وجود القيمة أو إعطائها قيمة افتراضية
        'hadith': item['hadith'] ?? 'لا يوجد نص الحديث', // التأكد من وجود القيمة أو إعطائها قيمة افتراضية
        'source': item['source'] ?? 'غير معروف', // التأكد من وجود القيمة أو إعطائها قيمة افتراضية
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00a2b5), // لون الخلفية من تصميمك
        title: const Text('الأحاديث القصار',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadAhadith(), // تحميل الأحاديث من ملف JSON
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء تحميل الأحاديث'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد أحاديث لعرضها'));
          }

          final ahadith = snapshot.data!;

          return ListView.builder(
            itemCount: ahadith.length, // عدد الأحاديث
            itemBuilder: (context, index) {
              final hadith = ahadith[index];
              return Card(
                
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  
                ),
                color: Colors.lightBlue[50],
                elevation: 10, // إضافة الظل لتعزيز التأثير البصري
                shadowColor: Colors.black.withOpacity(0.1), // لون الظل
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // محاذاة النص في الوسط
                    children: [
                      Text(
                        hadith['narrator']!, // عرض اسم الراوي
                        style: const TextStyle(
                          fontSize: 25,
                          fontFamily: 'jomhuria',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // عرض نص الحديث
                      Text(
                        hadith['hadith']!,
                        textAlign: TextAlign.center, // التأكد من محاذاة النص في المنتصف
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87, // تغيير اللون إلى لون أنسب
                          fontFamily: 'UthmanTNB_v2-0',
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        overflow: TextOverflow.ellipsis, // تجنب تجاوز النص
                        maxLines: 4, // تحديد عدد الأسطر
                      ),
                      const SizedBox(height: 8),
                      // عرض المصدر
                      Text(
                        '${hadith['source']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // إضافة أيقونات النسخ والمشاركة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // أيقونة النسخ
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.blue),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: hadith['hadith']!)).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تم نسخ النص إلى الحافظة')),
                                );
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          // أيقونة المشاركة
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.blue),
                            onPressed: () {
                              final shareText = '${hadith['hadith']} \n\n[من تطبيق مناجاة للقرآن الكريم]\nhttps://play.google.com/store/apps/details?id=com.example.quran';
                              Share.share(shareText); // مشاركة النص عبر التطبيقات المختلفة
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
