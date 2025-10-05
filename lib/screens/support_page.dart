import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});



  // فتح روابط
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'تعذر فتح الرابط $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f9fc),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff006d77),
        title: const Text(
          "الدعم والمساعدة",
          style: TextStyle(
            fontFamily: "cairo",
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [


          const SizedBox(height: 16),

          // كارت عن المطور
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "عن مطور التطبيق",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff006d77),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'محمود مراد\n',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'jomhuria'),
                              
                        ),
                        TextSpan(
                          text:
                              ' طالب بالفرقة الرابعة، كلية التربية النوعية.\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'UthmanTNB_v2-0'),
                        ),
                        TextSpan(
                          text: ' إعداد معلم حاسب آلي (لغة إنجليزية).\n',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'UthmanTNB_v2-0'),
                        ),
                        TextSpan(
                          text:
                              '\nبفضل من الله، سخّرتُ ما تعلمت لأخدم به ديني وأمتي، وأعمل جاهداً على تقديم كل ما هو نافع لإخواني المسلمين، سائلاً المولى عز وجل أن يبارك في جهدي، وأن يجعله علماً ينتفع به في الدنيا والآخرة.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'UthmanTNB_v2-0'),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 10),

                  // أزرار التواصل
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl("https://t.me/Mahmo_0"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.telegram),
                        label: const Text("Telegram"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _launchUrl("https://wa.me/201027821272"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.whatsapp),
                        label: const Text("WhatsApp"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl(
                            "https://www.linkedin.com/in/mahmoud-mourad-19233b247/"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.linkedin),
                        label: const Text("LinkedIn"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _launchUrl("tel:01027821272"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const FaIcon(FontAwesomeIcons.phone),
                        label: const Text("call me"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // كارت فلسطين
          _buildCard(
            color: Colors.redAccent,
            title: "تذكير مهم",
            subtitle:
                "لا تنسوا الدعاء لإخواننا في فلسطين 🇵🇸\nاللهم انصرهم وثبت أقدامهم واربط على قلوبهم 🤲",
            buttonText: "اللهم انصرهم",
            buttonIcon: Icons.favorite,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required Color color,
    required String title,
    required String subtitle,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: Icon(buttonIcon),
              label: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
