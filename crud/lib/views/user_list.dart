import 'package:crud/components/user_tile.dart';
import 'package:crud/data/dammy_users.dart';
import 'package:crud/models/user.dart';
import 'package:crud/provider/users.dart';
import 'package:crud/routes/app_routes.dart';
import 'package:crud/views/user_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  // List<User> _users;
  // List<User> users;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   updateUsers();
    // });
  }

  // void updateUsers() {
  //   _users = Users().all;
  //   users = [..._users];
  // }

  @override
  Widget build(BuildContext context) {
    Users users = Provider.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Usuários",
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) => UserForm()));
                Navigator.of(context).pushNamed(
                  AppRoutes.USER_FORM,
                );

                // users.remove(users.byIndex(0));
                // users.put(User(
                //     name: "RAfa",
                //     email: 'jao@email.com',
                //     avatarUrl: null));
              },
            )
          ],
        ),
        body: ListView.separated(
          separatorBuilder: (ctx, index) => Divider(
            color: Theme.of(context).primaryColor,
            height: 5,
          ),
          itemCount: users.count,
          itemBuilder: (context, index) {
            User user = users.byIndex(index);
            return UserTile(
              user: user,
              onDelete: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Excluir Usuário"),
                    content: Text("Tem Certeza???"),
                    actions: [
                      FlatButton(
                        child: Text("Não"),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text("Sim"),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value) users.remove(user);
                });
                // users.remove(user);
                // users.remove(index);
              },
            );
          },
        ));
  }
}
