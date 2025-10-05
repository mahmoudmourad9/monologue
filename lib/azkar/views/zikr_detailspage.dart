import 'package:flutter/material.dart';
import '../model/dua_model.dart';

class ZikrPage extends StatefulWidget {
  final DuaModel zikr;

  const ZikrPage({super.key, required this.zikr});

  @override
  State<ZikrPage> createState() => _ZikrPageState();
}

class _ZikrPageState extends State<ZikrPage> {
  // لا نحتاج لتعريف counter هنا لأننا سنعتمد على كل عنصر من عناصر dua
  void _decrementCounter(int index) {
    setState(() {
      if (widget.zikr.array[index].count > 0) {
        widget.zikr.array[index].count--;
      } else {
        // الانتقال للذكر التالي إذا كان موجود
        if (index < widget.zikr.array.length - 1) {
          widget.zikr.array[index + 1].count = widget.zikr.array[index + 1].count;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color(0xff00a2b5),
        centerTitle: true,
        title: Text(
          widget.zikr.category,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontFamily: 'UthmanTNB_v2-0',
          ),
        ),
       
        elevation: 5,
        // ignore: deprecated_member_use
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: ListView.builder(
        itemCount: widget.zikr.array.length,
        itemBuilder: (context, index) {
          var currentDua = widget.zikr.array[index];
         Color containerColor = currentDua.count > 0
    ? const Color(0xFFFAFAFA)   // Beige
    : Color.fromARGB(255, 47, 225, 248);

          return GestureDetector(
            onTap: () => _decrementCounter(index),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xff00a2b5), width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentDua.text,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'UthmanTNB_v2-0',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Divider(indent: 10, endIndent: 10, color: Colors.black,),
                  Text(
                    currentDua.count > 0 ? '${currentDua.count}' : 'تم الانتهاء ',
                    style: TextStyle(
                      color: currentDua.count > 0 ? Colors.amber : Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
