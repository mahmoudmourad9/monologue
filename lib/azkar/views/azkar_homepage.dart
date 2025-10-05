import 'package:flutter/material.dart';
import 'package:islam/azkar/views/zikr_detailspage.dart';
import '../data/azkar.dart';
import '../model/dua_model.dart';

class AzkarHomePage extends StatefulWidget {
  const AzkarHomePage({super.key});

  @override
  State<AzkarHomePage> createState() => _AzkarHomePageState();
}

class _AzkarHomePageState extends State<AzkarHomePage> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    // فلترة حسب البحث
    final filteredAzkar = azkar.where((item) {
      final category = item["category"]?.toString() ?? "";
      return category.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00a2b5),
        title: const Text("الأذكار والأدعية",style: TextStyle(fontSize: 28,color: Colors.white),),
        centerTitle: true,
        
      ),
      body:
       Container(
       decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/background.png"), // حط الصورة هنا
          //   fit: BoxFit.cover, // تخلي الصورة تغطي الشاشة
          // ),

          // gradient: LinearGradient(
          //   colors: [
          //     Color(0xFFF5F5DC), // Beige فاتح
          //     Color(0xFF8B5E3C), // بني غامق
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
         child: Column(
          children: [
            
            // خانة البحث
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  
                  hintText: "البحث عن الدعاء / الذكر",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
            ),
         
            // القائمة
            Expanded(
              child: ListView.builder(
                itemCount: filteredAzkar.length,
                itemBuilder: (context, i) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: ListTile(
                      // تغيير الاتجاه هنا لجعل الأيقونة في الشمال
                      leading: const Icon(Icons.arrow_back_ios,
                          color: Colors.orange),  // أيقونة في الشمال
                      title: Text(
                        filteredAzkar[i]["category"],
                        textAlign: TextAlign.right,
                         style: const TextStyle(
                      fontSize: 24,
                      color:Colors.black,
                      fontFamily: 'UthmanTNB_v2-0',
                    ),  ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ZikrPage(
                                zikr: DuaModel.fromJson(filteredAzkar[i])),
                          ),
                        );
                      },
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
