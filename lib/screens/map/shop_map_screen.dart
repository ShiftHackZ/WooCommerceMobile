import 'dart:async';

import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wooapp/config/theme.dart';
import 'package:wooapp/datasource/shopmap_data_source.dart';
import 'package:wooapp/locator.dart';
import 'package:wooapp/model/woo_shop.dart';
import 'package:wooapp/screens/map/map_helper.dart';
import 'package:wooapp/screens/map/shop_marker.dart';

class ShopMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShopMapState();
}

class _ShopMapState extends State<ShopMap> {
  final ShopMapDataSource _ds = locator<ShopMapDataSource>();

  final Set<Marker> _markers = Set();

  final int _minClusterZoom = 0;

  final int _maxClusterZoom = 19;
  
  Fluster<ShopMarker>? _clusterManager;

  final Completer<GoogleMapController> _mapController = Completer();

  double _currentZoom = 15;

  bool _isMapLoading = true;

  bool _areMarkersLoading = true;

  final Color _clusterColor = Colors.blue;

  final Color _clusterTextColor = Colors.white;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(
        color: WooAppTheme.colorToolbarForeground,
      ),
      title: Text(
        'Map',
        style: TextStyle(
          color: WooAppTheme.colorToolbarForeground,
        ),
      ),
      backgroundColor: WooAppTheme.colorToolbarBackground,
    ),
    body: SafeArea(
      child: Container(
        child: GoogleMap(
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(48.41471900878479,  35.080945944642366),
            zoom: _currentZoom,
          ),
          markers: _markers,
          onMapCreated: (controller) => onMapCreated(controller),
          onCameraMove: (position) => _updateMarkers(position.zoom),
        ),
      ),
    ),
  );

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);

    setState(() {
      _isMapLoading = false;
    });

    fetchPins();
  }

  void fetchPins() {
    _ds.getShops().then((pins) {
      _initMarkers(pins);
    }).catchError((error) {
      print('fetch pin error: $error');
    });
  }

  _initMarkers(List<WooGeoShop> pins) async {
    final List<ShopMarker> markers = [];

    for (WooGeoShop pin in pins) {
      markers.add(
        ShopMarker(
          pin.id.toString(),
          position: LatLng(pin.lat, pin.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
        ),
      );
    }

    _clusterManager = await MapHelper.initClusterManager(markers, _minClusterZoom, _maxClusterZoom);
  }

  Future<void> _updateMarkers([double? updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    setState(() {
      _areMarkersLoading = true;
    });

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      _clusterColor,
      _clusterTextColor,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
  }
}