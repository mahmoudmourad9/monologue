import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islam/screens/AddZikrPage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RosaryPage extends StatefulWidget {
  const RosaryPage({super.key});

  @override
  State<RosaryPage> createState() => _RosaryPageState();
}

class _RosaryPageState extends State<RosaryPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  late Box box;
  late AnimationController _animationController;

  List<Map<String, dynamic>> defaultTasbihat = [
    {'name': 'سُبْحَانَ اللَّهِ', 'count': 0, 'fixed': true},
    {'name': 'الْحَمْدُ لِلَّهِ', 'count': 0, 'fixed': true},
    {'name': 'اللَّهُ أَكْبَرُ', 'count': 0, 'fixed': true},
    {'name': 'أَسْتَغْفِرُ اللَّهَ', 'count': 0, 'fixed': true},
    {
      'name':
          'أَسْتَغْفِرُ اللَّهَ رَبِّي مِنْ كُلِّ ذَنْبٍ وَأَتُوبُ إِلَيْهِ',
      'count': 0,
      'fixed': true
    },
  ];

  @override
  void initState() {
    super.initState();
    box = Hive.box('tasbihBox');

    // تهيئة AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.9,
      upperBound: 1.0,
    );

    // تحميل التسابيح الافتراضية لو الصندوق فاضي
    if (box.get('tasbihat') == null) {
      box.put('tasbihat', defaultTasbihat);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getTasbihat() {
    return (box.get('tasbihat') as List?)
            ?.map((item) => Map<String, dynamic>.from(item as Map))
            .toList() ??
        [];
  }

  void _addZikr(String newZikr) {
    final tasbihat = _getTasbihat();
    tasbihat.add({'name': newZikr, 'count': 0, 'fixed': false});
    box.put('tasbihat', tasbihat);
  }

  void _deleteZikr(int index) {
    final tasbihat = _getTasbihat();
    if (!(tasbihat[index]['fixed'] ?? false)) {
      tasbihat.removeAt(index);
      box.put('tasbihat', tasbihat);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لا يمكن حذف الأذكار الافتراضية")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00a2b5),
        centerTitle: true,
        title: const Text(
          "السبحة",
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 32, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddZikrPage()),
              ).then((newZikr) {
                if (newZikr != null && newZikr.isNotEmpty) {
                  _addZikr(newZikr);
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bac.jpg'), fit: BoxFit.cover),
        ),
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, box, _) {
            final tasbihat = _getTasbihat();

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: tasbihat.length,
                    itemBuilder: (context, index) {
                      final tasbih = tasbihat[index];

                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.3)).clamp(0.85, 1.0);
                          }

                          return Transform.scale(
                            scale: value,
                            child: GestureDetector(
                              onTap: () {
                                _animationController.forward().then(
                                    (_) => _animationController.reverse());
                                tasbih['count']++;
                                tasbihat[index] = tasbih;
                                box.put('tasbihat', tasbihat);
                              },
                              child: Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 40),
                                color: Colors.white.withOpacity(0.95),
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Stack(
                                    children: [
                                      // المحتوى في النص
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            tasbih['name'],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontFamily: 'UthmanTNB_v2-0',
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            '${tasbih['count']}',
                                            style: const TextStyle(
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.indigo,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Divider(
                                            color:
                                                Colors.indigo.withOpacity(0.4),
                                            thickness: 1,
                                            indent: 40,
                                            endIndent: 40,
                                          ),
                                          const SizedBox(height: 30),
                                          ScaleTransition(
                                            scale: _animationController,
                                            child: Container(
                                              height: 120,
                                              width: 120,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff00a2b5),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 8,
                                                    offset: Offset(2, 4),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.touch_app,
                                                size: 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // زر الحذف داخل الكارت (يمين فوق)
                                      if (!(tasbih['fixed'] ?? false))
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => _deleteZikr(index),
                                            child: const CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.close,
                                                  color: Colors.white,
                                                  size: 18),
                                            ),
                                          ),
                                        ),

                                      // زر الريسيت (شمال فوق)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: GestureDetector(
                                          onTap: () {
                                            tasbih['count'] = 0;
                                            tasbihat[index] = tasbih;
                                            box.put('tasbihat', tasbihat);
                                          },
                                          child: const CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.black26,
                                            child: Icon(Icons.restore,
                                                color: Colors.white, size: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // المؤشر تحت
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: tasbihat.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: const Color(0xff00a2b5),
                      dotColor: Colors.grey.shade600,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
