const jwt = require('jsonwebtoken');
const User = require('../models/User');

// Protect routes (check if user is authenticated)
const protect = async (req, res, next) => {
  let token;

  // Check if there's a token in the Authorization header
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    try {
      // Get token from Authorization header
      token = req.headers.authorization.split(' ')[1];

      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Get user from the database, excluding password field
      req.user = await User.findById(decoded.id).select('-password');
      
      // Proceed to the next middleware/route handler
      next();
    } catch (error) {
      console.error('Error in protect middleware:', error.message);
      res.status(401).json({ message: 'Not authorized, token failed' });
    }
  }

  if (!token) {
    res.status(401).json({ message: 'Not authorized, no token provided' });
  }
};

// Admin route protection
const admin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next(); // Proceed to next middleware/route handler
  } else {
    res.status(403).json({ message: 'Access denied, admin only' });
  }
};

module.exports = { protect, admin };
