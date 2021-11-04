import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:ecu_hydrated_bloc/feature/user/data/model/user_model.dart';
import 'package:ecu_hydrated_bloc/feature/user/data/datasource/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  final UserRespository repository;

  UserBloc(this.repository)
      : super(
          UserInitial(),
        ) {
    on<UserCallApiEvent>(_callToGetMethod);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    if (state is UserLoaded) {
      return state.users.toJson();
    }
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    try {
      final users = UserModel.fromJson(json);
      return UserLoaded(users: users);
    } catch (e) {
      log(
        e.toString(),
      );
    }
  }

  FutureOr<void> _callToGetMethod(
      UserCallApiEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final either = await repository.getUsers();
    either.fold(
      (failure) {
        emit(
          UserError('Dont get users'),
        );
      },
      (users) {
        emit(
          UserLoaded(
            users: users,
          ),
        );
      },
    );
  }
}
