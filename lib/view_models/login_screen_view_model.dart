import 'package:async/async.dart' show CancelableOperation;
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:orbis_test_task/misc/errors.dart';
import 'package:orbis_test_task/misc/result.dart';
import 'package:orbis_test_task/misc/stream_extensions.dart';
import 'package:orbis_test_task/models/login_model.dart';
import 'package:orbis_test_task/services/network_service.dart';
import 'package:rxdart/rxdart.dart';

import 'base_view_model.dart';

abstract class LoginScreenViewModelInput {
  void submit();

  void setEmail(String email);

  void setPassword(String password);
}

abstract class LoginScreenViewModelOutput {
  Stream<SubmitButtonModel> get submitButtonModel;

  Stream<bool> get isLoading;

  Stream<String> get snackBarMessage;

  Stream<String?> get emailTextFieldErrorMessage;

  Stream<String?> get shoudOpenListScreen;
}

abstract class LoginScreenViewModelType extends BaseViewModel {
  LoginScreenViewModelInput get input;

  LoginScreenViewModelOutput get output;
}

class LoginScreenViewModel
    implements
        LoginScreenViewModelType,
        LoginScreenViewModelInput,
        LoginScreenViewModelOutput {
  LoginScreenViewModel(this._networkService) {
    emailTextFieldErrorMessage = _email.map(
      (email) {
        final emailRegex =
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (email == '') {
          return 'please fill email';
        } else if (emailRegex.hasMatch(email)) {
          return null;
        } else {
          return 'invalid email';
        }
      },
    );

    submitButtonModel = Rx.combineLatest2(
      emailTextFieldErrorMessage,
      _password,
      (errorMessage, password) {
        final isEnabled = errorMessage == null && password != '';
        return SubmitButtonModel(
            isEnabled: isEnabled,
            icon: isEnabled ? Symbols.check : Symbols.clear,
            text: isEnabled ? 'login' : 'cant login');
      },
    ).shareReplay(maxSize: 1);

    final submit = _submitTrigger
        .withLatestFrom2<String, String, ({String email, String password})>(
            _email,
            _password,
            (_, email, password) => (email: email, password: password))
        .switchMap((params) {
      final runningRequest = CancelableOperation.fromFuture(_networkService
          .login(LoginModel(email: params.email, password: params.password)));
      return runningRequest
          .valueOrCancellation(Result.error(CancelRequestError()))
          .then((value) => value!)
          .asStream()
          .startWith(Result.loading());
    }).shareReplay(maxSize: 1);

    isLoading = Rx.merge([submit.isLoading()]);

    shoudOpenListScreen = submit.whereSuccess();

    snackBarMessage = Rx.merge([
      submit.whereError().map((error) => error.description),
      submit.whereSuccess().map((_) => 'success!'),
    ]);
  }

  final _submitTrigger = BehaviorSubject<void>();
  final _email = BehaviorSubject.seeded('');
  final _password = BehaviorSubject.seeded('');
  final NetworkService _networkService;

  @override
  LoginScreenViewModelInput get input => this;

  @override
  LoginScreenViewModelOutput get output => this;

  @override
  void dispose() {
    _submitTrigger.close();
    _email.close();
    _password.close();
  }

  @override
  void submit() {
    _submitTrigger.add(null);
  }

  @override
  late final Stream<SubmitButtonModel> submitButtonModel;

  @override
  void setPassword(String password) {
    _password.add(password);
  }

  @override
  void setEmail(String userName) {
    _email.add(userName);
  }

  @override
  late final Stream<bool> isLoading;

  @override
  late final Stream<String> snackBarMessage;

  @override
  late final Stream<String?> shoudOpenListScreen;

  @override
  late final Stream<String?> emailTextFieldErrorMessage;
}

class SubmitButtonModel {
  final bool isEnabled;
  final IconData icon;
  final String text;

  SubmitButtonModel({
    required this.isEnabled,
    required this.icon,
    required this.text,
  });
}
