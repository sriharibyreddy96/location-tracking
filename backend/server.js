require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const locationRoutes = require('./routes/locationRoutes'); // Add location routes
const { updateUserLocation } = require('./controllers/locationController'); // Import update location function

// Connect to DB
connectDB();

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/location', locationRoutes); // Add location routes

// Periodic location update (every 1 hour)
setInterval(async () => {
  try {
    // Example: You could loop through all users and fetch their latest coordinates.
    // In a real-world app, you'd get their coordinates dynamically or via an API.
    const users = await User.find(); // Fetch all users
    for (const user of users) {
      // Call the function to update the location for each user
      // For now, use dummy latitude and longitude values. Replace with real ones.
      const latitude = 37.7749;  // Replace with dynamic value
      const longitude = -122.4194;  // Replace with dynamic value
      await updateUserLocation(user._id, latitude, longitude);
    }
  } catch (error) {
    console.error('Error during periodic location update:', error);
  }
}, 60 * 60 * 1000); // Every hour (60 minutes * 60 seconds * 1000 milliseconds)

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!' });
});

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
