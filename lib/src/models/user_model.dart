class User {
  final String id;          // Nuevo: Necesario para agendar citas
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String role;     // Nuevo: 'Paciente' o 'Terapeuta'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    this.role = 'Paciente', // Valor por defecto
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // BUSCAMOS TODAS LAS VARIANTES POSIBLES:
      
      // 1. ID (Fundamental para las relaciones en BD)
      id: json['id'] ?? json['Id'] ?? 0,

      // 2. Name
      name: json['name'] ?? json['Name'] ?? json['nombre'] ?? 'Usuario',
      
      // 3. Email
      email: json['email'] ?? json['Email'] ?? 'Sin correo',
      
      // 4. Phone (.NET suele devolver 'phoneNumber')
      phone: json['phoneNumber'] ?? json['PhoneNumber'] ?? json['celular'] ?? 'Sin número',
      
      // 5. Age
      age: json['age'] ?? json['Age'] ?? json['edad'] ?? 0,
      
      // 6. Gender (.NET suele devolver 'gender')
      gender: json['gender'] ?? json['Gender'] ?? json['genre'] ?? 'O',

      // 7. Role (Nuevo campo para seguridad)
      role: json['role'] ?? json['Role'] ?? 'Paciente',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'role': role,
    };
  }
}