import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String currRouteName = ModalRoute.of(context).settings.name;
    return Drawer(
      elevation: 5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
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
