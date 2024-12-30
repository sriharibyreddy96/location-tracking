class User {
  String id;
  String name;
  String email;
  String role;

  // Mark required parameters with the `required` keyword.
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Convert from JSON to User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? "", // Default to empty string if null
      name: json['name'] ?? "", // Default to empty string if null
      email: json['email'] ?? "", // Default to empty string if null
      role: json['role'] ?? "user", // Default to "user" if null
    );
  }
}
