import 'dart:async';
import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './connectedmodel.dart';

class MainModel extends Model
    with ConnectedModel, ChannelModel, UserModel, MessageModel {
  final streamController = StreamController.broadcast();

  void setStream(WebSocketChannel channel) {
    print('Hello');
    streamController.addStream(channel.stream);
     streamController.stream.listen((event) {
      Map<String, dynamic> m = json.decode(event);
      print("json decode 1: ${m['data']}");
      switch (m['name']) {
        case 'channel add':
          isChannel(m['data']);
          break;

        case 'user add':
          onFetchUsers(m['data']);
          break;
        case 'message add':
          break;
        default:
      }
    });
  }

  
}
