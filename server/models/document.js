import mongoose from "mongoose";

const documentSchema = mongoose.Schema({
  uid: {
    required: true,
    type: String,
  },
  createdAt: {
    required: true,
    type: Number,
  },
  title: {
    required: true,
    type: String,
    trim: true,
    default: "Untitled Document",
  },
  content: {
    type: Array,
    default: [],
  },
});

const Document = mongoose.model("document", documentSchema);

export default Document;
