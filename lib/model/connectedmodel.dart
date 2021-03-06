import 'dart:convert';

import 'package:chat_app/classes/channel.dart';
import 'package:chat_app/classes/message.dart';
import 'package:chat_app/classes/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ConnectedModel extends Model {
  String selectedchannel;
  int selectedchannelID;
  WebSocketChannel channel;
  bool isloadingChannel = true;
  bool isloadingUser = true;
  bool isloadingMssg = true;

  List<MessageClass> _mssg = [];
  int counter = 0; //genereate sample id
  Map<int, List<MessageClass>> _chanMssg = {};
}

class ChannelModel extends ConnectedModel {
  List<ChannelClass> _channel = [];

  void selectChannel(int i) {
    selectedchannel = _channel[i].name;
    selectedchannelID = _channel[i].id;
    notifyListeners();
  }

  List<ChannelClass> get channels {
    return List.from(_channel);
  }

  void fetchDataFromServer() {
    // dynamic val = json data from server
    //fetch channel struct val and mssg val and users
    //add to a map
  }

  void sendDataToServer() {
    // http.post(selectedchannelID,mssgtext)
  }

  bool isChannel(Map<String, dynamic> value) {
    try {
      ChannelClass channelClass =
          ChannelClass(id: value['id'], name: value['name']);
      _channel.add(channelClass);
      isloadingChannel = false;
      notifyListeners();
      print(' received channels : $_channel');
      return true;
    } catch (e) {
      print("error occured : $e");
    }

    return false;
  }

  void addChannel(String chanName) {
    Map<String, dynamic> map = {
      'name': 'channel add',
      'data': {'id': chanName.length, 'name': chanName}
    };
    var jsonval = json.encode(map);
    channel.sink.add(jsonval); //adding to server via websocket
  }

  List<MessageClass> selectedChanMssg() {
    //This function gives the message when user opens a channel
    bool val = _chanMssg.containsKey(selectedchannelID);
    if (val) {
      return _chanMssg[selectedchannelID];
    }
    return [];
  }
}

class UserModel extends ConnectedModel {
  List<UserClass> _users = [];

  Map<String, dynamic> map = {
    'name': 'user add',
  };
  void onAddUser() {
    String userName = 'Anonymous';
    map['data'] = {'id': userName.length, 'name': userName};
    var jsonval = json.encode(map);
    channel.sink.add(jsonval);
  }

  void onFetchUsers(Map<String, dynamic> value) {
    UserClass userClass = UserClass(id: value['id'], name: value['name']);
    _users.add(userClass);
    isloadingUser = false;
    notifyListeners();
  }

  void onEditUser(String editUser) {
    for (var user in _users) {
      if (user.id == map['data']['id']) {
        map['data'] = {'id': user.id, 'name': editUser};
        channel.sink.add(json.encode(map));
        
      }
    }
  }

  void setOtherUsers() {}

  List<UserClass> get users {
    return List.from(_users);
  }

  void updateUname(String name) {
    UserClass updateUser = new UserClass(id: name.length, name: name);
    _users[0] = updateUser;

    UserClass _userclass = UserClass(id: name.length, name: name);
    _users.add(_userclass);
  }
}

class MessageModel extends ConnectedModel {
  List<MessageClass> _mssg = [];

  List<MessageClass> get mssg {
    return _mssg;
  }

  void addMessage(MessageClass message) {
    _mssg.add(message);
  }
}
