import 'dart:async';
import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class ChatProvider extends ChangeNotifier {
  final SocketService socketService;
  final String roomId = "room1";

  List<String> messages = [];
  bool isTyping = false;
  bool isUserOnline = false;
  Timer? typingTimer;

  ChatProvider(this.socketService) {
    socketService.connect();
    socketService.joinRoom(roomId);

    socketService.socket.on('receive_message', (data) {
      messages.add("Friend: ${data['message']}");
      notifyListeners();
    });

    socketService.socket.on('typing', (_) {
      isTyping = true;
      notifyListeners();
    });

    socketService.socket.on('stop_typing', (_) {
      isTyping = false;
      notifyListeners();
    });

    socketService.socket.on('user_status', (data) {
      isUserOnline = data['online'];
      notifyListeners();
    });
  }

  void sendMessage(String msg) {
    messages.add("Me: $msg");

    
    socketService.sendMessage({'roomId': roomId, 'message': msg});
    notifyListeners();
  }

  void onTyping(String _) {
    socketService.typing(roomId);

    typingTimer?.cancel();
    typingTimer = Timer(
      const Duration(milliseconds: 600),
      () => socketService.stopTyping(roomId),
    );
  }

  @override
  void dispose() {
    typingTimer?.cancel();
    socketService.dispose();
    super.dispose();
  }
}
