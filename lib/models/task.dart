class Task {
  int? id;
  String? title;
  String? description;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  String? location;
  String? category;
  int? color;
  int? remind;
  String? repeat;
  String? photoPath;
  String? videoPath;
  String? filePath;

  Task(
      {this.id,
      this.title,
      this.description,
      this.isCompleted,
      this.date,
      this.startTime,
      this.endTime,
      this.location,
      this.category,
      this.color,
      this.remind,
      this.repeat,
      this.photoPath,
      this.videoPath,
      this.filePath});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    location = json['location'];
    category = json['category'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
    photoPath = json['photoPath'];
    videoPath = json['videoPath'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['date'] = this.date;
    data['description'] = this.description;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['location'] = this.location;
    data['category'] = this.category;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    data['photoPath'] = this.photoPath;
    data['videoPath'] = this.videoPath;
    data['filePath'] = this.filePath;
    return data;
  }
}
