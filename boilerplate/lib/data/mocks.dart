import 'package:boilerplate/models/todo.dart';

abstract class Mocks {
  static List<Todo> todos = [
    Todo(
      id: "1",
      done: true,
      todo: "Do something",
    ),
    Todo(
      id: "2",
      done: false,
      todo: "Eat an apple",
    ),
    Todo(
      id: "3",
      done: false,
      todo: "Buy a shirt",
    ),
  ];
}
