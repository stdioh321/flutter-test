import 'package:boilerplate/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key key,
    @required this.img,
  }) : super(key: key);

  final NetworkImage img;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    // Utils.instance.removeFocus(context);
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              curve: Curves.bounceInOut,
              child: Stack(
                children: [
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 50,
                      letterSpacing: 4,
                      // color: Colors.black.withAlpha(100),
                      foreground: Paint()
                        ..color = Colors.black
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 0.5,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  scale: 1,
                  image: widget.img,
                  fit: BoxFit.cover,
                ),
                color: Colors.white,
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.library_books),
              title: Text(
                "List",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.LIST,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.library_books),
              title: Text(
                "List Infinity",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.LIST_INFINITY,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.library_books),
              title: Text(
                "Search",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.SEARCH,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.library_books),
              title: Text(
                "Login Google",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.LOGIN_GOOGLE,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.library_books),
              title: Text(
                "Push Notification",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.PUSH_NOTIFICATION,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.featured_play_list),
              title: Text(
                "Todo Firebase",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.TODO_FIREBASE,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.featured_play_list),
              title: Text(
                "TMP",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.TMP,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.featured_play_list),
              title: Text(
                "List Files",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.LIST_FILES,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_forward,
              ),
              leading: Icon(Icons.featured_play_list),
              title: Text(
                "Img Upload",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  fontSize: 26,
                ),
              ),
              onTap: () {
                Modular.to.pushNamed(
                  Routes.IMG_UPLOAD,
                );
              },
            ),
            ListTile(
              trailing: Icon(
                Icons.arrow_back_ios,
                color: Colors.red,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
