import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskify/auth/auth_service.dart';
import 'package:taskify/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState.initialize());

  // void updateUserData() => emit(UserState(AuthService().getUserData()));
  void updateUserData() async {
    print("Updating User Data...");
    try {
      final userData = await AuthService().getUserData();
      emit(UserState(userData ?? []));
      print(userData?[0]);
    } catch (e) {
      print("Error $e");
      emit(UserState([]));
    }
  }
}
