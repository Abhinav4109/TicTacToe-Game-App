const express = require('express');
const http = require('http');
const mongoose = require('mongoose');
const Room = require('./models/room');


const port = process.env.PORT || 3000;

// intializing express
const app = express();
var server = http.createServer(app);

app.get('/', (req, res) => {
    res.send('Hello')
})
var io = require('socket.io')(server);
// socket
io.on("connection", socket => {
    console.log("connected!");

    // Create Room
    socket.on('createRoom', async ({ nickname }) => {
        try {
            let room = new Room();
            console.log(socket.id);
            let player = {
                socketID: socket.id,
                nickname,
                playerType: 'X',
            };
            room.players.push(player);
            room.turn = player;

            room = await room.save();

            const roomId = room._id.toString();
            socket.join(roomId);
            io.to(roomId).emit("createRoomSuccess", room);
        } catch (e) {
            console.log(e);
        }
    });

    // Join Room
    socket.on('joinRoom', async ({ nickname, roomId }) => {
        try {
            if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
                socket.emit('errorOccurred', 'Please enter a valid game id.');
                return;
            }
            let room = await Room.findById(roomId);

            if (room.isJoin) {
                let player = {
                    nickname,
                    socketID: socket.id,
                    playerType: 'O',
                }
                socket.join(roomId);
                room.players.push(player);
                room.isJoin = false;
                room = await room.save();
                io.to(roomId).emit("joinRoomSuccess", room);
                io.to(roomId).emit("updatePlayers", room.players);
                io.to(roomId).emit("updateRoom", room);
            } else {
                socket.emit('errorOccurred', 'The game is already in progress; you can create a new room to play with your friends.');
            }
        } catch (e) {
            console.log(e);
        }
    });


    socket.on('tap', async ({ index, roomId }) => {
        try {
            let room = await Room.findById(roomId);
            let choice = room.turn.playerType; // jiska turn hai wo 'o' hai ya 'x' from server
            if (room.turnIndex == 0) {
                room.turn = room.players[1];
                room.turnIndex = 1;
            } else {
                room.turn = room.players[0];
                room.turnIndex = 0;
            }

            room = await room.save();
            io.to(roomId).emit('tapped', {
                index,
                choice,
                room,
            })

        } catch (e) {
            console.log(e);
        }
    });

    socket.on('winner', async ({ winnerSocketId, roomId }) => {
        try {
            if (socket.id != winnerSocketId) { return; }
            let room = await Room.findById(roomId);
            let player = room.players.find(
                (playerr) => playerr.socketID == winnerSocketId
            );
            console.log(player.points);
            player.points += 1;
            console.log(player.points);
            room = await room.save();

            if (player.points >= room.maxRounds) {
                io.to(roomId).emit('endGame', player);
            } else {
                io.to(roomId).emit("pointIncrease", player)
            }
        } catch (e) {
            console.log(e);
        }
    });

});



const DB = 'mongodb+srv://abhinav:tictactoe@cluster0.irlo5lb.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0';

mongoose.connect(DB).then(() => {
    console.log('Yehh.. DB Connection Success');
}).catch((e) => {
    console.log(`Somthing went wrong ${e}`);
});


server.listen(port, () => {
    console.log(`Server started at ${port}`);
});