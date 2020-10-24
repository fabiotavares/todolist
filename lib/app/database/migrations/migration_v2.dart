import 'package:sqflite/sqflite.dart';

void createV2(Batch batch) {
  // apenas como exemplo para estudos
  batch.execute('''
    create table teste (id integer primary)
  ''');
}

void upgradeV2(Batch batch) {
  // apenas como exemplo para estudos
  batch.execute('''
    create table teste (id integer primary)
  ''');
}
