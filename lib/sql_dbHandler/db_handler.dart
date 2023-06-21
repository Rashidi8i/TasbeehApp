// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:tasbeehapp/models/alarmModel.dart';
import 'package:tasbeehapp/models/averageModel.dart';
import 'package:tasbeehapp/models/generatedreportModel.dart';
import 'package:tasbeehapp/models/reportModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'reportData.db');
    databaseFactory = databaseFactoryFfi;

    var db = await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE reportData2 (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, event TEXT NOT NULL, count TEXT NOT NULL)",
    );
    await db.execute(
      "CREATE TABLE alarmData (id INTEGER PRIMARY KEY AUTOINCREMENT, alarmTime TEXT NOT NULL, alarmDays TEXT NOT NULL)",
    );
  }

  Future<ReportModel> insert(ReportModel reportModel) async {
    var dbClient = await db;
    await dbClient!.insert('reportData2', reportModel.toMap());
    // delete(6);
    return reportModel;
  }

  Future<AlarmModel> insertAlarm(AlarmModel alarmModel) async {
    var dbClient = await db;
    await dbClient!.insert('alarmData', alarmModel.toMap());
    return alarmModel;
  }

  Future<List<AlarmModel>> getAlarmdata() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!
        .rawQuery('SELECT * From alarmData ORDER BY rowid DESC LIMIT 1');
    if (kDebugMode) {
      print(queryResult);
    }
    return queryResult.map<AlarmModel>((e) => AlarmModel.fromMap(e)).toList();
  }

  Future<List<ReportModel>> getreportList() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.query(
      'reportData2',
    );
    return queryResult.map<ReportModel>((e) => ReportModel.fromMap(e)).toList();
  }

  Future<List<ReportModel>> getsumreportList() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery(
        'SELECT id,date,event,SUM(count) AS count From reportData2 GROUP BY date,event');
    if (kDebugMode) {
      print(queryResult);
    }
    // delete(1);
    getaverage();
    return queryResult.map<ReportModel>((e) => ReportModel.fromMap(e)).toList();
  }

  Future<List<GeneratedReportModel>> getgeneratedList(
      String fromDate, String toDate) async {
    var dbClient = await db;
    fromDate = fromDate.split(' ')[0];
    toDate = toDate.split(' ')[0];
//     final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery(
//         '''
//   SELECT date,event,SUM(count) AS count From reportData2 WHERE date >= strftime('%Y-%m-%d', '$fromDate', '+0 days')
//     AND date <= strftime('%Y-%m-%d', '$toDate', '+0 days') GROUP BY date,event
// ''');
    final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery(
        "SELECT id,date,event,SUM(count) AS count From reportData2 WHERE date >= '$fromDate' AND date <= '$toDate' GROUP BY date,event");
    if (kDebugMode) {
      print('from Date $fromDate');
      print('to Date $toDate');
      print(queryResult);
    }

    //getaverageBydate(fromDate, toDate);
    return queryResult
        .map<GeneratedReportModel>((e) => GeneratedReportModel.fromMap(e))
        .toList();
  }

  Future<void> updateCount(String date, String event, String count) async {
    var dbClient = await db;
    // Get the last row with the specified date and event
    final lastRow = await dbClient!.rawQuery('''
    SELECT *
    FROM reportData2
    WHERE date = '$date' AND event = '$event'
    ORDER BY id DESC
    LIMIT 1
  ''');

    final lastRowId = lastRow[0]['id'];
    // Update count for the last row
    if (lastRow.isNotEmpty) {
      await dbClient.update(
        'reportData2',
        {'count': count.toString()},
        where: 'id = ?',
        whereArgs: [lastRowId],
      );
    }

    // Set count to 0 for other rows with the same date and event
    await dbClient.update(
      'reportData2',
      {'count': '0'},
      where: 'date = ? AND event = ? AND id != ?',
      whereArgs: [date, event, lastRowId],
    );
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!
        .delete('reportData2', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(ReportModel reportModel) async {
    var dbClient = await db;
    return await dbClient!.update('reportData2', reportModel.toMap(),
        where: 'id = ?', whereArgs: [reportModel.id]);
  }

  Future<List<AverageModel>> getaverageBydate(
      String fromDate, String toDate) async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery('''
  SELECT event, AVG(count) AS avgcount
  FROM (
    SELECT id, date, event, SUM(count) AS count
    FROM reportData2
    WHERE date >= '$fromDate' AND date <= '$toDate'
    GROUP BY date, event
  )
  GROUP BY event
''');
    if (kDebugMode) {
      print('getbyAvgdate');
      print(queryResult);
    }
    return queryResult
        .map<AverageModel>((e) => AverageModel.fromMap(e))
        .toList();
  }

  Future<List<AverageModel>> getaverage() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult = await dbClient!.rawQuery('''
  SELECT event, AVG(count) AS avgcount
  
  FROM (
    SELECT id, date, event, SUM(count) AS count
    FROM reportData2
    GROUP BY date, event
  )
  GROUP BY event
''');
    if (kDebugMode) {
      print('getAvg');
      print(queryResult);
    }
    return queryResult
        .map<AverageModel>((e) => AverageModel.fromMap(e))
        .toList();
  }
}
