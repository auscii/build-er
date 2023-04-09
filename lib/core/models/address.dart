import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Address {
  String name;
  LatLng position;

  Address({
    required this.name,
    required this.position,
  });

  Map<String, dynamic> toFirestore() {
    GeoPoint pos = GeoPoint(position.latitude, position.longitude);
    return {"name": name, "position": pos};
  }

  factory Address.fromFirestore(Map<String, dynamic> data) {
    GeoPoint pos = data['position'];
    return Address(
        name: data['name'], position: LatLng(pos.latitude, pos.longitude));
  }
}