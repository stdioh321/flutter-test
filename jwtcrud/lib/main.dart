import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwtcrud/providers/auth_provider.dart';
import 'package:jwtcrud/providers/items_provider.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/app_config.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/utils.dart';
import 'package:jwtcrud/views/item_detail.dart';
import 'package:jwtcrud/views/items_list.dart';
import 'package:jwtcrud/views/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.loadConfig();
  Utils.instance.prefs = await SharedPreferences.getInstance();
  // print(AppConfig.config['host']);
  runApp(ModularApp(
    module: AppModule(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  bool isAuthenticated() {
    if (AuthService.instance.getUser() != null) return true;
    return false;
  }

  logout() {
    AuthService.instance.setUser(null);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ItemsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'JWT Crud',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Colors.orange,
        ),
        initialRoute: AppRoutes.LOGIN,
        navigatorKey: Modular.navigatorKey,
        onGenerateRoute: Modular.generateRoute,
        // routes: {
        //   AppRoutes.LOGIN: (_) {
        //     return LoginView();
        //   },
        //   AppRoutes.ITEMS_LIST: (_) {
        //     return ItemsList();
        //   },
        //   AppRoutes.ITEM_DETAIL: (_) {
        //     return ItemDetail();
        //   },
        // },
      ),
    );
  }
}

class AppModule extends MainModule {
  @override
  // TODO: implement binds
  List<Bind> get binds => [];

  @override
  // TODO: implement bootstrap
  Widget get bootstrap => MyApp();

  @override
  // TODO: implement routers
  List<Router> get routers => [
        Router(
          AppRoutes.LOGIN,
          child: (context, args) => LoginView(),
        ),
        Router(
          AppRoutes.ITEMS_LIST,
          child: (context, args) => ItemsList(),
          guards: [MyGuard()],
        ),
        Router(
          AppRoutes.ITEM_DETAIL,
          child: (context, args) => ItemDetail(),
          guards: [MyGuard()],
        ),
      ];
}

class MyGuard implements RouteGuard {
  @override
  bool canActivate(String url) {
    print("CHANGED URL: $url");
    if (AuthService.instance.getUser() == null) {
      // Future.delayed(Duration(seconds: 2), () {
      //   if (Modular.to.canPop())
      Timer.run(() {
        // if (Modular.to.canPop())
        // Modular.to.pushReplacementNamed('/login');
        Modular.to.pushNamedAndRemoveUntil("/login", ModalRoute.withName("/"));
        // else
        //   Modular.to.pushNamed('/login');
      });
      //   else
      //     Modular.to.pushNamed("/login");
      // });
      // return false;
    }
    return true;

    // if (url != '/admin') {
    //   // Return `true` to allow access
    //   return true;
    // } else {
    //   // Return `false` to disallow access
    //   return false;
    // }
  }

  @override
  // TODO: implement executors
  List<GuardExecutor> get executors => [];
}

class LoginExecutor extends GuardExecutor {
  @override
  onGuarded(String path, {bool isActive}) {
    if (isActive) {
      print('Access allowed');
      return;
    }

    print('Access blocked');
    if (Modular.to.canPop())
      Modular.to.pushReplacementNamed('/login');
    else
      Modular.to.pushNamed('/login');
  }
}
