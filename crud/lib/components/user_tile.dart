import 'package:crud/models/user.dart';
import 'package:crud/routes/app_routes.dart';
import 'package:crud/views/user_form.dart';
import 'package:crud/views/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserTile extends StatelessWidget {
  User user;
  Function onDelete;
  UserTile({this.user, this.onDelete});
  @override
  Widget build(BuildContext context) {
    final avatar = CachedNetworkImage(
      imageUrl: user.avatarUrl != null ? user.avatarUrl : 'unknow',
      fit: BoxFit.contain,
      imageBuilder: (context, imageProvider) {
        // print(imageProvider.runtimeType);
        return CircleAvatar(
          backgroundImage: imageProvider,
        );
      },
      placeholder: (context, url) {
        return CircularProgressIndicator();
      },
      errorWidget: (context, url, error) {
        return CircleAvatar(
            backgroundImage: AssetImage(
          'assets/images/avatar_placeholder.png',
        ));
      },
    );

    return ListTile(
      dense: true,
      leading: Container(
        width: 50,
        height: 50,
        child: avatar,
      ),
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
                Navigator.push(
                    context,
                    Utils.instance.createRoute(
                      page: UserForm(),
                      arguments: user,
                    ));
                // Navigator.of(context).pushNamed(
                //   AppRoutes.USER_FORM,
                //   arguments: user,
                // );
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
