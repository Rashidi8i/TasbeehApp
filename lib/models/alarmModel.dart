class AlarmModel {
  int? id;
  String? alarmTime;
  String? alarmDays;

  AlarmModel({this.id, required this.alarmTime, required this.alarmDays});

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
        id: map['id'],
        alarmTime: map['alarmTime'],
        alarmDays: map['alarmDays']);
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'alarmTime': alarmTime, 'alarmDays': alarmDays};
  }
}
