import 'package:flutter/material.dart';

class AddZikrPage extends StatefulWidget {
  @override
  _AddZikrPageState createState() => _AddZikrPageState();
}

class _AddZikrPageState extends State<AddZikrPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff00a2b5),
        centerTitle: true,
        title: const Text(
          'إضافة تسبيح',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // أيقونة في الأعلى
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff00a2b5).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_circle_outline,
                color: Color(0xff00a2b5),
                size: 70,
              ),
            ),
            const SizedBox(height: 40),

            // حقل إدخال التسبيح
            TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "Cairo",
              ),
              decoration: InputDecoration(
                hintText: "أدخل نص التسبيح",
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 18,
                  fontFamily: "Cairo",
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Color(0xff00a2b5), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:
                      const BorderSide(color: Color(0xff00a2b5), width: 2),
                ),
              ),
            ),

            const SizedBox(height: 50),

            // زر إضافة أنيق
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  final newZikr = _controller.text.trim();
                  if (newZikr.isNotEmpty) {
                    Navigator.pop(context, newZikr);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00a2b5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "إضافة التسبيح",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Cairo",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
