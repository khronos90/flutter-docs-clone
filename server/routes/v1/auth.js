import express from "express";
import User from "../../models/user.js";
import jwt from "jsonwebtoken";
import { auth } from "../../middlewares/auth.js";

const authRouter = express.Router("");

authRouter.post("/signup", async (req, res) => {
  try {
    let status = 200;
    const { name, email, profilePic } = req.body || {};

    if (!email || !name) {
      throw "Email or Name missing";
    }

    let user = await User.findOne({ email });
    if (!user) {
      user = new User({
        email,
        profilePic,
        name,
      });
      user = await user.save();
      status = 201;
    }
    const token = jwt.sign({ id: user._id }, "passwordKey");

    return res.status(status).json({ user, token });
  } catch (error) {
    return res.status(500).send({ error });
  }
});

authRouter.get("/", auth, async (req, res) => {
  const id = req.user;
  try {
    const user = await User.findById(id);
    if (!user) {
      throw "User not found";
    }
    return res.status(200).json({ user, token: req.token });
  } catch (error) {
    return res
      .status(500)
      .json({ message: "Error at getting user", error: error });
  }
});

export default authRouter;
