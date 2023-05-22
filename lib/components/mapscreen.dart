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
import 'package:medihelp/services/mapservices.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(18.520430, 73.856743),
    zoom: 11.5,
  );
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  Set<Marker> _markersDupe = Set<Marker>();

  Timer? _debounce;
  int markerIdCounter = 1;
  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;
  var radiusValue = 3000.0;
  var tappedPoint;
  List allFavoritePlaces = [];

  String tokenKey = '';

  Set<Circle> _circles = Set<Circle>();

  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('christine'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Colors.blue,
          strokeWidth: 1));
      getDirections = false;
      searchToggle = false;
      radiusSlider = true;
    });
  }

  _setNearMarker(LatLng point, String label, List types, String status) async {
    var counter = markerIdCounter++;
    final Uint8List markerIcon;
    if (types.contains('restaurants'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 75);
    else if (types.contains('food'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 75);
    else if (types.contains('school'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 75);
    else if (types.contains('bar'))
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 75);
    else if (types.contains('lodging')) {
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 75);
    } else if (types.contains('store')) {
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 75);
    } else if (types.contains('locality')) {
      markerIcon =
          await getBytesFromAsset('assets/mapicons/health-medical.png', 75);
    } else {
      markerIcon = await getBytesFromAsset('assets/mapicons/places.png', 75);
    }

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.fromBytes(markerIcon));

    setState(() {
      _markers.add(marker);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: _initialCameraPosition,
              mapType: MapType.normal,
              circles: _circles,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (point) {
                tappedPoint = point;
                _setCircle(point);
              },
            ),
            radiusSlider
                ? Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 0.0),
                    child: Container(
                      height: 50.0,
                      color: Colors.black.withOpacity(0.3),
                      child: Row(
                        children: [
                          Expanded(
                              child: Slider(
                            value: radiusValue,
                            onChanged: (newValue) {
                              radiusValue = newValue;
                              pressedNear = false;
                              _setCircle(tappedPoint);
                            },
                            max: 7000.0,
                            min: 1000.0,
                          )),
                          !pressedNear
                              ? IconButton(
                                  onPressed: () {
                                    if (_debounce?.isActive ?? false)
                                      _debounce?.cancel();
                                    _debounce =
                                        Timer(Duration(seconds: 2), () async {
                                      var placesResult = await MapServices()
                                          .getPlaceDetails(
                                              tappedPoint, radiusValue.toInt());

                                      List<dynamic> placesWithin =
                                          placesResult['results'] as List;

                                      allFavoritePlaces = placesWithin;

                                      tokenKey =
                                          placesResult['next_page_token'] ??
                                              'none';
                                      _markers = {};
                                      placesWithin.forEach((element) {
                                        _setNearMarker(
                                          LatLng(
                                              element['geometry']['location']
                                                  ['lat'],
                                              element['geometry']['location']
                                                  ['lng']),
                                          element['name'],
                                          element['types'],
                                          element['business_status'] ??
                                              'not available',
                                        );
                                      });
                                      _markersDupe = _markers;
                                      pressedNear = true;
                                    });
                                  },
                                  icon:
                                      Icon(Icons.near_me, color: Colors.white),
                                )
                              : IconButton(
                                  onPressed: () {
                                    if (_debounce?.isActive ?? false)
                                      _debounce?.cancel();
                                    _debounce =
                                        Timer(Duration(seconds: 2), () async {
                                      if (tokenKey != 'none') {
                                        var placesResult = await MapServices()
                                            .getMorePlaceDetails(tokenKey);
                                        List<dynamic> placesWithin =
                                            placesResult['results'] as List;

                                        allFavoritePlaces.addAll(placesWithin);
                                        tokenKey =
                                            placesResult['next_page_token'] ??
                                                'none';
                                        placesWithin.forEach((element) {
                                          _setNearMarker(
                                            LatLng(
                                                element['geometry']['location']
                                                    ['lat'],
                                                element['geometry']['location']
                                                    ['lng']),
                                            element['name'],
                                            element['types'],
                                            element['business_status'] ??
                                                'not available',
                                          );
                                        });
                                      } else {
                                        print('no more places');
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.more),
                                ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: Colors.blue,
          fabOpenColor: Colors.red.shade100,
          ringDiameter: 250.0,
          ringWidth: 60.0,
          ringColor: Colors.blue,
          fabSize: 60.0,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.navigation),
              onPressed: () {
                setState(() {
                  searchToggle = false;
                  radiusSlider = false;
                  pressedNear = false;
                  cardTapped = false;
                  getDirections = true;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  searchToggle = true;
                  radiusSlider = false;
                  pressedNear = false;
                  cardTapped = false;
                  getDirections = false;
                });
              },
            ),
          ],
        ));
  }
}
