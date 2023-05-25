import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Future<List<dynamic>> searchMedicine(String query) async {
  const String apiKey = 'AIzaSyCjbNpgxY2W2RykjGMb9F2BtPpGCjtE-4M';
  const String searchEngineId = 'e5e7facb7619d4a0f';
  const String baseUrl =
      'https://www.googleapis.com/customsearch/v1?cx=$searchEngineId&key=$apiKey&q= ';

  try {
    final response = await http.get(Uri.parse(baseUrl + query));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];
      return items;
    } else {
      throw Exception('Failed to search for medicine');
    }
  } catch (e) {
    print('Error occurred during search: $e');
    return []; // Return an empty list in case of an error
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  void _performSearch() async {
    String query = _searchController.text;
    try {
      List<dynamic> results = await searchMedicine(query);
      setState(() {
        _searchResults = results;
      });
    } catch (error) {
      // Handle any errors that occur during the search
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Search'),
        backgroundColor: Color(0xFF375AB4),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter medicine name',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
                onPressed: _performSearch,
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF375AB4),
                )),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]['title']),
                    subtitle: Text(_searchResults[index]['snippet']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
