import 'package:calaroiscount/frontend/widgets/bottompar.dart';
import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  String activityLevel = "Low";
  String gender = "Male";
  double calories = 0;
  double protein = 0;
  double carbs = 0;
  double fats = 0;

  void calculateNeeds() {
    double weight = double.tryParse(weightController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;
    int age = int.tryParse(ageController.text) ?? 0;

    if (weight == 0 || height == 0 || age == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid data")),
      );
      return;
    }

    double bmr = gender == "Male"
        ? (10 * weight + 6.25 * height - 5 * age + 5)
        : (10 * weight + 6.25 * height - 5 * age - 161);

    double activityMultiplier = activityLevel == "Low"
        ? 1.2
        : (activityLevel == "Moderate" ? 1.55 : 1.9);

    setState(() {
      calories = bmr * activityMultiplier;
      protein = weight * 2;
      fats = weight * 0.8;
      double proteinCalories = protein * 4;
      double fatCalories = fats * 9;
      carbs = (calories - (proteinCalories + fatCalories)) / 4;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your Daily Needs",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("💪 Calories: ${calories.toStringAsFixed(0)} kcal"),
            Text("🍗 Protein: ${protein.toStringAsFixed(1)} g"),
            Text("🥑 Fats: ${fats.toStringAsFixed(1)} g"),
            Text("🍞 Carbohydrates: ${carbs.toStringAsFixed(1)} g"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomeNavigationBar(),
                )),
            child: Text("OK"),
          ),
        ],
      ),
    );

    saveDataToFirestore();
  }

  Future<void> saveDataToFirestore() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      DocumentReference nutritionRef = FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("users_nutrition")
          .doc();

      await nutritionRef.set({
        "height": heightController.text,
        "weight": weightController.text,
        "age": ageController.text,
        "gender": gender,
        "activityLevel": activityLevel,
        "calories": calories.toStringAsFixed(0),
        "protein": protein.toStringAsFixed(1),
        "fats": fats.toStringAsFixed(1),
        "carbs": carbs.toStringAsFixed(1),
        "timestamp": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Your Health Data",
            style: TextStyle(color: Colors.black)),
        backgroundColor: kapp,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Height (cm)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              buildTextField("Enter your Height (cm)", heightController),
              Text(
                "Weight (kg)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              buildTextField("Enter your Weight (kg)", weightController),
              Text(
                "Age",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              buildTextField("Age", ageController),
              buildDropdown("Gender", gender, ["Male", "Female"], (value) {
                setState(() => gender = value!);
              }),
              buildDropdown(
                  "Activity Level", activityLevel, ["Low", "Moderate", "High"],
                  (value) {
                setState(() => activityLevel = value!);
              }),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: calculateNeeds,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildDropdown(String label, String value, List<String> items,
    Function(String?) onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0), // زوايا مستديرة
              borderSide: BorderSide(color: Colors.grey), // لون الحدود
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  BorderSide(color: Colors.grey), // لون الحدود عند عدم التركيز
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                  color: Colors.blue, width: 2.0), // لون الحدود عند التركيز
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

Widget buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), // زوايا مستديرة
          borderSide: BorderSide(color: Colors.grey), // لون الحدود
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              BorderSide(color: Colors.grey), // لون الحدود عندما يكون غير مفعل
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
              color: Colors.blue, width: 2.0), // لون الحدود عند التركيز
        ),
      ),
    ),
  );
}
