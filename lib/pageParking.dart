import 'package:flutter/material.dart';
import 'package:flutter_usmb_parking/class/Coordonnees';
import 'package:flutter_usmb_parking/class/ParkingListItem.dart';
import 'package:flutter_usmb_parking/functions/server_request.dart';

class ParkingListPage extends StatelessWidget {
  // Construisez votre page ici
  @override
  Widget build(BuildContext context) {
    debugPrint("VAMOS");
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('TROUVE TON PARKING',
              style: TextStyle(color: Colors.white))),
      body: FutureBuilder<List<Coordonnees>>(
        future: getAllParking(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Affichez la liste des parkings
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Coordonnees parking = snapshot.data![index];
                return ParkingListItem(parking: parking);
              },
            );
          } else {
            return Text('Aucune donnée disponible');
          }
        },
      ),
    );
  }
}
