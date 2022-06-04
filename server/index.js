const express = require("express");
const http = require("http");
const mongosse = require("mongoose");

require("dotenv").config();

const app = express();
const port = process.env.port || 3000;
const Room = require("./models/room");
var server = http.createServer(app);

var io = require("socket.io")(server);

//Middle Ware
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Server Is Runing");
});

const DB =
  "mongodb+srv://meraklicoder:Erer3242078er@cluster0.5cuap.mongodb.net/myFirstDatabase?retryWrites=true&w=majority";

io.on("connection", (socket) => {
  console.log("Connected!");
  socket.on("createRoom", async ({ nickname }) => {
    try {
      let room = new Room();
      let player = {
        socketID: socket.id,
        nickname: nickname,
        playerType: "X",
      };
      room.players.push(player);
      room.turn = player;
      room = await room.save();
      const roomId = room._id.toString();
      socket.join(roomId);

      io.to(roomId).emit("createRoomSuccess", room);
    } catch (err) {
      console.log(err);
    }
  });

  socket.on("joinRoom", async ({ nickname, roomId }) => {
    try {
      if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        socket.emit("errorOccurred", "Please enter a valid room ID.");
        return;
      }

      let room = await Room.findById(roomId);

      if (room.isJoin) {
        let player = {
          nickname,
          socketID: socket.id,
          playerType: "O",
        };

        socket.join(roomId);
        room.players.push(player);
        room.isJoin = false;
        room = await room.save();

        io.to(roomId).emit("joinRoomSuccess", room);
        io.to(roomId).emit("updatePlayers", room.players);
        io.to(roomId).emit("updateRoom", room);
      } else {
        socket.emit(
          "errorOccurred",
          "The Game is in Progress Try Again Later."
        );
      }
    } catch (err) {
      console.log(err);
    }
  });

  socket.on("tap", async ({ index, roomId }) => {
    try {
      let room = await Room.findById(roomId);

      let choice = room.turn.playerType;
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }

      room = await room.save();

      io.to(roomId).emit("tapped", {
        index,
        choice,
        room,
      });
    } catch (err) {
      console.log(err);
    }
  });

  socket.on("winner", async ({ winnerSocketId, roomId }) => {
    try {
      let room = await Room.findById(roomId);
      let player = room.players.find(
        (playerr) => playerr.socketID == winnerSocketId
      );
      player.points += 1;
      room = await room.save();

      if (player.points >= room.maxRounds) {
        io.to(roomId).emit("endGame", player);
      } else {
        io.to(roomId).emit("pointIncrease", player);
      }
    } catch (err) {
      console.log(err);
    }
  });
});

mongosse
  .connect(process.env.DATABASE_URI || DB)
  .then(() => {
    console.log("Conntection Successfuly !");
  })
  .catch((e) => {
    console.log(e);
  });

server.listen(process.env.PORT || port, "0.0.0.0", () => {
  console.log(`Server Started and Runing on Port: ${port}`);
});
