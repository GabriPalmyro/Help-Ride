class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.photo,
    this.pixCode,
    this.isDriver,
    this.priceTwoPeople,
    this.priceThreePeople,
    this.priceFourPeople,
    this.priceFivePeople,
  });

  String? id;
  String? name;
  String? email;
  String? photo;
  String? pixCode;
  bool? isDriver;

  //preços
  double? priceTwoPeople;
  double? priceThreePeople;
  double? priceFourPeople;
  double? priceFivePeople;

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'photo': photo,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photo: json['photo'] ?? '',
      pixCode: json['pixCode'] ?? '',
      isDriver: json['isDriver'] ?? false,
      priceTwoPeople: json['priceTwoPeople'] ?? 0.0,
      priceThreePeople: json['priceThreePeople'] ?? 0.0,
      priceFourPeople: json['priceFourPeople'] ?? 0.0,
      priceFivePeople: json['priceFivePeople'] ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photo: $photo)';
  }
}
