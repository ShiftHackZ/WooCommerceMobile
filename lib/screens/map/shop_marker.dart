import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopMarker extends Clusterable {
  final String id;
  final LatLng position;
  late final BitmapDescriptor icon;

  ShopMarker(
      this.id, {
      this.position = const LatLng(0,0),
      this.icon = BitmapDescriptor.defaultMarker,
      bool isCluster = false,
      int clusterId = 0,
      int pointsSize = 1,
      String childMarkerId = ''
  }) : super(
    markerId: id,
    latitude: position.latitude,
    longitude: position.longitude,
    isCluster: isCluster,
    clusterId: clusterId,
    pointsSize: pointsSize,
    childMarkerId: childMarkerId
  );

  Marker  toMarker() => Marker(
    markerId: MarkerId(isCluster! ? 'cl_$id' : id),
    position: LatLng(
      position.latitude,
      position.longitude
    ),
    icon: icon
  );
}