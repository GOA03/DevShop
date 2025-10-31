class Addres {
  final String street;
  final String city;
  final String state;
  final String contry;
  final String name;
  final String number;
  final String userId;
  bool isDefault;

  Addres({
    required this.street,
    required this.city,
    required this.state,
    required this.contry,
    required this.number,
    required this.name,
    required this.userId,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'contry': contry,
      'name': name,
      'number': number,
      'isDefault': isDefault,
      'userId': userId,
    };
  }

  factory Addres.fromJson(Map<String, dynamic> json) {
    return Addres(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      contry: json['contry'],
      number: json['number'],
      name: json['name'],
      userId: json['userId'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}
