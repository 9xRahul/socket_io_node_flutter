const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: { origin: "*" },
});

io.on("connection", (socket) => {
  console.log("Connected:", socket.id);

  socket.on("join_room", (roomId) => {
    socket.join(roomId);
    console.log(socket.id, "joined", roomId);
  });

  socket.on("send_message", (data) => {
    socket.to(data.roomId).emit("receive_message", data);
  });

  socket.on("typing", (roomId) => {
    console.log(socket.id, "typing in", roomId);
    socket.to(roomId).emit("typing");
  });

  socket.on("stop_typing", (roomId) => {
    socket.to(roomId).emit("stop_typing");
  });
});

server.listen(3000, "0.0.0.0", () => {
  console.log("Socket.IO running on port 3000");
});
