String formatTime12h(String time24) {
  try {
    final parts = time24.split(':'); // نفصل الساعات والدقائق
    int hour = int.parse(parts[0]); // ناخد الساعة كعدد صحيح
    final minute = parts[1];        // دقائق كنص
    final suffix = hour >= 12 ? 'م' : 'ص'; // بعد الظهر أو صباحاً بالعربي
    hour = hour % 12 == 0 ? 12 : hour % 12; // نعدل الساعة لـ 12 ساعة

    // نرجع الوقت بالشكل المطلوب، مثلاً: 1:05 ص
    return '$hour:$minute $suffix';
  } catch (e) {
    // لو حصل خطأ نرجع النص كما هو (لضمان عدم كسر التطبيق)
    return time24;
  }
}