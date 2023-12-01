// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
// import 'package:flutter_usmb_parking/functions/server_request.dart';
// import 'package:flutter_usmb_parking/variables/globalVariables.dart';

// Future<void> dialogTrouveParking(BuildContext context) async {
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: const Text('Vous êtes arrivé au parking'),
//         content: const Text('Avez vous trouvé une place ?'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () async {
//               WayPoint p = await changeParking();
//               You can use the 'p' variable if needed.
//               Navigator.pop(context, 'Non');
//             },
//             child: const Text('Non'),
//           ),
//           TextButton(
//             onPressed: () {
//               controller?.clearRoute();
//               Navigator.pop(context, 'Oui');
//             },
//             child: const Text('Oui'),
//           ),
//         ],
//       );
//     },
//   );
// }

// Future<void> confirmeRoute(BuildContext context) {
//   String? nom = monParking.name;
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext dialogContext) {
//       return AlertDialog(
//         title: const Text('Direction un Parking'),
//         content: Text('Direction parking : $nom'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               controller?.clearRoute();
//             },
//             child: const Text('ANNULEZ'),
//           ),
//           TextButton(
//             onPressed: () async {
//               MapBoxNavigation.instance.startNavigation(wayPoints: wpts);
//             },
//             child: const Text('COMMENCER'),
//           ),
//         ],
//       );
//     },
//   );
// }
