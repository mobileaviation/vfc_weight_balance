import 'dart:io';
import 'WBData.dart';
import 'properties.dart' as props;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "wb_properties.db");
    print("DatabasePath: " + path);
    return await openDatabase(path, version: 1,
        onOpen: (db) {
      },
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE properties ("
        " id INTEGER PRIMARY KEY,"
        " field TEXT,"
        " int_value INTEGER,"
        " bool_value BIT,"
        " text_value TEXT"
        ")");
      });
  }
  
  newProperty(props.Property prop) async {
    final db = await database;
    //var res = await db.insert("properties", prop.toJson());
    String sql = "INSERT INTO properties (field, int_value, bool_value, text_value) VALUES (?, ?, ?, ?)";
    var res = await db.execute(sql, [prop.field, prop.intValue, prop.boolValue, prop.textValue]);
    return res;
  }

  updateProperty(props.Property prop) async {
    final db = await database;
    var res = await db.update("properties", prop.toJson(), where: "id = ?", whereArgs: [prop.id]);
    return res;
  }

  updatePropertyByField(props.Property prop) async {
    final db = await database;
    var res = await db.update("properties", prop.toJson(), where: "field = ?", whereArgs: [prop.field]);
    return res;
  }

  getPropertyByField(String field) async {
    final db = await database;
    var res = await db.query("properties", where: "field = ?", whereArgs: [field]);
    return res.isNotEmpty ? props.Property.fromJson(res.first) : null;
  }
}

Future<props.Property> getPropertyFromDB(String type, WBData data, bool boolValue) async
{
  DBProvider db = DBProvider.db;
  props.Property p = await db.getPropertyByField(type);
  if (p == null) {
    p = new props.Property(id: 0, field: type,
        intValue: (data!=null)? data.value.round(): 0,
        boolValue: boolValue, textValue: "");
    await db.newProperty(p);
  } else {
    if (data != null) data.value = p.intValue.toDouble();
  }
  if (data != null) data.property = p;
  return p;
}