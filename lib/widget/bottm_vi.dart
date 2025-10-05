import 'package:flutter/material.dart';
import 'package:islam/azkar/views/azkar_homepage.dart';
import 'package:islam/screens/NamesOfAllahPage.dart';
import 'package:islam/screens/Rosary.dart';


class BottmVi extends StatefulWidget {
  final BottmV reqCard;
  const BottmVi({super.key, required this.reqCard});

  @override
  State<BottmVi> createState() => _CardListState();
}

class _CardListState extends State<BottmVi> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.reqCard.nav),
            );
          },
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  widget.reqCard.img,
                  height: 35,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.reqCard.name,
                  style: const TextStyle(
                    color: Color(0xffF8672F),
                    fontSize: 16,
                     fontFamily: 'UthmanTNB_v2-0',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CardBig extends StatelessWidget {
  final BottmV reqCard;

  const CardBig({super.key, required this.reqCard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 1,
        child:
      
       InkWell(
        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => reqCard.nav),
          );
        },
        child: Container(
       
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
          
              Text(
                reqCard.name,
                style: const TextStyle(
                  color: Color(0xffF8672F),
                  fontSize: 40,
                  fontFamily: "jomhuria"
                  
                ),
                textAlign: TextAlign.center,
              ),
      const SizedBox(width: 70),
              Image.asset(
                reqCard.img,
                height: 100,
                // color: Colors.white30,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class BottmV {
  final String name;
  final String img;
  final Widget nav;

  BottmV({required this.name, required this.img, required this.nav});
}



// ignore: camel_case_types
class Grid_Bottom extends StatelessWidget {
  const Grid_Bottom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true, // مهم عشان يكون داخل ListView
      physics: NeverScrollableScrollPhysics(), // منع السكروول الداخلي
      crossAxisCount: 3, // عدد الأعمدة في الجري
      children: [
        BottmVi(
          reqCard: BottmV(
            name: 'الأذكار و الأدعية',
            img: 'assets/azkar.png',
            nav: AzkarHomePage(),
          ),
        ),
        BottmVi(
          reqCard: BottmV(
            name: 'أسماء الله الحسني',
            img: 'assets/names.png',
            nav: NamesOfAllahPage(),
          ),
        ),
        BottmVi(
          reqCard: BottmV(
            name: 'السبحة',
            img: 'assets/sibha.png',
            nav: RosaryPage(),
          ),
        ),
        // BottmVi(
        //   reqCard: BottmV(
        //     name: 'أحاديث',
        //     img: 'assets/muhammed.png',
        //     nav:HadithLibraryScreen(),
        //   ),
        // ),
        // BottmVi(
        //   reqCard: BottmV(
        //     name: 'الرقية الشرعيه',
        //     img: 'assets/rqua.png',
        //     nav:HadithLibraryScreen(),
        //   ),
        // ),
       
       
      ],
    );
  }
}

