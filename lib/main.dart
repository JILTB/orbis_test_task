import 'package:flutter/material.dart';
import 'package:orbis_test_task/screens/login_screen.dart';
import 'package:orbis_test_task/screens/user_list_screen.dart';

import 'di/di.dart';

void main() async {
  await DI.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _themeData,
      home: const TestApp(),
    );
  }
}

typedef PageWidgetBuilder = Widget Function(
    BuildContext context, dynamic arguments);

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  final _mainNavigatorKey = GlobalKey<NavigatorState>();
  late Map<String, PageWidgetBuilder> _routes;

  @override
  void initState() {
    super.initState();

    _routes = {
      LoginScreen.route: (_, __) => const LoginScreen(),
      UserListScreen.route: (_, __) => const UserListScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _mainNavigatorKey,
      initialRoute: LoginScreen.route,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case LoginScreen.route:
          case UserListScreen.route:
            return _createFadeRouteForSettings(settings);
          default:
            return MaterialPageRoute(
              builder: (context) =>
                  _routes[settings.name!]!(context, settings.arguments),
              settings: settings,
            );
        }
      },
    );
  }

  Route _createFadeRouteForSettings(RouteSettings settings) => PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, _, __) =>
            _routes[settings.name!]!(context, settings.arguments),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        settings: settings,
      );
}

ThemeData get _themeData => ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );
