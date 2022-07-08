final String tableStudent = 'students';

class StudentFields {
  static final String id = 'uid';
  static final String marks = 'marks';
  static final String name = 'name';
  static final String studentId = 'studentId';
}

class Student {
  int? studentId;
  String? name;
  int? marks;
  String? id;
  int? rank = 0;

  static Student fromJson(Map<String, Object?> json) => Student(
    json[StudentFields.name] as String,
    json[StudentFields.studentId] as int,
    json[StudentFields.marks] as int,
    json[StudentFields.id] as String,
  );

  Map<String, Object?> toJson() => {
    StudentFields.id: id,
    StudentFields.name: name,
    StudentFields.marks: marks,
    StudentFields.studentId: studentId,
  };

  Student(this.name, this.studentId, this.marks, this.id);
  @override
  String toString() {
    return '{ ${this.name}, ${this.studentId},${this.marks} ,${this.rank}, ${this.id}}';
  }
}
