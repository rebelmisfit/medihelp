import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  // Replace 'YOUR_API_KEY' with your SerpApi API key
  final apiKey =
      'd66c2c8200f55eebaa5b71cb93ff4139612e2e3729d6d539c36600e5dbcdb7c7';
  final query = 'Why is Bendaryl used 1mg';

  // Construct the API request URL
  final apiUrl =
      'https://serpapi.com/search?engine=google&q=$query&apiKey=$apiKey';

  try {
    // Make the API request
    final response = await http.get(Uri.parse(apiUrl));

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);

      // Access the search results data as per the SerpApi response structure
      // Here, you can extract and use the information you need
      print(data['organic_results']);
    } else {
      // Handle the error if the request was not successful
      print('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
  }
}
