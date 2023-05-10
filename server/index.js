import express from "express";
import mongoose from "mongoose";
import router from "./routes/index.js";
import cors from "cors";
import http from "http";
import socket from "socket.io";
import Document from "./models/document.js";

const app = express();
const server = http.createServer(app);
const io = socket(server);

const PORT = process.env.PORT || 3001;
const DB =
  process.env.DB ||
  `mongodb+srv://fleischerbruno:Mandarina90@cluster0.7q4yyh5.mongodb.net/?retryWrites=true&w=majority`;

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connected to Mongo");
  })
  .catch((e) => console.log(e));

app.use(express.json());
app.use(cors());
app.use((req, res, next) => {
  console.log("Got a request to ", req.protocol, req.hostname, req.url);
  console.log("body", req.body);
  next();
});

io.on("connection", (socket) => {
  console.log("Connected socket", socket.id);
  socket.on("join", (documentId) => {
    console.log("joined", documentId);
    socket.join(documentId);
  });

  socket.on("typing", (data) => {
    console.log("Typing", data);
    socket.broadcast.to(data.room).emit("changes", data);
  });

  socket.on("save", (data) => {
    console.log("save", data);
    saveData(data);
  });
});

const saveData = async (data) => {
  console.log(data);
  let document = await Document.findById(data.room);
  document.content = data.delta;
  document = await document.save();
};

server.listen(PORT, "0.0.0.0", () => {
  console.log("Server running on PORT: ", PORT);
});

app.use("/api", router);
