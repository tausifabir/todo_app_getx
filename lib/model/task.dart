class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? reminderTime;
  String? repeatTime;
  int? color;
  int? isCompleted;

  Task({
    this.id,
    this.title,
    required this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.reminderTime,
    this.repeatTime,
    this.color,
    this.isCompleted,
  });

  Task.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.note = json['note'];
    this.date = json['date'];
    this.startTime = json['startDate'];
    this.endTime = json['endDate'];
    this.reminderTime = json['reminderTime'];
    this.repeatTime = json['repeatTime'];
    this.color = json['color'];
    this.isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['note'] = this.note;
    data['date'] = this.date;
    data['startTime'] = this.startTime;
    data['startTime'] = this.endTime;
    data['reminderTime'] = this.reminderTime;
    data['repeatTime'] = this.repeatTime;
    data['color'] = this.color;
    data['isCompleted'] = this.isCompleted;

    return data;
  }
}
