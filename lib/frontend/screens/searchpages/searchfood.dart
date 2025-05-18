import 'dart:convert';
import 'package:calaroiscount/frontend/screens/searchpages/mealdetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodSearchPage extends StatefulWidget {
  @override
  _FoodSearchPageState createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  final String apiKey =
      'd158d3191c3c43ceb843a9f8a5c8ec02'; // استبدل بمفتاح API الخاص بك
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();

  Future<void> searchFood(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/food/products/search?query=$query&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body)['products'];
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("بحث عن الأطعمة")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "ابحث عن الطعام",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchFood(searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                var item = searchResults[index];
                String imageUrl = item['image'] ?? '';

                return ListTile(
                  title: Text(item['title']),
                  leading: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.fastfood,
                                size: 50, color: Colors.grey);
                          },
                        )
                      : Icon(Icons.fastfood, size: 50, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailsPage(id: item['id']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
