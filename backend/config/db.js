const mongoose = require('mongoose');
require('dotenv').config();  // Ensure .env is loaded

const connectDB = async () => {
  try {
    console.log('MONGO_URI:', process.env.MONGO_URI); // Check MONGO_URI

    const conn = await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1); // Exit process with failure
  }
};

module.exports = connectDB;
