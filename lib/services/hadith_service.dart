import 'dart:convert';
import 'package:flutter/services.dart';

class HadithService {
  static List<dynamic>? _hadiths;

  // تحميل البيانات مرة واحدة فقط
  static Future<List<dynamic>> loadHadiths() async {
    if (_hadiths == null) {
      final String response =
          await rootBundle.loadString('assets/hadith.json');
      _hadiths = json.decode(response);
    }
    return _hadiths!;
  }

  static Future<Map<String, dynamic>> getHadithById(int id) async {
    final hadiths = await loadHadiths();
    return hadiths.firstWhere((h) => h['id'] == id,
        orElse: () => {"id": id, "text": "غير موجود"});
  }
}
