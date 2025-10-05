import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/morning_model.dart';

class AzkarService {
  static Future<List<Morning>> fetchMorningAzkar() async {
    final String response = await rootBundle.loadString('assets/azkar.json');
    final jsonData = json.decode(response);

    final List<dynamic> azkarList = jsonData['morning_azkar'];
    return azkarList.map((item) => Morning.fromJson(item)).toList();
  }
}
