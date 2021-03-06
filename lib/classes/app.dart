import 'package:chat_app/classes/channel.dart';
import 'package:chat_app/classes/message.dart';
import 'package:chat_app/classes/user.dart';
import 'package:chat_app/ui/message_ui.dart';

class App {
  List<ChannelClass> channels;
  List<UserClass> users;
  List<MessageClass> messages;
  Map activeChannel;
  bool connected;
}
