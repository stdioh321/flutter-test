import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/app_config.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/utils.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String avatarImg = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String currRouteName = ModalRoute.of(context).settings.name;
    try {
      FocusScope.of(context).requestFocus(FocusNode()); //remove focus
    } catch (e) {}
    if (AppConfig.getInstance().config != null) {
      String tmp = AppConfig.getInstance().getHost();
      tmp += AppConfig.getInstance().getConfigKey('avatars');
      tmp += "${AuthService.instance.getUser().image}";
      // avatarImg = tmp + "?r=" + "${Random().nextInt(100000)}";
      avatarImg = tmp;
    }
    return Drawer(
      elevation: 5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              AuthService.instance.getUser() != null
                  ? AuthService.instance.getUser().name
                  : "Unknow",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: FadeInImage(
              alignment: Alignment.centerLeft,
              image: NetworkImage(avatarImg),
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  child: Image.asset(
                    "assets/images/avatar.png",
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                );
              },
              // fadeOutDuration: Duration(seconds: 1),
              fit: BoxFit.contain,
              height: 130,
              placeholder: AssetImage("assets/images/loading.gif"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Profile',
              style: currRouteName == AppRoutes.PROFILE
                  ? TextStyle(
                      fontWeight: FontWeight.w500,
                      // fontSize: 25,
                      decoration: TextDecoration.underline,
                      // decorationStyle: TextDecorationStyle.,
                      // color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            onTap: () {
              if (currRouteName != AppRoutes.PROFILE)
                Modular.to.pushNamedAndRemoveUntil(
                    AppRoutes.PROFILE, ModalRoute.withName("/"));
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text(
              'Items',
              style: currRouteName == AppRoutes.ITEMS
                  ? TextStyle(
                      fontWeight: FontWeight.w500,
                      // fontSize: 25,
                      decoration: TextDecoration.underline,
                      // decorationStyle: TextDecorationStyle.,
                      // color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            onTap: () {
              if (currRouteName != AppRoutes.ITEMS)
                Modular.to.pushNamedAndRemoveUntil(
                    AppRoutes.ITEMS, ModalRoute.withName("/"));
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text(
              'Brands',
              style: currRouteName == AppRoutes.BRANDS
                  ? TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    )
                  : null,
            ),
            onTap: () {
              if (currRouteName != AppRoutes.BRANDS)
                Modular.to.pushNamedAndRemoveUntil(
                    AppRoutes.BRANDS, ModalRoute.withName("/"));
            },
          ),
          ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text(
              'Models',
              style: currRouteName == AppRoutes.MODELS
                  ? TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    )
                  : null,
            ),
            onTap: () {
              if (currRouteName != AppRoutes.MODELS)
                Modular.to.pushNamedAndRemoveUntil(
                    AppRoutes.MODELS, ModalRoute.withName("/"));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text('Logout',
                style: TextStyle(
                  color: Colors.red,
                )),
            onTap: () async {
              await AuthService.instance.setUser(null);
              Modular.to.pushNamedAndRemoveUntil(
                  AppRoutes.LOGIN, ModalRoute.withName("/"));
            },
          ),
        ],
      ),
    );
  }
}
