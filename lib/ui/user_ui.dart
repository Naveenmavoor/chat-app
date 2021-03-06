import 'package:chat_app/model/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UsersLayer extends StatefulWidget {
  final WebSocketChannel channel;
  final MainModel model;
  UsersLayer(this.model, this.channel);
  @override
  _UsersLayerState createState() => _UsersLayerState();
}

class _UsersLayerState extends State<UsersLayer> {
  WebSocketChannel channel;
  MainModel model;
  final GlobalKey<FormState> _userkey = GlobalKey<FormState>();
  final TextEditingController _usercontroller = TextEditingController();

  @override
  void initState() {
    channel = widget.channel;
    model = widget.model;
    model.onAddUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.5),
            color: Colors.grey.withOpacity(0.5),
            border: Border.all()),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.5,
        child:
            ScopedModelDescendant<MainModel>(builder: (context, child, model) {
          return model.isloadingUser
              ? Container(child: CircularProgressIndicator())
              : userList();
        }));
  }

  Widget userList() {
    return Column(
      children: [
        AppBar(
          title: Text("Users"),
          backgroundColor: Colors.blue,
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return model.map['data']['id'] == model.users[index].id
                  ? ListTile(
                      onTap: () {
                        _usercontroller.text = model.users[index].name;
                        changeUsername(model);
                      },
                      title: Text(model.users[index].name.toString()),
                      trailing: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    )
                  : ListTile(
                      title: Text(model.users[index].name),
                    );
            },
            itemCount: model.users.length,
          ),
        ),
      ],
    );
  }

  void changeUsername(MainModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  model.updateUname(_usercontroller.text);
                  Navigator.pop(context);
                  setState(() {});
                },
              )
            ],
            title: Text('Change Username'),
            content: TextField(
              textAlignVertical: TextAlignVertical.center,
              controller: _usercontroller,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                FontAwesomeIcons.userAlt,
                size: 20,
              )),
            ),
          );
        });
  }
}
