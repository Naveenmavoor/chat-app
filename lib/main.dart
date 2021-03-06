import 'dart:html';

import 'package:chat_app/ui/message_ui.dart';
import 'package:chat_app/ui/user_ui.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './model/main.dart';
import 'package:chat_app/ui/channel_ui.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
        model: model,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: ChatApp(model),
          ),
        ));
  }
}

class ChatApp extends StatelessWidget {
  final WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));
  final MainModel model;

  ChatApp(this.model);
  @override
  Widget build(BuildContext context) {
    model.channel = channel;
    model.setStream(channel);
    return Row(
      children: [
        Column(
          children: [ChannelLayer(model, channel), UsersLayer(model, channel)],
        ),
        Message(model, channel)
      ],
    );
  }
}
