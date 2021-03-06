import 'dart:async';
import 'dart:convert';

import 'package:chat_app/model/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChannelLayer extends StatefulWidget {
  final MainModel model;
  final WebSocketChannel channel;
  ChannelLayer(this.model, this.channel);
  @override
  _ChannelLayerState createState() => _ChannelLayerState();
}

class _ChannelLayerState extends State<ChannelLayer> {
  MainModel _model;
  Map<String, String> map = {};
  WebSocketChannel channel;
  final GlobalKey<FormState> _channelkey = GlobalKey<FormState>();
  final TextEditingController _channelcontroller = TextEditingController();
  @override
  void initState() {
    _model = widget.model;
    channel = widget.channel; 
    // _model.streamController.stream.listen((event) {
    //   Map<String, dynamic> m = json.decode(event);
    //   print("json decode 1: ${m['data']}");
    //   print("Hello");
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _channelkey,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0.5),
            color: Colors.grey.withOpacity(0.5),
            border: Border.all()),
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            AppBar(
              title: Text("Channels"),
            ),

            ScopedModelDescendant<MainModel>(builder: (context, child, model) {
              return model.isloadingChannel
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _model.channels.length,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  _model.selectChannel(i);
                                },
                                title: Text(
                                  _model.channels[i].name,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider()
                            ],
                          );
                        },
                        padding:
                            EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                      ),
                    );
            }),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _channelcontroller,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: "New Channel...", border: InputBorder.none),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  splashColor: Colors.blue,
                  splashRadius: 23,
                  onPressed: () {
                    if (_channelcontroller.text.isNotEmpty) {
                      _model.addChannel(_channelcontroller.text);
                      _channelcontroller.clear();
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
