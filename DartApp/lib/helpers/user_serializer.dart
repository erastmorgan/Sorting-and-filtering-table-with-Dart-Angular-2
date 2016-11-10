import 'package:DartApp/models/address.dart';
import 'package:DartApp/models/user.dart';

class UserSerializer {
  static List<User> Deserialize(var userMap) {
    var users = new List<User>();
    for (var user in userMap) {
      var address = user['address'];
      users.add(
          new User(
              user['id'],
              user['name'],
              user['age'],
              user['gender'],
              user['department'],
              new Address(address['city'], address['street'])));
    }

    return users;
  }
}