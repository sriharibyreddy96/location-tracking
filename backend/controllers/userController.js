const User = require('../models/User');

const getAllUsers = async (req, res) => {
  try {
    const users = await User.find();  // Fetch all users from the database
    res.status(200).json(users);  // Return users in JSON format
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Server error' });
  }
};

// Get user by ID including location
const getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json({
      name: user.name,
      email: user.email,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching user data' });
  }
};

module.exports = { getAllUsers, getUserById };

