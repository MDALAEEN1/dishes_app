import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FoodDetailsPage extends StatefulWidget {
  final int id;
  FoodDetailsPage({required this.id});

  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  final String apiKey = 'YOUR_API_KEY'; // استبدل بمفتاح API الخاص بك
  Map<String, dynamic>? foodDetails;

  Future<void> fetchFoodDetails() async {
    final response = await http.get(
      Uri.parse(
          'https://api.spoonacular.com/food/products/${widget.id}?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      setState(() {
        foodDetails = json.decode(response.body);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(foodDetails?['title'] ?? "التفاصيل")),
      body: foodDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (foodDetails?['image'] != null &&
                      foodDetails!['image'].isNotEmpty)
                    Image.network(
                      foodDetails!['image'],
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/default_food_image.png',
                            width: 200, height: 200);
                      },
                    )
                  else
                    Image.asset('assets/default_food_image.png',
                        width: 200, height: 200),
                  SizedBox(height: 10),
                  Text(
                    foodDetails?['title'] ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text("السعر: ${foodDetails?['price'] ?? 'غير متوفر'}"),
                  SizedBox(height: 10),
                  Text(
                      "الوصف: ${foodDetails?['description'] ?? 'لا يوجد وصف'}"),
                ],
              ),
            ),
    );
  }
}
