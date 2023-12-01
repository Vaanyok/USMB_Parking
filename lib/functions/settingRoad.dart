import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_usmb_parking/functions/server_request.dart';
import 'package:flutter_usmb_parking/src/alertButtonComponant.dart';
import 'package:flutter_usmb_parking/variables/globalVariables.dart';
import 'package:geolocator/geolocator.dart';

// Fonction qui permet de savoir si l'utilisateur est arrivé

// var parkingIcon = const MarkerIcon(
//   icon: Icon(Icons.local_parking_rounded),
// );

// Fonction qui demande au serveur le parking le plus près
Future<void> findAParking() async {
  Position pos = await GeolocatorPlatform.instance.getCurrentPosition();
  maPos = WayPoint(
      name: "MaLoc",
      latitude: pos.latitude,
      longitude: pos.longitude,
      isSilent: true);

  monParking = await requestParkingSERVER(pos.latitude, pos.longitude);

  // if (!context.mounted) return;
  // confirmeRoute(context, wayPoints);
}

Future<void> findMaPosition() async {
  Position pos = await GeolocatorPlatform.instance.getCurrentPosition();
  maPos = WayPoint(
      name: "MaLoc",
      latitude: pos.latitude,
      longitude: pos.longitude,
      isSilent: true);

  // if (!context.mounted) return;
  // confirmeRoute(context, wayPoints);
}

// //Fonction qui crée le chemin entre la position actuelle et le parking d'arrivé
// // // en mettant à jour sur la carte
// // Future<void> createRoad(bool afficheRoute) async {
// //   //maPos = generateRandomGeoPoint();
// //   RoadInfo roadInfo = await mapController.drawRoad(maPos, parkingGare.geoPoint,
// //       roadOption: RoadOption(
// //           zoomInto: afficheRoute,
// //           roadColor: Color(Colors.blue.blue),
// //           roadBorderWidth: 16));
// // }

// // void drawRoute(BuildContext context) async {
// //   // trajet =
// //   //     {maPos, parkingGare.geoPoint} as Map<GeoPoint, GeoPoint>;
// //   createRoad(true);
// //   if (!context.mounted) return;
// //   await confirmeRoute(context);
// // }
