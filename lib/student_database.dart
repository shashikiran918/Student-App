
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_app/student.dart';

class StudentDatabase {
  static final StudentDatabase instance = StudentDatabase._init();

  static Database? _database;

  StudentDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableStudent ( 
  ${StudentFields.id} $textType, 
  ${StudentFields.marks} $integerType,
  ${StudentFields.name} $textType,
  ${StudentFields.studentId} $integerType
 
  )
''');
  }

  Future<void> create(Student student) async {
    final db = await instance.database;

    final id = await db.insert(tableStudent, student.toJson());
  }

  Future<List<Student>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(tableStudent);

    return result.map((json) => Student.fromJson(json)).toList();
  }

  Future<int> update(Student student) async {
    final db = await instance.database;

    return db.update(
      tableStudent,
      student.toJson(),
      where: '${StudentFields.id} = ?',
      whereArgs: [student.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableStudent,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
