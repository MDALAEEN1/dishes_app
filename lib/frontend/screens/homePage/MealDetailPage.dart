import 'package:cached_network_image/cached_network_image.dart';
import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MealDetailPage extends StatelessWidget {
  final String title;
  final String image;
  final String price;
  final dynamic nutrition;
  final List<dynamic> ingredients;
  final String instructions;

  const MealDetailPage({
    super.key,
    required this.title,
    required this.image,
    required this.price,
    required this.nutrition,
    required this.ingredients,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await _saveNutritionToFirebase(context);
        },
        label: const Text(
          "Save Nutrition",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kapp,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              floating: false,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    "assets/images/carbohydrate.png",
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/carbohydrate.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Price
                Text(
                  "Price: $price",
                  style: const TextStyle(color: Colors.green, fontSize: 17),
                ),
                const SizedBox(height: 16),

                // Nutrition Values
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    NutritionItem(
                      label: "Carbs",
                      value: nutrition["Carbohydrates"] ?? "N/A",
                      icon: "assets/images/carbohydrate.png",
                    ),
                    NutritionItem(
                      label: "Protein",
                      value: nutrition["Protein"] ?? "N/A",
                      icon: "assets/images/food.png",
                    ),
                    NutritionItem(
                      label: "Fat",
                      value: nutrition["Fat"] ?? "N/A",
                      icon: "assets/images/pizza-slice.png",
                    ),
                    NutritionItem(
                      label: "Calories",
                      value: nutrition["calories"] ?? "N/A",
                      icon: "assets/images/calories.png",
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Ingredients
                const Text(
                  "Ingredients",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    final item = ingredients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 8, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item["originalString"] ??
                                  item["original"] ??
                                  "No ingredient",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Instructions
                const Text(
                  "Preparation",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  instructions.isNotEmpty
                      ? instructions
                      : "No instructions available",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Save Nutrition Data to Firebase
  Future<void> _saveNutritionToFirebase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must be logged in to save nutrition data!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final nutritionData = {
      "Carbohydrates": nutrition["Carbohydrates"] ?? "N/A",
      "Protein": nutrition["Protein"] ?? "N/A",
      "Fat": nutrition["Fat"] ?? "N/A",
      "Calories": nutrition["calories"] ?? "N/A",
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("nutrition_history")
          .add(nutritionData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nutrition data saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save nutrition data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Reusable Nutrition Item Widget
class NutritionItem extends StatelessWidget {
  final String label;
  final dynamic value;
  final String icon;

  const NutritionItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(icon, width: 24, height: 24),
        const SizedBox(height: 4),
        Text(
          "$value",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }
}
