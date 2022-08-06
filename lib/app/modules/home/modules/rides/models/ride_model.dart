class RideModel {
  RideModel({
    this.id,
    this.name,
    this.totalRides,
    this.totalToPay,
    this.driverId,
    this.isCompleteRide,
    this.passenger,
    this.rideDate,
  });

  String? id;
  String? name;
  String? driverId;
  int? passenger;
  bool? isCompleteRide;
  String? rideDate;
  double? totalRides;
  double? totalToPay;

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      driverId: json['driverId'] ?? '',
      rideDate: json['ride_date'] ?? 'NENHUMA DATA',
      totalRides: json['total_rides'] ?? 0.0,
      totalToPay: json['total_to_pay'] ?? 0.0,
      passenger: json['passengers'] ?? 0,
      isCompleteRide: json['isCompleteRide'] ?? true,
    );
  }

  @override
  String toString() {
    return 'RideModel(id: $id, name: $name, priceToPay: $totalToPay, totalToPay: $totalRides, rideData: $rideDate)';
  }
}
