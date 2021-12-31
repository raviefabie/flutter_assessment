import 'dart:async';

import 'package:flutter_assessment_api/api/users_api.dart';
import 'package:flutter_assessment_api/main.dart';
import 'package:flutter_assessment_api/model/users.dart';
import 'package:flutter_assessment_api/widget/search_widget.dart';
import 'package:flutter/material.dart';

class FilterNetworkListPage extends StatefulWidget {
  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<FilterNetworkListPage> {
  List<Users> users = [];
  String query = '';
  Timer debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(milliseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final user = await SearchUserApi.getUsers(query);

    setState(() => this.users = user);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(MyApp.title),
      centerTitle: true,
    ),
    body: Column(
      children: <Widget>[
        buildSearch(),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return buildUser(user);
            },
          ),
        ),
      ],
    ),
  );

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Name or email',
    onChanged: searchUser,
  );

  Future searchUser(String query) async => debounce(() async {
    final users = await SearchUserApi.getUsers(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.users = users;
    });
  });

  Widget buildUser(Users user) => ListTile(
    leading: Image.network(
      user.avatar,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    ),
    title: Text(user.firstName+ " "+ user.lastName),
    subtitle: Text(user.email),
  );
}