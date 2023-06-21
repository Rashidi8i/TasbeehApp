// ignore_for_file: file_names

class AverageModel {
  String? event;
  double? avgcount;

  AverageModel({
    this.event,
    this.avgcount,
  });

  factory AverageModel.fromMap(Map<String, dynamic> map) {
    return AverageModel(event: map['event'], avgcount: map['avgcount']);
  }

  Map<String, Object?> toMap() {
    return {'event': event, 'avgcount': avgcount};
  }
}
