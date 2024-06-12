import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:orbis_test_task/di/di.dart';
import 'package:orbis_test_task/mixins/base_screen_mixin.dart';
import 'package:orbis_test_task/screens/user_list_screen.dart';
import 'package:orbis_test_task/view_models/login_screen_view_model.dart';
import 'package:rxdart/rxdart.dart';

class LoginScreen extends StatefulWidget {
  static const String route = 'login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with BaseScreenMixin {
  final LoginScreenViewModelType _viewModel = DI.resolve();
  final CompositeSubscription _subscriptions = CompositeSubscription();

  @override
  String? get title => 'login screen';

  @override
  void initState() {
    super.initState();

    _subscriptions
      ..add(_viewModel.output.snackBarMessage.listen((msg) {
        showSnackMessage(msg);
      }))
      ..add(_viewModel.output.shoudOpenListScreen.listen(
          (_) => Navigator.of(context).pushNamed(UserListScreen.route)));
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget buildBody(BuildContext context) => SafeArea(
        child: Column(
          children: [
            _buildLoginForm(),
            _buildSubmitButton(),
            _buildLoadingWheel(),
          ],
        ),
      );

  Widget _buildLoginForm() => Column(
        children: [
          TextField(
            onChanged: _viewModel.input.setEmail,
          ),
          TextField(
            onChanged: _viewModel.input.setPassword,
          )
        ],
      );

  Widget _buildSubmitButton() => StreamBuilder<SubmitButtonModel>(
      stream: _viewModel.output.submitButtonModel,
      initialData: SubmitButtonModel(
          isEnabled: false, icon: Symbols.abc, text: 'cant submit'),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? TextButton.icon(
                onPressed:
                    snapshot.data!.isEnabled ? _viewModel.input.submit : null,
                label: Text(snapshot.data!.text),
                icon: Icon(snapshot.data!.icon),
              )
            : const SizedBox.shrink();
      });

  Widget _buildLoadingWheel() => StreamBuilder(
      stream: _viewModel.output.isLoading,
      initialData: false,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? snapshot.data!
                ? const RepaintBoundary(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink()
            : const SizedBox.shrink();
      });
}
