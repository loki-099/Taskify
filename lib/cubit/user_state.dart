class UserState {
  late List<Map<String, dynamic>> userData;

  UserState(this.userData);

  UserState.initialize() : userData = List.empty();
}
