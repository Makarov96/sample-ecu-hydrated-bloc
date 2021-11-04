import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:ecu_hydrated_bloc/core/error/exception.dart';
import 'package:ecu_hydrated_bloc/feature/user/data/model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUserList();
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  @override
  Future<UserModel> getUserList() async {
    var rng = Random();
    try {
      final response = await http.get(
        Uri.parse(
            'https://reqres.in/api/users?page=${rng.nextInt(30).clamp(1, 2)}'),
      );
      final users = UserModel.fromJson(
        jsonDecode(response.body),
      );
      return users;
    } catch (_) {
      throw ServerException();
    }
  }
}
