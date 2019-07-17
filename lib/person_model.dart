class Person {
  // ignore: unused_field
  String _personId;
  String name;
  int age;

  Person({this.name, this.age}) : _personId = '';

  void _mapThis(Map data) {
    this.name = data['name'] ?? '';
    this.age = data['age'] ?? '';
  }

  Person.fromMap(Map data) {
    _mapThis(data);
  }

  Person.fromMapWithDocId({String personId, Map data}) {
    this._personId = personId;
    _mapThis(data);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    return data;
  }
}
