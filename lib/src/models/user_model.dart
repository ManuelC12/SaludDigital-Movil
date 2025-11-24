class User {
  final String nombre;
  final String email;
  final String celular;
  final String password;
  final int edad;
  final String genre;

  User({
    required this.nombre,
    required this.email,
    required this.celular,
    required this.password,
    required this.edad,
    required this.genre,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'email': email,
      'celular': celular,
      'password': password,
      'edad': edad,
      'genre': genre,
    };
  }
}