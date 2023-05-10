import express from "express";

const healthRouter = express.Router();

healthRouter.get("/", (req, res) => {
  console.log(res);
  return res.status(200).json({ message: "hello world" });
});

export default healthRouter;
