class Todo {
  final String id;
  final String todo;
  final bool check;
  Todo(this.id, this.todo, this.check);

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        todo = json['todo'],
        check = json['check'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'todo': todo,
        'check': check,
      };
}
