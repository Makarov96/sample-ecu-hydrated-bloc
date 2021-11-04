import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecu_hydrated_bloc/feature/user/data/model/user_model.dart';
import 'package:ecu_hydrated_bloc/feature/user/presentation/bloc/user_bloc.dart';
import 'package:ecu_hydrated_bloc/feature/user/data/datasource/user_repository.dart';
import 'package:ecu_hydrated_bloc/feature/user/data/datasource/user_remote_data_source.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        UserRepositoryImpl(
          UserRemoteDataSourceImpl(),
        ),
      ),
      child: const Scaffold(
        body: UserScreenLayout(),
        floatingActionButton: CustomFloatingButton(),
      ),
    );
  }
}

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.read<UserBloc>().add(
            UserCallApiEvent(),
          ),
      child: const Center(
        child: Icon(
          Icons.clear,
        ),
      ),
    );
  }
}

class UserScreenLayout extends StatefulWidget {
  const UserScreenLayout({Key? key}) : super(key: key);

  @override
  State<UserScreenLayout> createState() => _UserScreenLayoutState();
}

class _UserScreenLayoutState extends State<UserScreenLayout> {
  @override
  void initState() {
    Future.delayed(Duration.zero, _callToAction);
    super.initState();
  }

  void _callToAction() {
    final bloc = context.read<UserBloc>();

    if (bloc.state is! UserLoaded) {
      context.read<UserBloc>().add(
            UserCallApiEvent(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          showDialog(
            context: context,
            builder: (_) => Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 300,
              ),
              child: Center(
                child: Text(
                  state.message,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UserInitial) {
          return const Center(
            child: Text(
              'No hay datos para mostrar',
            ),
          );
        }
        if (state is UserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is UserLoaded) {
          return CustomListView(
            users: state.users,
          );
        }
        if (state is UserError) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CustomListView extends StatelessWidget {
  const CustomListView({
    Key? key,
    required this.users,
  }) : super(key: key);

  final UserModel users;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.data.length,
      itemBuilder: (_, index) {
        return SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  users.data[index].avatar,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                users.data[index].firstName,
              )
            ],
          ),
        );
      },
    );
  }
}
