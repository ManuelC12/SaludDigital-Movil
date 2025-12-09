class User {
  final String name;
  final String email;
  final String phone;
  final int age;
  final String gender;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // BUSCAMOS TODAS LAS VARIANTES POSIBLES:
      // 1. name (Estándar .NET)
      // 2. Name (PascalCase)
      // 3. nombre (Tu código anterior)
      name: json['name'] ?? json['Name'] ?? json['nombre'] ?? 'Usuario',
      
      email: json['email'] ?? json['Email'] ?? 'Sin correo',
      
      // OJO: .NET suele devolver 'phoneNumber'
      phone: json['phoneNumber'] ?? json['PhoneNumber'] ?? json['celular'] ?? 'Sin número',
      
      age: json['age'] ?? json['Age'] ?? json['edad'] ?? 0,
      
      // OJO: .NET suele devolver 'gender'
      gender: json['gender'] ?? json['Gender'] ?? json['genre'] ?? 'O',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
    };
  }
}