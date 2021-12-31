import 'package:flutter_assessment_api/data/user_data.dart';
import 'package:flutter_assessment_api/main.dart';
import 'package:flutter_assessment_api/model/users.dart';
import 'package:flutter_assessment_api/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FilterLocalListPage extends StatefulWidget {
  @override
  FilterLocalListPageState createState() => FilterLocalListPageState();
}

class FilterLocalListPageState extends State<FilterLocalListPage> {
  List<Users> users;
  String query = '';

  @override
  void initState() {
    super.initState();

    users = allUsers;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(onPressed: () {},
              child: const Icon(Icons.add),),
          ],
        )
      ],
    ),

  );

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Name or email',
    onChanged: searchUser,
  );

  Widget buildUser(Users user) => ListTile(
    leading: Image.network(
      user.avatar,
      fit: BoxFit.cover,
      width: 50,
      height: 50,
    ),
    title: Text(user.firstName+ " "+ user.lastName),
    subtitle: Text(user.email),
    trailing: IconButton(icon: const Icon(Icons.send_rounded,
        color: Colors.teal),
      onPressed: () {
      launch('mailto:${user.email}'
          'subject=This is Subject Title'
      'body=This is Body of Email');
      },
    )
  );

  void searchUser(String query) {
    final users = allUsers.where((book) {
      final emailLower = book.email.toLowerCase();
      final fnameLower = book.firstName.toLowerCase();
      final lnameLower = book.lastName.toLowerCase();
      final searchLower = query.toLowerCase();

      return emailLower.contains(searchLower) ||
          fnameLower.contains(searchLower) ||
          lnameLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.users = users;
    });
  }
}