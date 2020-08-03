import 'package:auto_route/auto_route_annotations.dart';
import 'package:jwtcrud/views/login_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // initial route is named "/"
    MaterialRoute(page: LoginView, initial: true),
    // MaterialRoute(page: UsersScreen, ..config),
  ],
)
class $Router {}
