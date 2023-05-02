import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medihelp/nearbyResponse.dart';

class nearbyPharmacy extends StatefulWidget {
  const nearbyPharmacy({Key? key}) : super(key: key);

  @override
  State<nearbyPharmacy> createState() => _nearbyPharmacyState();
}

class _nearbyPharmacyState extends State<nearbyPharmacy> {
  String apiKey = "AIzaSyAhV7ohUdwa8MW_Fm2V2JvOErZuj7Mq2kA", radius = "30";
  double latitude = 31.08546, longitude = 129.09865;
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('nearby places'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                getNearbyPlaces();
              },
              child: const Text("nearby places"),
            ),
            if (nearbyPlacesResponse.results != null)
              for (int i = 0; i < nearbyPlacesResponse.results!.length; i++)
                nearbyPlacesWidget(nearbyPlacesResponse.results![i])
          ], //children
        ),
      ),
    );
  }

  void getNearbyPlaces() async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&key=$apiKey');
    var response = await http.post(url);
    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    print(nearbyPlacesResponse);
    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text("Name :${results.name!}"),
        Text(
            "Location :${results.geometry!.location!.lat} , ${results.geometry!.location!.lng}"),
        Text(results.openingHours != null ? "Open" : "Closed"),
      ]),
    );
  }
}
