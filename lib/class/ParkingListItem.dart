import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_usmb_parking/class/Coordonnees';
import 'package:flutter_usmb_parking/functions/settingRoad.dart';
import 'package:flutter_usmb_parking/variables/globalVariables.dart';

class ParkingListItem extends StatelessWidget {
  final Coordonnees parking;

  ParkingListItem({required this.parking});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300], // Couleur de fond du rectangle
      child: ListTile(
        title: Text(parking.getName), // Nom du parking
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                await findMaPosition();
                // Ajouter un WayPoint et lancer un trajet ici
                // Utilisez parking.latitude et parking.longitude pour obtenir la position
                var wayPoints = <WayPoint>[];

                wayPoints.add(maPos);

                monParking = WayPoint(
                    name: parking.getName,
                    latitude: parking.getLatitude,
                    longitude: parking.longitude,
                    isSilent: false);

                wayPoints.add(monParking);

                await navigation.startNavigation(wayPoints: wayPoints);
              },
              child: Text("Aller à ce Parking !"),
            ),
            Text(
              "Nombre de personnes n'ayant pas trouvé de places la dernière heure : ${parking.getCount}",
            ),
            Text(
              "Nombre de personnes ayant réussi à se garer la dernière heure: ${parking.getNBReussi}",
            ),
            Row(
              children: [
                Text("Dernière mise à jour : "),
                Text("${parking.heure.hour}:${parking.getHeure.minute}"),
              ],
            ),
            Icon(
              parking.isAvailable ? Icons.check_circle : Icons.cancel,
              color: parking.isAvailable ? Colors.green : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
