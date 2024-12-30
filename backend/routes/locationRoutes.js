const express = require('express');
const { storeLocation, getUserLocation } = require('../controllers/locationController');
const router = express.Router();

// Route to store location data
router.post('/store-location', storeLocation);

// Route to get the latest location for a user
router.get('/get-location/:userId', getUserLocation);

module.exports = router;
