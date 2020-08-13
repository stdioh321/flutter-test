// app_module.dart
import 'package:boilerplate/main.dart';
import 'package:boilerplate/routes/routes.dart';
import 'package:boilerplate/views/home_view.dart';
import 'package:boilerplate/views/list_inifinity_view.dart';
import 'package:boilerplate/views/list_items_view.dart';
import 'package:boilerplate/views/login_google.dart';
import 'package:boilerplate/views/push_notificaiton_view.dart';
import 'package:boilerplate/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends MainModule {
  // Provide a list of dependencies to inject into your project
  @override
  List<Bind> get binds => [];

  // Provide all the routes for your module
  @override
  List<Router> get routers => [
        Router(
          Routes.HOME,
          child: (_, __) => HomeView(),
          guards: [AuthGuard()],
        ),
        Router(
          Routes.LIST,
          child: (_, __) => ListItemsView(),
          guards: [AuthGuard()],
        ),
        Router(
          Routes.LIST_INFINITY,
          child: (_, __) => ListInfinityView(),
          guards: [AuthGuard()],
        ),
        Router(
          Routes.SEARCH,
          child: (_, __) => SearchView(),
          guards: [AuthGuard()],
        ),
        Router(
          Routes.LOGIN_GOOGLE,
          child: (_, __) => LoginGoogleView(),
          guards: [AuthGuard()],
        ),
        Router(
          Routes.PUSH_NOTIFICATION,
          child: (_, __) => PushNotificationView(),
          guards: [AuthGuard()],
        ),
      ];

  // Provide the root widget associated with your module
  @override
  Widget get bootstrap => MyApp();
}

class AuthGuard extends RouteGuard {
  @override
  bool canActivate(String url) {
    // TODO: implement canActivate
    // throw UnimplementedError();
    print('AuthGuard url:$url');
    return true;
  }

  @override
  // TODO: implement executors
  List<GuardExecutor> get executors => [GuardExec()];

  // @override
  // TODO: implement executors
  // List<GuardExecutor> get executors => throw UnimplementedError();
  // List<GuardExecutor> get executors => null;
}

class GuardExec extends GuardExecutor {
  @override
  void onGuarded(String path, {bool isActive}) {
    // TODO: implement onGuarded
  }
}
