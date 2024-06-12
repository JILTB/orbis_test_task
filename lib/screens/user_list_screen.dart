import 'package:flutter/material.dart';
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

    _viewModel.input.loadUserList(page);

    _subscriptions
      ..add(
        _viewModel.output.shouldPop.listen(
          (shouldPop) {
            if (shouldPop) {
              Navigator.of(context).popAndPushNamed(LoginScreen.route);
            }
          },
        ),
      )
      ..add(
        _viewModel.output.userList.listen(
          (list) {
            if (list != null && list.isNotEmpty) {
              setState(() {
                userList.addAll(list);
              });
            }
          },
        ),
      )
      ..add(_viewModel.output.toastMessage.listen(
          (message) => message != null ? showSnackMessage(message) : null));

    _controller.addListener(
      () {
        if (_controller.position.maxScrollExtent == _controller.offset) {
          setState(() {
            page++;
          });
          _viewModel.input.loadUserList(page);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _viewModel.dispose();
  }

  @override
  Widget buildBody(BuildContext context) => _buildListView();

  ListView _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      padding: const EdgeInsets.all(15),
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: userList.length,
      itemBuilder: (context, index) {
        return _buildListItem(
          userList[index],
        );
      },
    );
  }

  Widget _buildListItem(Data data) => ListTile(
        trailing: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.network(
            data.avatar ?? '',
            fit: BoxFit.fill,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${data.firstName} ${data.lastName}',
            style: const TextStyle(fontSize: 20),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            data.email ?? '',
            style: const TextStyle(fontSize: 15),
          ),
        ),
      );

  Widget _buildLogOutButton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: InkWell(
          onTap: _viewModel.input.logout,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          child: const Text('logout'),
        ),
      );
}
