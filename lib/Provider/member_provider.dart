import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlitedb_demo/Model/member_model.dart';

class MemberProvider extends ChangeNotifier {
  Database? _db;
  List<MemberModel> _arrMember = [];

  //getter setter
  List<MemberModel> get arrMember => _arrMember;
  set arrMember(List<MemberModel> value) => _arrMember = value;

  //create Database
  Future<void> createDB() async {
    if (_db != null) {
      return;
    }
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "Member_db");
    var db = await openDatabase(path, version: 1, onCreate: createTable);
    _db = db;
  }

  //create table
  void createTable(Database db, int version) async {
    db.execute(
        "create table Member(id int primary key,name text,phone text,typeId int,typeName text)");
  }

  //addMember
  Future<void> addMember(
      int id, String name, String phone, int typeId, String typeName) async {
    try {
      await _db?.rawInsert(
          "insert into Member (id,name,phone,typeId,typeName) values (?,?,?,?,?)",
          [id, name, phone, typeId, typeName]);
      await getAllMember();
    } catch (e) {
      rethrow;
    }
  }

  //get All member
  Future<void> getAllMember() async {
    try {
      List<Map<String, Object?>>? data =
          await _db?.rawQuery("select * from Member ORDER BY name ASC ");
      arrMember = data?.map((item) {
            return MemberModel.fromJson(item);
          }).toList() ??
          [];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  //edit mobile
  Future<void> editMobile(int id, String phone) async {
    try {
      await _db
          ?.rawUpdate('UPDATE Member SET phone = ? WHERE id = ?', [phone, id]);

      await getAllMember();
    } catch (e) {
      rethrow;
    }
  }

  //delete member
  Future<void> deleteMember(int id) async {
    try {
      await _db?.rawDelete(
        'DELETE FROM Member WHERE id = ?',
        [id],
      );
      await getAllMember();
    } catch (e) {
      rethrow;
    }
  }
}
