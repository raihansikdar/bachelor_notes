class NoteModel{
  final int? id;
  final String? time;
  final String? date;
  final String? title;
  final String? note;


  NoteModel({
    this.id,
    this.time,
    this.date,
    this.title,
    this.note,
  });
  factory NoteModel.fromJson(Map<String,dynamic>json){
    return NoteModel(
      id: json['id'],
      time: json['time'],
      date: json['date'],
      title: json['title'],
      note: json['note'],
    );
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic> data = <String,dynamic>{};
    data['id'] = id;
    data['time'] = time;
    data['date'] = date;
    data['title'] = title;
    data['note'] = note;

    return data;
  }

  @override
  String toString() {
    return 'NoteModel{id: $id, time:$time, date: $date,title: $title, note: $note, }';
  }
}