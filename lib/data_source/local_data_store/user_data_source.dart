import 'package:rootnode/helper/objectbox.dart';
import 'package:rootnode/model/user/user.dart';
import 'package:rootnode/state/objectbox_state.dart';

class UserDataSource {
  ObjectBoxInstance get objectBoxInstance => ObjectBoxState.objectBoxInstance!;
  Future<int> saveUser(User user) async {
    try {
      return objectBoxInstance.saveUser(user);
    } catch (e) {
      return 0;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      return objectBoxInstance.loginUser(email, password);
    } catch (e) {
      return false;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      return objectBoxInstance.getAllUser();
    } catch (e) {
      throw Exception("Error in getting all users");
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      return objectBoxInstance.getUserById(id);
    } catch (err) {
      return null;
    }
  }
}
