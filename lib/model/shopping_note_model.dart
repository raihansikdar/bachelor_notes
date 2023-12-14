class ShoppingNoteModel{
  final int? id;
  final String? time;
  final String? date;
  final String? title;
  final double? capital;
  final double? remain;
  List<String>? itemTitles;
  List<double>? prices;
  final double? totalCost;

  ShoppingNoteModel({
    this.id,
    this.time,
    this.date,
    this.title,
    this.capital,
    this.remain,
    this.itemTitles,
    this.prices,
    this.totalCost,
  });

  factory ShoppingNoteModel.fromJson(Map<String,dynamic>json){
     return ShoppingNoteModel(
         id: json['id'],
         time: json['time'],
         date: json['date'],
         title: json['title'],
         capital: json['capital'],
         remain: json['remain'],
         itemTitles: List<String>.from(json['itemTitles']?.split(', ') ?? []),
         prices: List<double>.from(json['prices']?.split(', ')?.map((e) => double.parse(e)) ?? []),
         totalCost: json['totalCost'],
     );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'date': date,
      'title': title,
      'capital': capital,
      'remain': remain,
      'itemTitles': itemTitles?.join(', ') ?? '',
      'prices': prices?.join(', ') ?? '',
      'totalCost': totalCost,
    };
  }

}