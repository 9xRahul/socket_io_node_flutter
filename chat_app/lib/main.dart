import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/socket_service.dart';
import 'state/chat_provider.dart';
import 'ui/chat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(SocketService()),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: ChatPage()),
    );
  }
}
