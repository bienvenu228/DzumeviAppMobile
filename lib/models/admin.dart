class Admin {
  final int id;
  final String name;
  final String email;

  Admin({required this.id, required this.name, required this.email});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      name: json['name'],
      email: json['email'] ?? '',
    );
  }
}
