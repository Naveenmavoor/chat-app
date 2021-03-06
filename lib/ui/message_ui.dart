import 'package:chat_app/classes/message.dart';
import 'package:chat_app/model/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Message extends StatefulWidget {
  final WebSocketChannel channel;
  final MainModel model;
  Message(this.model, this.channel);
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  WebSocketChannel channel;
  MainModel model;
  String _chatmssg;
  final GlobalKey<FormState> _chatkey = GlobalKey<FormState>();
  final TextEditingController _chatcontroller = TextEditingController();
  @override
  void initState() {
    channel = widget.channel;
    model = widget.model;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.5),
            color: Colors.grey.withOpacity(0.5),
            border: Border.all()),
        width: MediaQuery.of(context).size.width * 0.7,
        child: chatUpdate());
  }

  Widget chatUpdate() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.selectedchannel != null
          ? Column(
              children: [
                AppBar(
                  title: Text("${model.selectedchannel}"),
                  backgroundColor: Colors.blue,
                ),
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      subtitle: Text(model.mssg[index].dateTime.toString()),
                      leading: Text(
                        model.mssg[index].author,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text(model.mssg[index].body),
                    );
                  },
                  itemCount: model.mssg.length,
                )),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                          controller: _chatcontroller,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: "Type a message",
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                    IconButton(
                      color: Colors.blue,
                      splashRadius: 23,
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_chatcontroller.text.isNotEmpty) {
                          setState(() {
                            _chatmssg = _chatcontroller.text;
                            MessageClass mssg = MessageClass(
                                author: model.users[0].name,
                                dateTime: DateFormat('dd/MM/yyyy h:mm a')
                                    .format(DateTime.now()),
                                body: _chatmssg);
                            model.addMessage(mssg);
                          });
                        }
                        _chatcontroller.clear();
                      },
                    )
                  ],
                )
              ],
            )
          : keepConnected();
    });
  }

  Widget keepConnected() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.smile,
            color: Colors.blue,
            size: 80,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Keep connected",
            style: TextStyle(
                fontWeight: FontWeight.w400, color: Colors.blue, fontSize: 20),
          )
        ],
      ),
      alignment: Alignment.center,
    );
  }
}
