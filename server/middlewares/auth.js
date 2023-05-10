import jwt from "jsonwebtoken";

export const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ message: "no token, access denied" });
    }

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) {
      return res.status(401).json({ message: "Invalid token" });
    }

    req.user = verified.id;
    req.token = token;
    next();
  } catch (error) {
    return res.status(500).json({ message: "Validation error", error });
  }
};
