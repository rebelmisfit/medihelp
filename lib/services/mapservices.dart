import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:ui' as ui;
import 'package:medihelp/constants.dart';
import 'package:medihelp/screens/home.dart';
import 'package:medihelp/components/mapscreen.dart';

class MapServices {
  final String key = '<AIzaSyDLxYuRQS-DO9Ufo0yLRGrFTbTOxc1Nm9o>';
  final String types = 'geocode';

  Future<dynamic> getPlaceDetails(LatLng coords, int radius) async {
    var lat = coords.latitude;
    var lng = coords.longitude;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=$lat,$lng&radius=$radius&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }

  Future<dynamic> getMorePlaceDetails(String token) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?&pagetoken=$token&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    return json;
  }
}
