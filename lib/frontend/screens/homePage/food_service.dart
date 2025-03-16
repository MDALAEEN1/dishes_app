import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class FoodService {
  static const String apiKey = "8c90976c3e6842bf94d40ae283573ece";
  static const String apiUrl =
      "https://api.spoonacular.com/recipes/complexSearch";
  static const String recipeInfoUrl = "https://api.spoonacular.com/recipes";

  // جلب الوصفات حسب نوع الوجبة (Breakfast, Lunch, Dinner)
  static Future<List<dynamic>> fetchRecipes(String mealType) async {
    try {
      // إنشاء قيمة offset عشوائية
      final random = Random();
      final offset = random.nextInt(100); // على افتراض أن هناك 100 وصفة متوفرة

      final url =
          "$apiUrl?query=$mealType&number=6&offset=$offset&sort=random&addRecipeInformation=true&apiKey=$apiKey";
      print("Fetching: $url");

      final response = await http.get(Uri.parse(url));

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data["results"] ?? [];

        // تحويل البيانات لتشمل السعر بالدولار
        return results.map((recipe) {
          final priceInCents = recipe["pricePerServing"] ?? 0;
          final priceInDollars = (priceInCents / 100).toStringAsFixed(2);
          return {
            "title": recipe["title"],
            "image": recipe["image"],
            "price": priceInDollars,
            "id": recipe["id"], // إضافة ID للوصفة
          };
        }).toList();
      } else {
        return [];
      }
    } catch (error) {
      print("Error fetching recipes: $error");
      return [];
    }
  }

  // جلب تفاصيل الوصفة بالكامل باستخدام ID
  static Future<Map<String, dynamic>> fetchRecipeDetails(int recipeId) async {
    try {
      final url =
          "$recipeInfoUrl/$recipeId/information?apiKey=$apiKey&includeNutrition=true";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // استخراج القيم الغذائية
        final nutrition = data["nutrition"] ?? {};
        final nutrients = nutrition["nutrients"] ?? [];

        // دالة مساعدة للحصول على القيم الغذائية
        double getNutrientValue(String name) {
          return (nutrients.firstWhere(
                    (n) => n["name"] == name,
                    orElse: () => {"amount": 0},
                  )["amount"] ??
                  0)
              .toDouble();
        }

        return {
          "title": data["title"],
          "image": data["image"],
          "protein": getNutrientValue("Protein"), // البروتين
          "carbs": getNutrientValue("Carbohydrates"), // الكربوهيدرات
          "fat": getNutrientValue("Fat"), // الدهون
          "calories": getNutrientValue("Calories"), // السعرات الحرارية ✅
          "price": ((data["pricePerServing"] ?? 0) / 100).toStringAsFixed(2),
          "ingredients": data["extendedIngredients"] ?? [],
          "instructions": data["instructions"] ?? "No instructions available",
        };
      }
    } catch (error) {
      print("Error fetching recipe details: $error");
    }
    return {};
  }
}
