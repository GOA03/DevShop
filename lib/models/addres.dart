class Addres {
  final String addresId;
  final String street;
  final String city;
  final String state;
  final String contry;
  final String name;
  final String number;
  final String userId;

  Addres({
    required this.addresId,
    required this.street,
    required this.city,
    required this.state,
    required this.contry,
    required this.number,
    required this.name,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'addresId': addresId,
      'street': street,
      'city': city,
      'state': state,
      'contry': contry,
      'name': name,
      'number': number,
      'userId': userId,
    };
  }

  factory Addres.fromJson(Map<String, dynamic> json) {
    return Addres(
      addresId: json['addresId'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      contry: json['contry'],
      number: json['number'],
      name: json['name'],
      userId: json['userId'],
    );
  }

  Addres.fromMap(Map<String, dynamic> map)
    : addresId = map['addresId'],
      street = map['street'],
      city = map['city'],
      state = map['state'],
      contry = map['contry'],
      number = map['number'],
      name = map['name'],
      userId = map['userId'];
}
