import 'package:geolocator/geolocator.dart';


// دالة للحصول على الموقع الحالي
Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // 1. التأكد أن خدمة الموقع مفعلة
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // هنا ممكن تعرض رسالة للمستخدم تطلبه يشغل خدمة الموقع
    print('خدمة الموقع غير مفعلة. الرجاء تفعيلها.');
    return null;
  }

  // 2. التحقق من إذن الموقع
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('تم رفض إذن الوصول للموقع.');
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // الإذن مرفوض نهائيًا، لازم توجه المستخدم لإعدادات الجهاز
    print('تم رفض الإذن نهائيًا. الرجاء تعديل الإعدادات.');
    return null;
  }

  // 3. جلب الموقع الحالي
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  print('الإحداثيات: ${position.latitude}, ${position.longitude}');
  return position;
}
