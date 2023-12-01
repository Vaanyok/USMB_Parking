import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:flutter_usmb_parking/Component/SnackBar.dart';
import 'package:flutter_usmb_parking/functions/server_request.dart';
import 'package:flutter_usmb_parking/functions/settingRoad.dart';
import 'package:flutter_usmb_parking/pageParking.dart';
import 'package:flutter_usmb_parking/src/alertButtonComponant.dart';
import 'package:flutter_usmb_parking/variables/globalVariables.dart';
import 'package:geolocator/geolocator.dart';

class SampleNavigationApp extends StatefulWidget {
  const SampleNavigationApp({super.key});

  @override
  State<SampleNavigationApp> createState() => _SampleNavigationAppState();
}

class _SampleNavigationAppState extends State<SampleNavigationApp> {
  String? _platformVersion;
  String? _instruction;

  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    navigationOption.simulateRoute = true;
    navigationOption.voiceInstructionsEnabled = false;
    navigationOption.bannerInstructionsEnabled = true;
    navigationOption.units = VoiceUnits.metric;
    navigationOption.language = "fr-FR";

    //_navigationOption.initialLatitude = 36.1175275;
    //_navigationOption.initia lLongitude = -115.1839524;
    navigation = MapBoxNavigation.instance;
    //MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    navigation.registerRouteEventListener(_onEmbeddedRouteEvent);
    navigationTemp = navigation;
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await MapBoxNavigation.instance.getPlatformVersion();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  final _inputKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        home: Builder(
            builder: (context) => Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.black,
                    title: const Text(
                      'TROUVE TON PARKING',
                      style: TextStyle(color: Colors.white),
                    ),
                    actions: <Widget>[
                      IconButton(
                        color: Colors.white,
                        icon: const Icon(
                            Icons.list), // Remplacez-le par l'icône souhaitée
                        onPressed: () {
                          debugPrint("VAMOS");

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ParkingListPage(),
                          ));
                        },
                      ),
                    ],
                    centerTitle: true),
                body: Form(
                    key: _inputKey,
                    child: Stack(
                      children: [
                        Center(
                          child: MapBoxNavigationView(
                            options: navigationOption,
                            onRouteEvent: _onEmbeddedRouteEvent,
                            onCreated: (MapBoxNavigationViewController
                                controller2) async {
                              controller = controller2;
                              controller?.initialize();
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 64,
                          right: 16,
                          child: Visibility(
                            visible: !_routeBuilt,
                            child: Container(
                              width: 72, // Largeur du conteneur
                              height: 72, // Hauteur du conteneur
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors
                                    .black, // Couleur de fond du conteneur
                                border: Border.all(
                                    color: Colors.grey), // Bordure grise
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add_road,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                                onPressed: !_routeBuilt && !_isNavigating
                                    ? () async {
                                        await findAParking();
                                        var wayPoints = <WayPoint>[];
                                        wayPoints.add(maPos);
                                        wayPoints.add(monParking);
                                        _routeBuilt = true;
                                        timer = Timer(Duration(seconds: 5),
                                            () async {
                                          await navigation.startNavigation(
                                              wayPoints: wayPoints);
                                        });

                                        // Hide the entire container after the button is pressed
                                        setState(() {
                                          _routeBuilt = true;
                                        });

                                        if (_inputKey.currentState!
                                            .validate()) {
                                          _messangerKey.currentState!
                                              .showSnackBar(
                                                  routeSnackbar(_messangerKey));
                                        }
                                      }
                                    : null,
                                splashRadius: 60.0,
                                tooltip: 'Trouve un Parking !',
                                color:
                                    Colors.black, // Couleur de fond du bouton
                                hoverColor: Colors.grey,
                                highlightColor: Colors
                                    .grey, // Couleur lorsque le bouton est enfoncé
                                disabledColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )))));
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }

        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 4));
          debugPrint("HERE111111111");
          navigation.finishNavigation();

          //controller?.clearRoute();
          if (_inputKey.currentState!.validate()) {
            _messangerKey.currentState!
                .showSnackBar(findParkingSnackbar(_messangerKey, _inputKey));
          }
          navigation = navigationTemp;
          setState(() {
            _routeBuilt = false;
            _isNavigating = false;
          });
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
        break;
      case MapBoxEvent.navigation_cancelled:
        controller?.clearRoute();
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}
