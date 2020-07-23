import 'package:crud/models/user.dart';
import 'package:crud/routes/app_routes.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  User user;
  Function onDelete;
  UserTile({this.user, this.onDelete});
  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarUrl == null || user.avatarUrl.isEmpty
        ? CircleAvatar(
            child: Icon(
              Icons.person,
            ),
          )
        : CircleAvatar(
            backgroundImage: NetworkImage(
              user.avatarUrl,
            ),
          );
    return ListTile(
      dense: true,
      leading: avatar,
      title: Text(
        user.name,
      ),
      subtitle: Text(
        user.email,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.USER_FORM,
                  arguments: user,
                );
              },
              icon: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
