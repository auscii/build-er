import 'package:client/core/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/appdata.dart';
import '../../../core/providers/location.dart';

class Maps extends StatefulWidget {
  static const String id = "Maps";
  const Maps({Key? key}) : super(key: key);
  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final MapController controller = MapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, details, child) {
        return FlutterMap(
          mapController: controller,
          options: MapOptions(
            center: details.location,
            minZoom: 12,
            zoom: 17,
            onMapReady: () {
              details.getUserLocation(context: context, controller: controller);
              details.locationInstance.onLocationChanged.listen((loc) {
                final Distance distance = new Distance();
                double currentUserLatitude = loc.latitude!.toDouble();
                double currentUserLongitude = loc.longitude!.toDouble();
                print("currentUserLatitude -> $currentUserLatitude currentUserLongitude -> $currentUserLongitude");
                details.updateLocation(
                  LatLng(
                    currentUserLatitude,
                    currentUserLongitude
                  ),
                );
                controller.move(details.location, 17);
                if (!Var.userReadsNearbyContractors) {
                  AppData.getNearbyContractorUsers(
                    currentUserLatitude,
                    currentUserLongitude,
                  );
                }
              });
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
            ),
            CurrentLocationLayer(),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 60,
                size: const Size(40, 40),
                fitBoundsOptions: const FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: Provider.of<AppData>(context).clients.map((client) {
                  return Marker(
                    width: 40.0,
                    height: 40.0,
                    point: client.address.position,
                    builder: (ctx) => const Icon(
                      Icons.garage,
                    ),
                  );
                }).toList(),
                polygonOptions: const PolygonOptions(
                  borderColor: Colors.blueAccent,
                  color: Colors.black12,
                  borderStrokeWidth: 3
                ),
                builder: (context, markers) {
                  return FloatingActionButton(
                    heroTag: "MAP",
                    onPressed: null,
                    child: Text(markers.length.toString()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
