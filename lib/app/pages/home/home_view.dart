import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/home/home_controller.dart';
import 'package:dazle/app/widgets/user_data.dart';
import 'package:dazle/data/repositories/data_todo_repository.dart';
import 'package:dazle/domain/entities/todo.dart';
import 'package:dazle/data/constants.dart';



class HomePage extends View {
  static const String id = 'home_page';

  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState() : super(HomeController(DataTodoRepository()));

  updateDialog({HomeController controller, String id, bool check}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          title: Text('Update Data', style: TextStyle(fontSize: 15.0)),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: controller.updateTodoTextController,
                decoration: InputDecoration(
                  labelText: 'Update Todo task',
                  hintText: 'Update the todo task',
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      TextButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        }
                      ),
                      TextButton(
                        child: Text('SAVED'),
                        onPressed: () {
                          print('update on saved');
                          controller.updateTodo(id, controller.updateTodoTextController.text, check);
                          Navigator.pop(context);
                        }
                      )
                    ],
                  ),
                )
              ],
            )
          ]
        );
      },
    );
  }

  deleteDialog({HomeController controller, String id, bool check}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          title: Text('Delete Todo', style: TextStyle(fontSize: 15.0)),
          content: Text('Are you sure?', style: TextStyle(fontSize: 15.0)),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                controller.deleteTodo(id, check);
                Navigator.pop(context);
              }
            ),
          ],
        );
      },
    );
  }

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(Constants.appName),
        actions: [
          ControlledWidgetBuilder<HomeController>(
            builder: (context, controller) {
              return IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  controller.userLogout();
                }
              );
            }
          )
        ],
      ),
      body: Column(
        children: [
          UserData(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 70.0),
            child: ControlledWidgetBuilder<HomeController>(
              builder: (context, controller) {
                return TextField(
                  controller: controller.todoTextController,
                  decoration: InputDecoration(
                    labelText: 'Todo task',
                    // labelStyle: TextStyle(fontSize: 14.0),
                    hintText: 'Enter the todo task',
                  ),
                );
              },
            ),
          ),
          ControlledWidgetBuilder<HomeController>(
            builder: (context, controller) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(  
                    child: Text('Add todo', style: TextStyle(fontSize: 20.0)), 
                    onPressed: () {
                      print('add todo');
                      controller.addTodo();
                    },  
                  ),
                ],
              );
            },
          ),
          Expanded(
            child: ControlledWidgetBuilder<HomeController>(
              builder: (context, controller) {
                List<Todo> todos = controller.allTodos;
                print('todos todos todos todos $todos');
                if (todos == null) {
                  return Container();
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: todos.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    final id = todos[index].id;
                    final todoName = todos[index].todo;
                    final check = todos[index].check;

                    return Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(8.0),
                      color: Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              todos[index].todo,
                              style: TextStyle(
                                color: (check) ? Colors.grey : Colors.black,
                                decoration: (check) ? TextDecoration.lineThrough : null
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: check,   
                                onChanged: (bool value) {  
                                  print('check box $value');
                                  controller.updateTodo(id, todoName, value);
                                },
                              ),
                              PopupMenuButton<String>(
                                itemBuilder: (context){
                                  return controller.menu.map((item){
                                    return PopupMenuItem(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList();
                                },
                                child: Icon(
                                  Icons.more_vert,
                                  size: 24.0,
                                  color: (check) ? Colors.grey : Colors.black
                                ),
                                onSelected: (String selected) {
                                  print(selected);
                                  if (selected == 'Delete'){
                                    print(id);
                                    deleteDialog(
                                      id: id,
                                      check: check,
                                      controller: controller
                                    );
                                  }
                                  else if (selected == 'Update'){
                                    controller.updateTodoTextController.text = todoName;
                                    updateDialog(
                                      id: id,
                                      check: check,
                                      controller: controller
                                    );
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      )
                    );
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}