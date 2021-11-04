part of 'user_bloc.dart';

@immutable
abstract class UserState extends Equatable {}

class UserInitial extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoaded extends UserState {
  final UserModel users;
  UserLoaded({
    required this.users,
  });
  @override
  List<Object?> get props => [users];
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
  @override
  List<Object?> get props => [];
}
