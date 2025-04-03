import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid}) {
    if (uid.isEmpty) {
      throw ArgumentError('UID cannot be empty');
    }
  }

  // Get formatted date for collections
  String get formattedDate {
    final date = DateTime.now();
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    if (formatted.isEmpty) {
      throw ArgumentError('Formatted date is empty');
    }
    return formatted;
  }

  // collection reference
  final CollectionReference myCollection =
      FirebaseFirestore.instance.collection('userdata');

  Future<void> updateUserData(
      String name, String username, String email, String type) async {
    if (uid.isEmpty) throw ArgumentError('UID is empty');
    return await myCollection.doc(uid).set({
      'name': name,
      'username': username,
      'email': email,
      'type': type,
    });
  }

  Future<void> updateDoctorUserData(
    String name,
    String username,
    String email,
    String specialization,
    String hospital,
    String phone,
    String about,
    String type,
  ) async {
    if (uid.isEmpty) throw ArgumentError('UID is empty');
    return await myCollection.doc(uid).set({
      'name': name,
      'username': username,
      'email': email,
      'specialization': specialization,
      'hospital': hospital,
      'phone': phone,
      'about': about,
      'type': type,
    });
  }

  // Food total data methods
  CollectionReference get foodTotalData {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('food_track')
        .doc(formattedDate)
        .collection('Total');
  }

  Future<void> updateTotalFoodData(
      String typeOfFood,
      String calories,
      String carbo,
      String protein,
      String fat,
      String sugars,
      String cholesterol) async {
    if (typeOfFood.isEmpty) throw ArgumentError('Type of Food is empty');
    return await foodTotalData.doc(typeOfFood).set({
      'Total Calories': calories,
      'Total Carbohydrate': carbo,
      'Total Protein': protein,
      'Total Fat': fat,
      'Total Sugars': sugars,
      'Total Cholesterol': cholesterol,
    });
  }

  // Food goal methods
  CollectionReference get foodSetGoal {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('food_track')
        .doc(formattedDate)
        .collection('Target');
  }

  Future<void> updateSetGoalData(String mealType, String calories, String carbo,
      String protein, String fat, String sugars, String cholesterol) async {
    // Check if mealType is not empty
    if (mealType.isEmpty) {
      throw ArgumentError('Meal Type cannot be empty');
    }

    return await foodSetGoal.doc(mealType).set({
      'Target Calories': calories,
      'Target Carbohydrate': carbo,
      'Target Protein': protein,
      'Target Fat': fat,
      'Target Sugars': sugars,
      'Target Cholesterol': cholesterol,
    });
  }

  // Breakfast data methods
  CollectionReference get foodCollectionBreakfast {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('food_track')
        .doc(formattedDate)
        .collection('breakfast');
  }

  Future<void> updateFoodDataBreakfast(
      String foodName,
      String calories,
      String carbo,
      String protein,
      String fat,
      String sugars,
      String cholesterol,
      String servings) async {
    if (foodName.isEmpty) throw ArgumentError('Food Name is empty');
    return await foodCollectionBreakfast.doc(foodName).set({
      foodName: {
        'Total Calories': calories,
        'Carbohydrate': carbo,
        'Protein': protein,
        'Fat': fat,
        'Servings': servings,
        'Sugars': sugars,
        'Cholesterol': cholesterol,
      }
    });
  }

  // Water tracking methods
  CollectionReference get waterCollection {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('water_track');
  }

  Future<void> updateWaterData(
      double glasses, double target, String lastSeen, String time) async {
    if (formattedDate.isEmpty) throw ArgumentError('Formatted date is empty');
    return await waterCollection.doc(formattedDate).set({
      'consumed(ml)': glasses,
      'target(ml)': target,
      'last seen': lastSeen,
      'time': time,
    });
  }

  // Food total collection
  CollectionReference get foodCollectionTotal {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('food_track');
  }

  Future<void> updateFoodDataTotal(
      int carbohydrate, int protein, int fat) async {
    return await foodCollectionTotal.doc(formattedDate).set({
      'Total Carbohydrate': carbohydrate,
      'Total Protein': protein,
      'Total Fat': fat,
    });
  }

  // Lunch data methods
  CollectionReference get foodCollectionLunch {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('food_track')
        .doc(formattedDate)
        .collection('lunch');
  }

  Future<void> updateFoodDataLunch(
      String foodName,
      String calories,
      String carbo,
      String protein,
      String fat,
      String sugars,
      String cholesterol,
      String servings) async {
    if (foodName.isEmpty) throw ArgumentError('Food Name is empty');
    return await foodCollectionLunch.doc(foodName).set({
      foodName: {
        'Total Calories': calories,
        'Carbohydrate': carbo,
        'Protein': protein,
        'Fat': fat,
        'Servings': servings,
        'Sugars': sugars,
        'Cholesterol': cholesterol,
      }
    });
  }

  // Snack data methods
  CollectionReference get foodCollectionSnack {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('food_track')
        .doc(formattedDate)
        .collection('snack');
  }

  Future<void> updateFoodDataSnack(
      String foodName,
      String calories,
      String carbo,
      String protein,
      String fat,
      String sugars,
      String cholesterol,
      String servings) async {
    if (foodName.isEmpty) throw ArgumentError('Food Name is empty');
    return await foodCollectionSnack.doc(foodName).set({
      foodName: {
        'Total Calories': calories,
        'Carbohydrate': carbo,
        'Protein': protein,
        'Fat': fat,
        'Servings': servings,
        'Sugars': sugars,
        'Cholesterol': cholesterol,
      }
    });
  }

  // Dinner data methods
  CollectionReference get foodCollectionDinner {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('food_track')
        .doc(formattedDate)
        .collection('dinner');
  }

  Future<void> updateFoodDataDinner(
      String foodName,
      String calories,
      String carbo,
      String protein,
      String fat,
      String sugars,
      String cholesterol,
      String servings) async {
    if (foodName.isEmpty) throw ArgumentError('Food Name is empty');
    return await foodCollectionDinner.doc(foodName).set({
      foodName: {
        'Total Calories': calories,
        'Carbohydrate': carbo,
        'Protein': protein,
        'Fat': fat,
        'Servings': servings,
        'Sugars': sugars,
        'Cholesterol': cholesterol,
      }
    });
  }

  // Body measurement methods
  CollectionReference get bodyCollection {
    if (uid.isEmpty || formattedDate.isEmpty) {
      throw ArgumentError('UID or Date is empty');
    }
    return FirebaseFirestore.instance
        .collection('userdata')
        .doc(uid)
        .collection('body_track');
  }

  Future<void> updateBodyMeasurementData(
      int height,
      int weight,
      double bMR,
      double bMI,
      String status,
      String lastSeen,
      String age,
      String gender) async {
    return await bodyCollection.doc(formattedDate).set({
      'height(cm)': height,
      'weight(kg)': weight,
      'BMR(Body Metabolic Rate)': bMR,
      'BMI(Body Mass Index)': bMI, // Fixed from BMW to BMI
      'BMI status': status, // Fixed from BMW status to BMI status
      'last seen': lastSeen,
      'age': age,
      'gender': gender
    });
  }
}
