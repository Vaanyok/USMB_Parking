import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_usmb_parking/functions/server_request.dart';
import 'package:flutter_usmb_parking/variables/globalVariables.dart';

SnackBar routeSnackbar(GlobalKey<ScaffoldMessengerState> messengerKey) {
  return SnackBar(
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Texte et bouton dans une ligne
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Texte à gauche
            Text(
              'Vous allez au Parking  ${monParking.name}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            // Bouton à droite
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(color: Colors.grey),
              ),
              child: IconButton(
                onPressed: () {
                  messengerKey.currentState?.hideCurrentSnackBar();
                  timer.cancel();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),

        // LinearProgressIndicator
        LinearProgressIndicator(
          backgroundColor: Colors.grey,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ],
    ),
  );
}

SnackBar findParkingSnackbar(GlobalKey<ScaffoldMessengerState> messengerKey,
    GlobalKey<FormState> inputKey) {
  return SnackBar(
    duration: Duration(seconds: 60),
    content: Column(
      children: [
        Text('Avez-vous trouvé une place ?'),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(color: Colors.grey),
              ),
              child: IconButton(
                onPressed: () async {
                  monParking = await changeParking();
                  var wayPoints = <WayPoint>[];
                  wayPoints.add(maPos);
                  wayPoints.add(monParking);

                  timer = Timer(Duration(seconds: 3), () async {
                    // Appeler cette fonction après 3 secondes
                    await navigation.startNavigation(wayPoints: wayPoints);
                  });

                  //navigation.startNavigation(wayPoints: wayPoints);
                  if (inputKey.currentState!.validate()) {
                    messengerKey.currentState!
                        .showSnackBar(routeSnackbar(messengerKey));
                  }
                  messengerKey.currentState?.hideCurrentSnackBar();
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(color: Colors.grey),
              ),
              child: IconButton(
                onPressed: () {
                  addATrouvePlace();
                  messengerKey.currentState?.hideCurrentSnackBar();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
