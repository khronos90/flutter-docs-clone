import express from "express";
import { auth } from "../../middlewares/auth.js";
import Document from "../../models/document.js";

const documentRouter = express.Router();

documentRouter.post("/create", auth, async (req, res) => {
  try {
    const { createdAt } = req.body;
    let document = new Document({
      uid: req.user,
      createdAt,
    });
    document = await document.save();
    console.log(document);
    res.status(201).json({ data: document });
  } catch (error) {
    res.status(500).json({ message: "Error at doc post", error: error });
  }
});

documentRouter.get("/", auth, async (req, res) => {
  try {
    let documents = await Document.find({ uid: req.user });
    return res.status(200).json({ data: documents });
  } catch (error) {
    res.status(500).json({ message: "Error at getting docs", error: error });
  }
});

documentRouter.post("/title", async (req, res) => {
  try {
    const { id, title } = req.body;
    const document = await Document.findByIdAndUpdate(id, { title });
    res.status(200).json({ data: document });
  } catch (error) {
    res.status(500).json({ message: "Error at getting docs", error: error });
  }
});

documentRouter.get("/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    let document = await Document.findById(id);
    console.log(document);
    return res.status(200).json({ data: document });
  } catch (error) {
    res.status(500).json({ message: "Error at getting docs", error: error });
  }
});

export default documentRouter;
