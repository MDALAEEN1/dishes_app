import 'package:flutter/material.dart';

class RecipeDetailsPage extends StatelessWidget {
  final dynamic recipe;

  RecipeDetailsPage({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ الصورة كخلفية
            if (recipe['image'] != null)
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30)),
                child: Image.network(
                  recipe['image'],
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            // ✅ المحتوى القابل للتمرير
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ اسم الوصفة
                  Text(
                    recipe['title'] ?? "Recipe Details",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(height: 16),

                  // ✅ السعر لكل وجبة
                  Text(
                    "Price per serving: ${(recipe.containsKey('pricePerServing') && recipe['pricePerServing'] != null) ? recipe['pricePerServing'].toStringAsFixed(2) : "N/A"} Dirham",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  // ✅ عرض المقادير (المكونات)
                  if (recipe.containsKey('extendedIngredients') &&
                      recipe['extendedIngredients'] != null &&
                      recipe['extendedIngredients'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ingredients:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        ...recipe['extendedIngredients']
                            .map<Widget>(
                              (ingredient) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                    "- ${ingredient['original'] ?? 'Unknown'}",
                                    style: TextStyle(fontSize: 16)),
                              ),
                            )
                            .toList(),
                      ],
                    )
                  else
                    Text("❌ No ingredients available.",
                        style: TextStyle(fontSize: 16, color: Colors.red)),

                  SizedBox(height: 16),

                  // ✅ عرض القيم الغذائية بشكل منفصل
                  if (recipe.containsKey('nutrition') &&
                      recipe['nutrition'] != null &&
                      recipe['nutrition']['nutrients'] != null &&
                      recipe['nutrition']['nutrients'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nutritional Information:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),

                        // ✅ استخراج القيم الغذائية المهمة
                        _buildNutrientRow(
                            "Calories", recipe['nutrition']['nutrients']),
                        _buildNutrientRow(
                            "Protein", recipe['nutrition']['nutrients']),
                        _buildNutrientRow(
                            "Carbohydrates", recipe['nutrition']['nutrients']),
                        _buildNutrientRow(
                            "Fat", recipe['nutrition']['nutrients']),
                        _buildNutrientRow(
                            "Sugar", recipe['nutrition']['nutrients']),
                      ],
                    )
                  else
                    Text("❌ No nutritional data available.",
                        style: TextStyle(fontSize: 16, color: Colors.red)),

                  SizedBox(height: 16),

                  // ✅ عرض التعليمات
                  if (recipe.containsKey('instructions') &&
                      recipe['instructions'] != null &&
                      recipe['instructions'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Instructions:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(recipe['instructions'],
                            style: TextStyle(fontSize: 16)),
                      ],
                    )
                  else
                    Text("❌ No instructions available.",
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ وظيفة لاستخراج القيم الغذائية المهمة
  Widget _buildNutrientRow(String nutrientName, List<dynamic> nutrients) {
    var nutrient = nutrients.firstWhere(
      (n) => n['name'].toString().toLowerCase() == nutrientName.toLowerCase(),
      orElse: () => null,
    );

    return nutrient != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(nutrientName,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                Text("${nutrient['amount']} ${nutrient['unit']}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        : SizedBox(); // ✅ إذا لم تكن القيمة موجودة، لا نعرض أي شيء
  }
}
