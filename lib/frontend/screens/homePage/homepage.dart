import 'package:calaroiscount/frontend/screens/homePage/MealDetailPage.dart';
import 'package:calaroiscount/frontend/screens/homePage/food_service.dart';
import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:flutter/material.dart';

class FoodAppHome extends StatelessWidget {
  const FoodAppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر
            ClipPath(
              clipper: HeaderClipper(),
              child: Container(
                height: 250,
                color: kapp,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            "Let's have \n  Delicious food",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            image: AssetImage(
                                'assets/images/chefF.png'), // تأكد من إضافة الصورة في مجلد assets
                            height: 200,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // التبويبات
            const TabBar(
              labelColor: Colors.pink,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.pink,
              tabs: [
                Tab(text: "Breakfast"),
                Tab(text: "Lunch"),
                Tab(text: "Dinner"),
                Tab(text: "Drinks"),
              ],
            ),

            // محتوى التبويبات
            Expanded(
              child: TabBarView(
                children: [
                  buildFoodGrid("breakfast"),
                  buildFoodGrid("lunch"),
                  buildFoodGrid("dinner"),
                  buildFoodGrid("drink"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لإنشاء شبكة الطعام باستخدام API
  static Widget buildFoodGrid(String mealType) {
    return FutureBuilder(
      future: FoodService.fetchRecipes(mealType),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            (snapshot.data as List).isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 50),
                SizedBox(height: 10),
                Text(
                  "Data loading failed, try again",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          );
        }

        final recipes = snapshot.data as List;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            itemCount: recipes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final recipe = recipes[index];

              return GestureDetector(
                onTap: () async {
                  // جلب تفاصيل الوصفة بالكامل باستخدام ID
                  final recipeDetails =
                      await FoodService.fetchRecipeDetails(recipe["id"]);

                  // تحويل Set إلى List إذا لزم الأمر
                  final nutrition = recipeDetails["nutrition"] is Set
                      ? (recipeDetails["nutrition"] as Set).toList()
                      : recipeDetails["nutrition"] ?? [];

                  final ingredients = recipeDetails["extendedIngredients"]
                          is Set
                      ? (recipeDetails["extendedIngredients"] as Set).toList()
                      : recipeDetails["extendedIngredients"] ?? [];

                  // الانتقال إلى صفحة التفاصيل
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MealDetailPage(
                        title: recipeDetails["title"] ?? "No Title",
                        image: recipeDetails["image"] ?? "",
                        price: recipeDetails["price"] ?? "0.00",
                        nutrition: {
                          "Protein": recipeDetails["protein"] ?? 0,
                          "Carbohydrates": recipeDetails["carbs"] ?? 0,
                          "Fat": recipeDetails["fat"] ?? 0,
                          "calories": recipeDetails["calories"] ?? 0,
                        },
                        ingredients: recipeDetails["ingredients"] ?? [],
                        instructions: recipeDetails["instructions"] ??
                            "No instructions available",
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                          child: Image.network(
                            recipe["image"] ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              recipe["title"] ?? "No Title",
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${recipe["price"] ?? 'N/A'} \$",
                                  style: const TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// كلاس لعمل التأثير المنحني في الهيدر
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
