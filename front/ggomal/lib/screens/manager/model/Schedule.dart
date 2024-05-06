class Schedule{
  final int id;
  final int startTime;
  final int endTime;
  final String content;
  final DateTime date;
  final String color;
  final DateTime createdAt;

  Schedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.date,
    required this.color,
    required this.createdAt,
  });

}