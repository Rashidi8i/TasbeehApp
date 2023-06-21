// ignore_for_file: file_names

class GeneratedReportModel {
  int? id;
  String? date;
  String? event;
  int? count;

  GeneratedReportModel({
    this.id,
    this.date,
    this.event,
    this.count,
  });

  factory GeneratedReportModel.fromMap(Map<String, dynamic> map) {
    return GeneratedReportModel(
        id: map['id'],
        date: map['date'],
        event: map['event'],
        count: map['count']);
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'date': date, 'event': event, 'count': count};
  }
}
