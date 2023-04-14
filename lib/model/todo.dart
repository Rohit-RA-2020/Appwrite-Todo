import 'dart:convert';

class Todo {
  Todo({
    required this.content,
    this.isComplete = false,
    required this.id,
  });

  String content;
  bool isComplete;
  String id;

  factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        content: json["content"],
        isComplete: json["isComplete"],
        id: json["\u0024id"],
      );

  Map<String, dynamic> toMap() {
    final map = {
      "content": content,
      "isComplete": isComplete,
      "\u0024id": id,
    };

    return map;
  }
}
