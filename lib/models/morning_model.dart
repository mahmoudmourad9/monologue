class Morning {
  final String text;
  final int count;

  Morning({required this.text, required this.count});

  factory Morning.fromJson(Map<String, dynamic> json) {
    return Morning(
      text: json['text'],
      count: json['count'],
    );
  }
}
