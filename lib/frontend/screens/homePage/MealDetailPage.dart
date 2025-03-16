import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                background: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.food_bank, size: 100),
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
                // العنوان
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // السعر
                Text(
                  "Price: $price",
                  style: const TextStyle(color: Colors.green, fontSize: 17),
                ),
                const SizedBox(height: 16),

                // القيم الغذائية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNutritionItem(
                        "Carbs",
                        nutrition["Carbohydrates"] ?? "N/A",
                        "assets/images/carbohydrate.png"),
                    _buildNutritionItem(
                        "Protein",
                        nutrition["Protein"] ?? "N/A",
                        "assets/images/food.png"),
                    _buildNutritionItem("Fat", nutrition["Fat"] ?? "N/A",
                        "assets/images/pizza-slice.png"),
                    _buildNutritionItem(
                        "Calories",
                        nutrition["calories"] ?? "N/A",
                        "assets/images/calories.png"),
                  ],
                ),

                const SizedBox(height: 20),

                // المكونات
                const Text(
                  "Ingredients",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...ingredients.map((item) => Padding(
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
                    )),
                const SizedBox(height: 20),

                // طريقة التحضير
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

  // عنصر القيم الغذائية
  Widget _buildNutritionItem(String label, dynamic value, String icon) {
    return Column(
      children: [
        Image.asset(icon, width: 24, height: 24), // عرض الأيقونة
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

  // حفظ القيم الغذائية إلى Firebase
  Future<void> _saveNutritionToFirebase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // عرض رسالة إذا لم يكن المستخدم مسجلاً الدخول
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

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("nutrition_history")
        .add(nutritionData);

    // عرض رسالة تأكيد
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Nutrition data saved successfully!"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
