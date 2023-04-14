import 'package:flutter/material.dart';
import 'package:my_app/services/todos.dart';
import 'package:my_app/widgets/utils.dart';

import '../model/todo.dart';
import '../widgets/todo_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];
  final todosService = TodosService();
  final inputController = TextEditingController();
  bool taskCompletedFilter = false;

  bool isLoading = true;

  void fetchTodos() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await todosService.fetch();
      setState(() {
        todos = result;
      });
    } catch (e) {
      messenger.showSnackBar(myOwnSnackBar(e.toString()));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void uploadTodo() async {
    if (inputController.text.isEmpty || isLoading) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      final newTodo = await todosService.create(content: inputController.text);
      inputController.text = '';
      setState(() {
        todos.add(newTodo);
      });
    } catch (e) {
      messenger.showSnackBar(myOwnSnackBar(e.toString()));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/todo.png', width: 100),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'On Your Mind? Write it down',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: taskCompletedFilter,
                    onChanged: (value) {
                      setState(() {
                        taskCompletedFilter = value;
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        await todosService.deleteAll();
                        setState(() {
                          todos = [];
                        });
                      } catch (e) {
                        messenger.showSnackBar(myOwnSnackBar(e.toString()));
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    icon: const Icon(Icons.dangerous),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: inputController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    uploadTodo();
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(),
                    hintText: "💭 What's your plan? ",
                    suffixIcon: IconButton(
                      onPressed: uploadTodo,
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ),
              ),
              if (todos.isNotEmpty)
                ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: todos.length,
                  shrinkWrap: true,
                  prototypeItem: TodoListTile(todo: todos.first),
                  itemBuilder: (context, index) {
                    return taskCompletedFilter
                        ? !todos[index].isComplete
                            ? TodoListTile(
                                todo: todos[index],
                                delete: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  try {
                                    await todosService.delete(
                                        id: todos[index].id);
                                    setState(() {
                                      todos.removeAt(index);
                                    });
                                  } catch (e) {
                                    // restore value
                                    todos[index].isComplete =
                                        !todos[index].isComplete;
                                    messenger.showSnackBar(
                                        myOwnSnackBar(e.toString()));
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                                toggle: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  todos[index].isComplete =
                                      !todos[index].isComplete;
                                  try {
                                    final updated = await todosService.update(
                                      todo: todos[index],
                                    );
                                    setState(() {
                                      todos[index] = updated;
                                    });
                                  } catch (e) {
                                    todos[index].isComplete =
                                        !todos[index].isComplete;
                                    messenger.showSnackBar(
                                        myOwnSnackBar(e.toString()));
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                              )
                            : null
                        : TodoListTile(
                            todo: todos[index],
                            toggle: () async {
                              setState(() {
                                isLoading = true;
                              });
                              final messenger = ScaffoldMessenger.of(context);
                              todos[index].isComplete =
                                  !todos[index].isComplete;
                              try {
                                final updated = await todosService.update(
                                    todo: todos[index]);
                                setState(() {
                                  todos[index] = updated;
                                });
                              } catch (e) {
                                // restore value
                                todos[index].isComplete =
                                    !todos[index].isComplete;
                                messenger
                                    .showSnackBar(myOwnSnackBar(e.toString()));
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            delete: () async {
                              setState(() {
                                isLoading = true;
                              });
                              final messenger = ScaffoldMessenger.of(context);
                              try {
                                await todosService.delete(id: todos[index].id);
                                setState(() {
                                  todos.removeAt(index);
                                });
                              } catch (e) {
                                // restore value
                                todos[index].isComplete =
                                    !todos[index].isComplete;
                                messenger
                                    .showSnackBar(myOwnSnackBar(e.toString()));
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                          );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
