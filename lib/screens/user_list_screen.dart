import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:orbis_test_task/di/di.dart';
import 'package:orbis_test_task/mixins/base_screen_mixin.dart';
import 'package:orbis_test_task/models/user_list_model.dart';
import 'package:orbis_test_task/screens/login_screen.dart';
import 'package:orbis_test_task/view_models/user_list_view_view_model.dart';
import 'package:rxdart/rxdart.dart';

class UserListScreen extends StatefulWidget {
  static const String route = 'user_list';
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> with BaseScreenMixin {
  final UserListViewModelType _viewModel = DI.resolve();
  final ScrollController _controller = ScrollController();
  final CompositeSubscription _subscriptions = CompositeSubscription();
  final userList = [];
  bool isLoading = false;
  int page = 1;

  @override
  String? get title => 'User List';

  @override
  Widget get logOutButton => _buildLogOutButton();

  @override
  void initState() {
    super.initState();

    _viewModel.input.loadAdditionalData(page);

    _subscriptions
      ..add(_viewModel.output.isLoading.listen((loading) {
        setState(() {
          isLoading = loading;
          page++;
        });
      }))
      ..add(_viewModel.output.shouldPop.listen((shouldPop) {
        if (shouldPop) {
          Navigator.of(context).popAndPushNamed(LoginScreen.route);
        }
      }));

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        _viewModel.input.loadAdditionalData(page);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _viewModel.dispose();
  }

  @override
  Widget buildBody(BuildContext context) => StreamBuilder<List<Data>?>(
        stream: _viewModel.output.userList,
        initialData: const [],
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userList.addAll(snapshot.data!);
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            padding: const EdgeInsets.all(8),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            itemCount: userList.length + 1,
            itemBuilder: (context, index) {
              if (index < userList.length) {
                return _buildListItem(
                  userList[index],
                );
              } else {
                return isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: RepaintBoundary(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox.shrink();
              }
            },
          );
        },
      );

  Widget _buildListItem(Data data) => Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              data.avatar ?? '',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${data.firstName} ${data.lastName}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data.email ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          )
        ],
      );

  Widget _buildLogOutButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: InkWell(
          onTap: _viewModel.input.logout,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          child: const Icon(Symbols.clear),
        ),
      );
}
