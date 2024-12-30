const Location = require('../models/Location');

// Store location data for a user
const storeLocation = async (req, res) => {
  const { userId, latitude, longitude } = req.body;

  try {
    const newLocation = new Location({
      userId,
      latitude,
      longitude,
      timestamp: new Date(),
    });

    await newLocation.save();
    res.status(201).json({ message: 'Location saved successfully', location: newLocation });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to save location data' });
  }
};


// Fetch the latest location for a user
const getUserLocation = async (req, res) => {
  const { userId } = req.params;

  try {
    const location = await Location.findOne({ userId })
      .sort({ timestamp: -1 }); // Sort by timestamp in descending order to get the latest location

    if (!location) {
      return res.status(404).json({ message: 'Location not found for this user' });
    }

    res.status(200).json(location);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to fetch location data' });
  }
};

module.exports = { storeLocation, getUserLocation };
