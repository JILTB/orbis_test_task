import 'package:flutter/material.dart';

mixin BaseScreenMixin<T extends StatefulWidget> on State<T> {
  String? get title;

  Widget? get logOutButton => null;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackMessage(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        action: action,
        duration: duration,
        behavior: behavior,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)))));
  }

  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: title != null
          ? AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: Text(title!),
              actions: <Widget>[if (logOutButton != null) logOutButton!],
            )
          : null,
      body: buildBody(context),
    );
  }
}
