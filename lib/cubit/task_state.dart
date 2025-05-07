class TaskState {
  late List<Map<String, dynamic>> taskDatas;

  TaskState(this.taskDatas);

  TaskState.initialize() : taskDatas = List.empty();
}
