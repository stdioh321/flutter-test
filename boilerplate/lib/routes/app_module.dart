// app_module.dart
import 'package:boilerplate/main.dart';
import 'package:boilerplate/providers/todo_provider.dart';
import 'package:boilerplate/routes/routes.dart';
import 'package:boilerplate/views/home_view.dart';
import 'package:boilerplate/views/img_upload.dart';
import 'package:boilerplate/views/list_files.dart';
import 'package:boilerplate/views/list_inifinity_view.dart';
import 'package:boilerplate/views/list_items_view.dart';
import 'package:boilerplate/views/login_google.dart';
import 'package:boilerplate/views/push_notificaiton_view.dart';
import 'package:boilerplate/views/search_view.dart';
import 'package:boilerplate/views/tmp_view.dart';
import 'package:boilerplate/views/todo_firebase.dart';
import 'package:boilerplate/views/todo_firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:flutter/material.dart' hide Router;
import 'package:flutter/material.dart';

class AppModule extends MainModule {
  // Provide a list of dependencies to inject into your project
  @override
  List<Bind> get binds => [
        Bind((_) => TodoProvider()),
      ];

  // Provide all the routes for your module
  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          Routes.HOME,
          child: (_, __) => HomeView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.LIST,
          child: (_, __) => ListItemsView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.LIST_INFINITY,
          child: (_, __) => ListInfinityView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.SEARCH,
          child: (_, __) => SearchView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.LOGIN_GOOGLE,
          child: (_, __) => LoginGoogleView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.PUSH_NOTIFICATION,
          child: (_, __) => PushNotificationView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.TODO_FIREBASE,
          child: (_, __) => TodoFirebaseView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.TMP,
          child: (_, __) => TmpView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.LIST_FILES,
          child: (_, __) => ListFilesView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.IMG_UPLOAD,
          child: (_, __) => ImgUploadView(),
          guards: [AuthGuard()],
        ),
        ModularRouter(
          Routes.TODO_FIREBASE_AUTH,
          child: (_, __) => TodoFirebaseAuthView(),
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
