import 'package:dartz/dartz.dart';
import 'package:ecu_hydrated_bloc/core/error/exception.dart';
import 'package:ecu_hydrated_bloc/core/error/failure.dart';
import 'package:ecu_hydrated_bloc/feature/user/data/datasource/user_remote_data_source.dart';
import 'package:ecu_hydrated_bloc/feature/user/data/model/user_model.dart';

abstract class UserRespository {
  Future<Either<Failure, UserModel>> getUsers();
}

class UserRepositoryImpl implements UserRespository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, UserModel>> getUsers() async {
    try {
      final users = await remoteDataSource.getUserList();
      return Right(users);
    } on ServerException {
      return Left(
        ServerFailure(),
      );
    }
  }
}
