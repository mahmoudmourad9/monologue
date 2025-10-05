import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle; // لاستخدام rootBundle لتحميل الملفات من assets
import 'dart:convert'; // لاستخدام json.decode لفك تشفير بيانات JSON

class NamesOfAllahPage extends StatefulWidget {
  @override
  _NamesOfAllahPageState createState() => _NamesOfAllahPageState();
}

class _NamesOfAllahPageState extends State<NamesOfAllahPage> {
  List<Map<String, String>> names = []; // تهيئة كقائمة فارغة
  List<Map<String, String>> filteredNames = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNames(); // تحميل الأسماء عند تهيئة الويدجت
  }

  // دالة لتحميل ومعالجة بيانات JSON من مجلد assets
  Future<void> _loadNames() async {
    try {
      // تحميل محتوى ملف JSON كنص
      final String response =
          await rootBundle.loadString('assets/namesofallah.json');
      // فك تشفير النص JSON إلى قائمة من الكائنات الديناميكية (List<dynamic>)
      final List<dynamic> data = json.decode(response);
      // تحويل List<dynamic> إلى List<Map<String, String>>
      setState(() {
        names = data.map((item) => Map<String, String>.from(item)).toList();
        filteredNames = names; // في البداية، عرض جميع الأسماء
      });
    } catch (e) {
      // معالجة الأخطاء المحتملة أثناء التحميل أو المعالجة
      print("خطأ في تحميل الأسماء: $e");
      // يمكنك عرض رسالة خطأ للمستخدم هنا إذا أردت
    }
  }

  void _searchNames(String query) {
    if (names.isEmpty) return; // تحقق للتأكد من أن قائمة الأسماء ليست فارغة

    final suggestions = names.where((name) {
      // تأكد من أن 'name' ليس null قبل استدعاء toLowerCase()
      final nameLower = name['name']?.toLowerCase() ?? '';
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredNames = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('أسماء الله الحسنى',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xff00a2b5),

        elevation: 0, 
      ),
      body: Container(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'ابحث عن اسم...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _searchNames, // استدعاء دالة البحث عند تغيير النص
              ),
            ),
            Expanded(
              // التحقق إذا كانت قائمة الأسماء فارغة (لا تزال قيد التحميل)
              child: names.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator()) // عرض مؤشر تحميل
                  : filteredNames.isEmpty && searchController.text.isNotEmpty
                      ? const Center(
                          child: Text(
                              "لا توجد نتائج بحث مطابقة")) // عرض رسالة في حالة عدم وجود نتائج للبحث
                      : GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // عدد الأعمدة في الشبكة
                            crossAxisSpacing: 10, // المسافة الأفقية بين العناصر
                            mainAxisSpacing: 10, // المسافة الرأسية بين العناصر
                          ),
                          itemCount: filteredNames.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // عند الضغط على الاسم نعرض التفسير
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                          child: Text(
                                        filteredNames[index]['name']!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff00a2b5)),
                                      )),
                                      content: SingleChildScrollView(
                                        // للسماح بالتمرير إذا كان النص طويلاً
                                        child: Text(
                                          filteredNames[index]['meaning']!,
                                          style: const TextStyle(fontSize: 18),
                                          textDirection: TextDirection
                                              .rtl, // لضمان اتجاه النص من اليمين لليسار
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Center(
                                              child: const Text(
                                            'إغلاق',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xffF8672F)),
                                          )),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Card(
                                color: Colors.teal[50], // لون خلفية البطاقة
                                elevation: 3, // إضافة تأثير الظل
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10), // شكل دائري
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        8.0), // إضافة حشوة داخلية للنص
                                    child: Text(
                                      filteredNames[index]['name']!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Anton-Regular",
                                        color: Colors.teal[900],
                                      ),
                                      textAlign: TextAlign
                                          .center, // محاذاة النص في الوسط
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String?> {
  // تحديد نوع النتيجة المتوقعة
  final List<Map<String, String>> names;
  final Function(String) searchCallback; // التأكد من نوع الدالة

  CustomSearchDelegate(this.names, this.searchCallback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchCallback(query); // تحديث نتائج البحث في الصفحة الرئيسية
          showSuggestions(context); // عرض الاقتراحات بعد مسح النص
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        searchCallback(''); // مسح نتائج البحث عند إغلاق البحث
        close(context, null); // إغلاق واجهة البحث
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchCallback(query); // تطبيق البحث على القائمة الرئيسية
    // عادةً ما يتم إغلاق واجهة البحث هنا وتحديث القائمة في الصفحة الرئيسية
    // إذا كنت تريد عرض النتائج مباشرة هنا، ستحتاج إلى بناء واجهة مشابهة لـ GridView
    WidgetsBinding.instance.addPostFrameCallback((_) {
      close(context, query); // إغلاق الواجهة وتمرير نص البحث
    });
    return Container(); // عنصر نائب، حيث أننا نغلق الواجهة
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // إذا كان نص البحث فارغًا، يمكنك عرض جميع الأسماء كاقتراحات أولية أو قائمة فارغة
    if (query.isEmpty) {
      // يمكنك عرض قائمة فارغة أو بعض الاقتراحات الأولية
      return ListView.builder(
        itemCount: names.length > 10
            ? 10
            : names.length, // عرض عدد محدود من الاقتراحات الأولية
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(names[index]['name']!),
            onTap: () {
              query = names[index]['name']!;
              searchCallback(query);
              showResults(context); // عرض النتائج بعد اختيار اقتراح
            },
          );
        },
      );
    }

    // ترشيح الأسماء بناءً على نص البحث الحالي
    final suggestions = names.where((name) {
      final nameLower = name['name']?.toLowerCase() ??
          ''; // التعامل مع القيم المحتملة لـ null
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestions[index]['name']!),
          onTap: () {
            query = suggestions[index]['name']!;
            searchCallback(query);
            showResults(context); // عرض النتائج بعد اختيار اقتراح
          },
        );
      },
    );
  }
}
