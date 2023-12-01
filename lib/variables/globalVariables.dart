import 'dart:async';
import 'dart:ui';

import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

WayPoint monParking =
    WayPoint(name: "name", latitude: 0.0, longitude: 0.0, isSilent: false);

WayPoint maPos =
    WayPoint(name: "name", latitude: 0.0, longitude: 0.0, isSilent: false);
MapBoxNavigationViewController? controller;
late MapBoxNavigation navigation;
late MapBoxNavigation navigationTemp;

late MapBoxOptions navigationOption;
late Timer timer;
