import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config/socket_config.dart';

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      SocketConfig.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );
  }

  void joinRoom(String roomId) {
    socket.emit('join_room', roomId);
  }

  void sendMessage(Map<String, dynamic> data) {
    socket.emit('send_message', data);
  }

  void typing(String roomId) {
    socket.emit('typing', roomId);
  }

  void stopTyping(String roomId) {
    socket.emit('stop_typing', roomId);
  }

  void dispose() {
    socket.dispose();
  }
}
