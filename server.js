const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: { origin: "*" },
});

// Track how many users are inside each room
const roomUsers = {}; // { roomId: count }

// Test route (open in phone browser to confirm connectivity)
app.get("/", (req, res) => {
  res.send("Socket.IO Chat Server Running");
});

io.on("connection", (socket) => {
  console.log("✅ Connected:", socket.id);

  // Join room
  socket.on("join_room", (roomId) => {
    socket.join(roomId);
    socket.roomId = roomId;

    if (!roomUsers[roomId]) {
      roomUsers[roomId] = 0;
    }

    roomUsers[roomId]++;
    console.log(`👥 Users in ${roomId}: ${roomUsers[roomId]}`);

    // Emit presence to ALL users in room
    io.to(roomId).emit("user_status", {
      online: roomUsers[roomId] > 1,
    });
  });

  // Receive message
  socket.on("send_message", (data) => {
    console.log(`💬 ${socket.id} -> ${data.roomId}: ${data.message}`);

    socket.to(data.roomId).emit("receive_message", data);
  });

  // Typing indicator
  socket.on("typing", (roomId) => {
    socket.to(roomId).emit("typing");
  });

  socket.on("stop_typing", (roomId) => {
    socket.to(roomId).emit("stop_typing");
  });

  // Handle disconnect
  socket.on("disconnect", () => {
    console.log("❌ Disconnected:", socket.id);

    if (socket.roomId && roomUsers[socket.roomId]) {
      roomUsers[socket.roomId]--;

      console.log(`👥 Users in ${socket.roomId}: ${roomUsers[socket.roomId]}`);

      io.to(socket.roomId).emit("user_status", {
        online: roomUsers[socket.roomId] > 1,
      });
    }
  });
});

// VERY IMPORTANT for real devices
server.listen(3001, "0.0.0.0", () => {
  console.log("🚀 Socket.IO running on port 3000");
});
