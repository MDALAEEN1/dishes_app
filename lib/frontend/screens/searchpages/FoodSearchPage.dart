import 'dart:convert';
import 'package:calaroiscount/frontend/screens/homePage/MealDetailPage.dart';
import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> recipes = [];
  bool isLoading = false;

  static const String apiKey = "53698879a4694c238c8b1dd0a51e1238";
  static const String baseUrl = "https://api.spoonacular.com/recipes/";

  String selectedCuisine = "all";
  int offset = 0;

  Future<void> fetchRecipes(double budget, String query) async {
    setState(() {
      isLoading = true;
      recipes = [];
    });

    String cuisineParam =
        selectedCuisine != "all" ? "&cuisine=$selectedCuisine" : "";
    String queryParam = query.isNotEmpty ? "&query=$query" : "";

    final url = Uri.parse(
        "$baseUrl/complexSearch?number=10&offset=$offset$cuisineParam$queryParam&apiKey=$apiKey");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> results = data['results'];
        List<dynamic> filteredRecipes = [];

        for (var recipe in results) {
          final details = await getRecipeDetails(recipe['id']);

          double price = details['pricePerServing'] != null
              ? details['pricePerServing']
              : double.infinity;

          if (price <= budget) {
            recipe['pricePerServing'] = price;
            recipe['extendedIngredients'] = details['extendedIngredients'];
            recipe['nutrition'] = details['nutrition'];
            recipe['instructions'] = details['instructions'];
            filteredRecipes.add(recipe);
          }
        }

        setState(() {
          recipes = filteredRecipes;
          isLoading = false;
        });

        if (filteredRecipes.isEmpty) {
          offset += 10;
          fetchRecipes(budget, query);
        } else {
          offset += 10;
        }
      } else {
        throw Exception("Failed to load recipes.");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch recipes. Please try again.")),
      );
    }
  }

  Future<Map<String, dynamic>> getRecipeDetails(int recipeId) async {
    final detailsUrl = Uri.parse(
        "$baseUrl$recipeId/information?includeNutrition=true&apiKey=$apiKey");

    try {
      final response = await http.get(detailsUrl);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          'title': data['title'],
          'image': data['image'],
          'pricePerServing': (data['pricePerServing'] ?? 0) / 100.0,
          'extendedIngredients': data['extendedIngredients'] ?? [],
          'nutrition': data['nutrition'] ?? {},
          'instructions': data['instructions'] ?? "No instructions available."
        };
      } else {
        throw Exception("Failed to load recipe details.");
      }
    } catch (e) {
      print("❌ Error fetching recipe details: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kapp,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Budget Input
            Container(
              decoration: BoxDecoration(
                color: kapp,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Search by Recipe Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Enter Budget (\$)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      double? budget = double.tryParse(_budgetController.text);
                      if (budget == null || budget <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Please enter a valid budget.")),
                        );
                      } else {
                        fetchRecipes(budget, _searchController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Recipe List
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : recipes.isEmpty
                      ? Center(child: Text("No recipes found within budget."))
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            final price = recipe['pricePerServing'] != null
                                ? "\$${recipe['pricePerServing'].toStringAsFixed(2)}"
                                : "N/A";

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MealDetailPage(
                                      title: recipe['title'] ?? "No Title",
                                      image: recipe['image'] ?? "",
                                      price: price,
                                      nutrition: {
                                        "Carbohydrates": recipe['nutrition']
                                                ?['nutrients']?[0]?['amount'] ??
                                            "N/A",
                                        "Protein": recipe['nutrition']
                                                ?['nutrients']?[1]?['amount'] ??
                                            "N/A",
                                        "Fat": recipe['nutrition']?['nutrients']
                                                ?[2]?['amount'] ??
                                            "N/A",
                                        "calories": recipe['nutrition']
                                                ?['nutrients']?[3]?['amount'] ??
                                            "N/A",
                                      },
                                      ingredients:
                                          recipe['extendedIngredients'] ?? [],
                                      instructions: recipe['instructions'] ??
                                          "No instructions available",
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: recipe['image'] != null
                                            ? Image.network(
                                                recipe['image'],
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Icon(Icons.fastfood,
                                                      size: 50,
                                                      color: Colors.grey);
                                                },
                                              )
                                            : Icon(Icons.fastfood,
                                                size: 50, color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(recipe['title'] ?? "No Title",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                          SizedBox(height: 4),
                                          Text(price,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.green)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
