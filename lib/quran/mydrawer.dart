import 'package:flutter/material.dart';
import 'package:islam/quran/settings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA), // لون خلفية الهيدر
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/1111111.png',
                  height: 100,
                ),
               
                const Text(
                  'مُناجاة',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Amiri', // لو ضايف خط عربي
                  ),
                ),
              ],
            ),
          ),

          // Settings
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.black),
            title: const Text(
              'الإعدادات',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),

        ],
      ),
    );
  }
}
