// ignore_for_file: file_names

class ReportModel {
  int? id;
  String? date;
  String? event;
  int? count;

  ReportModel({
    this.id,
    this.date,
    this.event,
    this.count,
  });
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
        id: map['id'],
        date: map['date'],
        event: map['event'],
        count: map['count']);
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'date': date, 'event': event, 'count': count};
  }
}
