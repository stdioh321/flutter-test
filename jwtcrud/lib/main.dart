import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:jwtcrud/providers/auth_provider.dart';
import 'package:jwtcrud/providers/items_provider.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/app_config.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:jwtcrud/services/utils.dart';
import 'package:jwtcrud/views/brands/brand_detail.dart';
import 'package:jwtcrud/views/brands/brands.dart';
import 'package:jwtcrud/views/home.dart';
import 'package:jwtcrud/views/items/item_detail.dart';
import 'package:jwtcrud/views/items/items.dart';

import 'package:jwtcrud/views/login_view.dart';
import 'package:jwtcrud/views/models/model_detail.dart';
import 'package:jwtcrud/views/models/models.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JWT Crud',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: Colors.teal,
      ),
      initialRoute: AppRoutes.LOGIN,
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => Scaffold(
              body: Center(
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Page Not Found'),
              FlatButton.icon(
                  color: Colors.red,
                  onPressed: () async {
                    // await Modular.to.pushNamedAndRemoveUntil(
                    //     AppRoutes.ITEMS, ModalRoute.withName("/"));
                    await Modular.to.pushReplacementNamed(AppRoutes.LOGIN);
                  },
                  icon: Icon(
                    Icons.keyboard_return,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))
            ],
          ))),
        );
      },
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}

class AppModule extends MainModule {
  @override
  // TODO: implement binds
  List<Bind> get binds => [
        Bind((_) => ItemsProvider()),
      ];

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
          AppRoutes.HOME,
          child: (context, args) => HomeView(),
          // guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
        Router(
          AppRoutes.ITEMS,
          child: (context, args) => ItemsView(),
          guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
        Router(
          "${AppRoutes.ITEM_DETAIL}/:id",
          child: (context, args) => ItemDetailView(
            id: args.params['id'],
          ),
          guards: [AuthGuard()],
          // transition: TransitionType.scale,
        ),
        Router(
          "${AppRoutes.ITEM_DETAIL}",
          child: (context, args) => ItemDetailView(),
          guards: [AuthGuard()],

          // transition: TransitionType.scale,
        ),
        Router(
          AppRoutes.BRANDS,
          child: (context, args) => BrandsView(),
          guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
        Router(
          AppRoutes.BRAND_DETAIL,
          child: (context, args) => BrandDetailView(),
          guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
        Router(
          "${AppRoutes.BRAND_DETAIL}/:id",
          child: (context, args) => BrandDetailView(
            id: args.params['id'],
          ),
          guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
        Router(
          AppRoutes.MODELS,
          child: (context, args) => ModelsViews(),
          guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
        Router(
          AppRoutes.MODEL_DETAIL,
          child: (context, args) => ModelDetailView(),
          guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
        Router(
          "${AppRoutes.MODEL_DETAIL}/:id",
          child: (context, args) => ModelDetailView(
            args.params['id'],
          ),
          guards: [AuthGuard()],
          // transition: TransitionType.rotate,
        ),
      ];
}

class AuthGuard implements RouteGuard {
  @override
  bool canActivate(String url) {
    // print("CHANGED URL: $url");
    if (!AuthService.instance.isAuthenticate()) {
      print("!AuthService.instance.isAuthenticate()");
      Timer.run(() {
        AuthService.instance.setUser(null).then((value) {
          Modular.to.pushNamedAndRemoveUntil(
              AppRoutes.LOGIN, ModalRoute.withName("/"));
        });
      });
      // return false;
    }
    return true;
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
