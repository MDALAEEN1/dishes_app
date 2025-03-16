import 'package:calaroiscount/frontend/screens/searchpages/FoodSearchPage.dart';
import 'package:flutter/material.dart';

class Mailitem extends StatelessWidget {
  const Mailitem({super.key});

  @override
  Widget build(BuildContext context) {
    return // هنا نعرض الوجبات الأساسية
        Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _buildMealItem(
            context,
            "Add Breakfast",
            "assets/images/tea.png", // استخدام أيقونة الإفطار
            300, // السعرات الحرارية
          ),
          _buildMealItem(
            context,
            "Add Lunch",
            "assets/images/lunch.png", // استخدام أيقونة الغداء
            500, // السعرات الحرارية
          ),
          _buildMealItem(
            context,
            "Add Dinner",
            "assets/images/serve.png", // استخدام أيقونة العشاء
            400, // السعرات الحرارية
          ),
        ],
      ),
    );
  }
}

Widget _buildMealItem(
    BuildContext context, String mealName, String imagePath, int calories) {
  return Container(
    margin: EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 5)),
      ],
    ),
    child: ListTile(
      contentPadding: EdgeInsets.all(10),
      leading: imagePath.isNotEmpty
          ? Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.fastfood, // أيقونة بديلة في حال لم يتم توفير صورة
              size: 50,
              color: Colors.grey,
            ),
      title: Text(
        mealName,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text("$calories kcal"),
      trailing: IconButton(
        icon: const Icon(
          Icons.add_circle,
          color: Colors.black,
          size: 50,
        ),
        onPressed: () {
          // الانتقال إلى صفحة البحث مع إرسال اسم الوجبة كاستعلام
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipePage(),
            ),
          );
        },
      ),
    ),
  );
}
