import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import '../resources/repository.dart';

class NewsDBProvider implements Source,Cache {
  Database db;

  NewsDBProvider() {
    init();
  }
  
  @override
  Future<List<int>> fetchTopIds() {
    return null;
  }
 
   void init() async {
     Directory documentsDirectory = await getApplicationDocumentsDirectory();
     final path = join(documentsDirectory.path,'item2.db');
     db = await openDatabase(
       path,
       version: 1,
       onCreate: (Database newDB, int version) {
         newDB.execute("""
           CREATE TABLE Item
           (
             id INTEGER PRIMARY KEY,
             type TEXT,
             by TEXT,
             time INTEGER,
             text TEXT,
             parent INTEGER,
             kids BLOB,
             dead INTEGER,
             deleted INTEGER,
             url TEXT,
             score INTEGER,
             title TEXT,
             descendant INTEGER
           )
         """);
       }
     );
   }
   Future<ItemModel> fetchItem(int id) async {
     final maps = await db.query(
       'Item',
       columns: null,
       where: 'id = ?',
       whereArgs: [id],
     );
     if(maps.length > 0) {
       
       return ItemModel.fromDB(maps.first);
     }
     return null;
   }
   Future<int> addItem(ItemModel item) {
     return db.insert('Item',
     item.toMap(),
     conflictAlgorithm: ConflictAlgorithm.ignore,
     );
     
   }
     
    Future<int> clear() {
      print("delete db called");
      return db.delete('Item');
    }
}

final newsDBProvider = NewsDBProvider();
