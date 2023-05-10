import express from "express";
import authRouter from "./v1/auth.js";
import healthRouter from "./v1/health.js";
import documentRouter from "./v1/document.js";

const router = express.Router();

const genVersion = (version) => {
  return (path) => {
    return `${version}${path}`;
  };
};

const versionOne = genVersion("/v1");

router.use(versionOne("/auth"), authRouter);
router.use(versionOne("/health"), healthRouter);
router.use(versionOne("/document"), documentRouter);

export default router;
