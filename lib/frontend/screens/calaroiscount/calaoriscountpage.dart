import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:calaroiscount/frontend/screens/calaroiscount/MailItem.dart';
import 'package:calaroiscount/frontend/screens/calaroiscount/WeeklyCalendar.dart';
import 'package:calaroiscount/frontend/screens/calaroiscount/apppar.dart';
import 'package:calaroiscount/frontend/screens/calaroiscount/calaorisCountContaner.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllNutritionData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("users_nutrition")
          .orderBy("timestamp", descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllTakenValuesData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("nutrition_history")
          .orderBy("timestamp", descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  double parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getAllNutritionData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("حدث خطأ في تحميل البيانات"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("لا توجد بيانات غذائية متاحة"));
          }

          // جمع القيم الغذائية
          double totalCalories = 0.0;
          double totalProtein = 0.0;
          double totalFats = 0.0;
          double totalCarbs = 0.0;

          for (var doc in snapshot.data!.docs) {
            var data = doc.data();
            totalCalories += parseDouble(data['calories']);
            totalProtein += parseDouble(data['protein']);
            totalFats += parseDouble(data['fats']);
            totalCarbs += parseDouble(data['carbs']);
          }

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getAllTakenValuesData(),
            builder: (context, takenSnapshot) {
              if (takenSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (takenSnapshot.hasError) {
                return const Center(
                    child: Text("حدث خطأ في تحميل بيانات القيم المأخوذة"));
              }

              if (!takenSnapshot.hasData || takenSnapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text("لا توجد بيانات للقيم المأخوذة"));
              }

              // جمع القيم المأخوذة
              double totalTakenProtein = 0.0;
              double totalTakenFats = 0.0;
              double totalTakenCarbs = 0.0;

              for (var doc in takenSnapshot.data!.docs) {
                var takenData = doc.data();
                totalTakenProtein += parseDouble(takenData['Protein']);
                totalTakenFats += parseDouble(takenData['Fat']);
                totalTakenCarbs += parseDouble(takenData['Carbohydrates']);
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomePageAppPar(),
                    SizedBox(height: screenHeight * 0.03),
                    CaloriesChart(
                      carbs: totalCarbs,
                      protein: totalProtein,
                      fats: totalFats,
                      use_protein: totalTakenProtein,
                      use_fats: totalTakenFats,
                      use_carbs: totalTakenCarbs,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    const WeeklyCalendar(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
