import 'dart:convert';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_usmb_parking/class/Coordonnees';
import 'package:flutter_usmb_parking/variables/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

const addr = "7608-2a04-cec0-1109-82d1-6016-f34c-893-44ca.ngrok-free.app";

Future<WayPoint> requestParkingSERVER(double latitude, double longitude) async {
  String url =
      "https://$addr/calculateRoute?NOM=maPosition&LAT=$latitude&LONG=$longitude";

  debugPrint("URL : $url");
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String data = response.body;

      debugPrint("Données récupérées du serveur : $data");
      WayPoint parking = WayPoint(
          name: jsonData["NAME"],
          latitude: jsonData["LAT"],
          longitude: jsonData["LONG"],
          isSilent: false);

      debugPrint("Données récupérées du WAYPOINT : ${parking.name}");

      return parking;
    } else {
      throw "Erreur de réponse du serveur : ${response.statusCode}";
    }
  } catch (error) {
    throw "Erreur lors de la requête au serveur : $error";
  }
}

Future<WayPoint> changeParking() async {
  WayPoint p = monParking;

  String? nom = p.name;
  String url = "https://$addr/parkingNonDispo?NAME=$nom";

  debugPrint("URL : $url");
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      String data = response.body;

      debugPrint("Données récupérées du serveur : $data");
      WayPoint parking = WayPoint(
          name: jsonData["NAME"],
          latitude: jsonData["LAT"],
          longitude: jsonData["LONG"],
          isSilent: false);

      debugPrint("STATUS CHANGED${parking.name}");
      return parking;
    } else {
      throw "Erreur de réponse du serveur : ${response.statusCode}";
    }
  } catch (error) {
    throw "Erreur lors de la requête au serveur : $error";
  }
}

Future<List<Coordonnees>> getAllParking() async {
  String url = "https://$addr/getAllInfos";
  try {
    final response = await http.get((Uri.parse(url)));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      debugPrint("TERREUR");
      List<Coordonnees> coordonneesList = jsonData.map((data) {
        return Coordonnees.fromJson(data);
      }).toList();
      debugPrint("TERREUR2");
      return coordonneesList;
    } else {
      throw "Erreur de réponse du serveur : ${response.statusCode}";
    }
  } catch (error) {
    throw "Erreur lors de la requête au serveur : $error";
  }
}

Future<void> addATrouvePlace() async {
  WayPoint p = monParking;

  String? nom = p.name;
  String url = "https://$addr/?aTrouvePlace=$nom";
  try {
    final response = await http.get((Uri.parse(url)));

    if (response.statusCode == 200) {
      //List<dynamic> jsonData = jsonDecode(response.body);
      debugPrint("A AJOUTE");
    } else {
      throw "Erreur de réponse du serveur : ${response.statusCode}";
    }
  } catch (error) {
    throw "Erreur lors de la requête au serveur : $error";
  }
}
