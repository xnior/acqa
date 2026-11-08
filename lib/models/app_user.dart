class AppUser {
  const AppUser({
    required this.name,
    required this.ra,
    required this.email,
    required this.password,
  });

  final String name;
  final String ra;
  final String email;
  final String password;

  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final letters = parts.take(2).map((p) => p.isEmpty ? '' : p[0]);
    return letters.join().toUpperCase();
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    name: json['name'] as String,
    ra: json['ra'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'ra': ra,
    'email': email,
    'password': password,
  };
}
