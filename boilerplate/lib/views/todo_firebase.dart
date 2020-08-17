import 'package:boilerplate/models/todo.dart';
import 'package:boilerplate/providers/todo_provider.dart';
import 'package:boilerplate/services/enums.dart';
import 'package:boilerplate/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:load/load.dart';

class TodoFirebaseView extends StatefulWidget {
  @override
  _TodoFirebaseViewState createState() => _TodoFirebaseViewState();
}

class _TodoFirebaseViewState extends State<TodoFirebaseView> {
  TodoProvider todoPrv = Modular.get<TodoProvider>();
  TextEditingController _ctrlTodo = TextEditingController();
  bool isDone = false;
  ScrollController _ctrlScroll = ScrollController();
  ReqStatus loadingAll = ReqStatus.blank;
  ReqStatus loading = ReqStatus.blank;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadTodos();
    Firestore.instance
        .collection("todo/dNTdqpYJqrVcrkPnZZzZ/tmp")
        .getDocuments()
        .then((value) {
      value.documents.forEach((e) {
        print(e.data);
      });
    });
  }

  _loadTodos() async {
    loadingAll = ReqStatus.loading;
    showLoadingDialog();
    try {
      await todoPrv.load();
      loadingAll = ReqStatus.done;
    } catch (e) {
      print(e);
      Utils.instance.defaultToast("Error getting the data", bg: Colors.red);
      loadingAll = ReqStatus.error;
    }
    hideLoadingDialog();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // todoPrv = Modular.get<TodoProvider>();
    // print(todoPrv.todos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // actions: [Icon(Icons.ac_unit)],
        title: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: TextFormField(
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            controller: _ctrlTodo,
            decoration: InputDecoration(
              labelText: "Enter your todo.",
              labelStyle: TextStyle(color: Colors.white),
              hintText: "Todo",
              hintStyle: TextStyle(color: Colors.grey[200].withAlpha(100)),
              fillColor: Colors.white,
              counterStyle: TextStyle(color: Colors.white),
            ),
            onEditingComplete: () async {
              try {
                if (loadingAll == ReqStatus.loading ||
                    loading == ReqStatus.loading) return;
                if (_ctrlTodo.text == null || _ctrlTodo.text.isEmpty) return;
                loading = ReqStatus.loading;
                showLoadingDialog();
                await todoPrv.put(Todo(todo: _ctrlTodo.text, done: false));
                _ctrlTodo.clear();
                // isDone = false;
                // todoPrv.notifyListeners();
                // _ctrlScroll.jumpTo(_ctrlScroll.position.maxScrollExtent);
                _ctrlScroll.animateTo(
                  _ctrlScroll.position.maxScrollExtent,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                );
                Utils.instance.removeFocus(context);
                loading = ReqStatus.done;
              } catch (e) {
                print(e);
                Utils.instance
                    .defaultToast("Error adding the data", bg: Colors.red);
                loading = ReqStatus.error;
              }
              hideLoadingDialog();
            },
            onFieldSubmitted: (value) {
              // print('onFieldSubmitted');
            },
          ),
        ),
      ),
      body: Consumer<TodoProvider>(builder: (context, __) {
        return LoadingProvider(
          themeData: LoadingThemeData(
              backgroundColor: Colors.black.withAlpha(100),
              loadingBackgroundColor: Colors.black.withAlpha(0)),
          child: Container(
            // padding: EdgeInsets.all(15),
            child: ListView.separated(
                controller: _ctrlScroll,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  var todo = todoPrv.byIndex(index);

                  return Dismissible(
                    key: Key(todo.id),
                    background: Container(
                      color: Colors.red,
                    ),
                    onDismissed: (direction) async {
                      try {
                        if (loadingAll == ReqStatus.loading ||
                            loading == ReqStatus.loading) return;
                        loading = ReqStatus.loading;
                        showLoadingDialog();

                        await todoPrv.delete(todo);
                        loading = ReqStatus.done;
                      } catch (e) {
                        print(e);
                        loading = ReqStatus.error;
                        Utils.instance.defaultToast("Error deleting the data",
                            bg: Colors.red);
                      }
                      hideLoadingDialog();
                    },
                    child: CheckboxListTile(
                      value: todo.done,
                      onChanged: (value) async {
                        try {
                          if (loadingAll == ReqStatus.loading ||
                              loading == ReqStatus.loading) return;
                          loading = ReqStatus.loading;
                          showLoadingDialog();
                          todo.done = value;

                          await todoPrv.put(todo);
                          loading = ReqStatus.done;
                        } catch (e) {
                          print(e);
                          loading = ReqStatus.error;
                          Utils.instance.defaultToast("Error updating the data",
                              bg: Colors.red);
                          todoPrv.notifyListeners();
                        }
                        hideLoadingDialog();
                      },
                      title: Text(todo.todo),
                      subtitle: Text(todo.updatedAt == null
                          ? ""
                          : todo.updatedAt.toDate().toString()),
                      // tristate: true,
                      dense: true,
                    ),
                  );
                },
                itemCount: todoPrv.total),
          ),
        );
      }),
    );
  }
}
