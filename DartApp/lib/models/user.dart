import 'package:DartApp/models/address.dart';

class User {
  String id;
  String name;
  int age;
  String gender;
  String department;
  Address address;

  User(var id, var name, var age, var gender, var department, var address) {
    this.id = id;
    this.name = name;
    this.age = age;
    this.gender = gender;
    this.department = department;
    this.address = address;
  }
}