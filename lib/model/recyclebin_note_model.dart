class RycleBinNoteModel{
  final int? id;
  final String? time;
  final String? date;
  final String? deletedDate;
  final String? title;
  final String? note;


  RycleBinNoteModel({
    this.id,
    this.time,
    this.date,
    this.deletedDate,
    this.title,
    this.note,
  });
  factory RycleBinNoteModel.fromJson(Map<String,dynamic>json){
    return RycleBinNoteModel(
      id: json['id'],
      time: json['time'],
      date: json['date'],
      deletedDate: json['deletedDate'],
      title: json['title'],
      note: json['note'],
    );
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic> data = <String,dynamic>{};
    data['id'] = id;
    data['time'] = time;
    data['date'] = date;
    data['deletedDate'] = deletedDate;
    data['title'] = title;
    data['note'] = note;

    return data;
  }

  @override
  String toString() {
    return 'TrashNoteModel{id: $id,time:$time, date: $date, deletedDate: $deletedDate, title: $title, note: $note, }';
  }
}