import 'package:flutter/material.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meals")),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_getMealName(index)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  _getTargetData(index);
                  return Dinner(callingText: _getMealName(index));
                },
              ));
            },
          );
        },
      ),
    );
  }

  void _getTargetData(int index) {
    switch (index) {
      case 0:
        print("Fetching breakfast data");
        break;
      case 1:
        print("Fetching lunch data");
        break;
      case 2:
        print("Fetching snack data");
        break;
      case 3:
        print("Fetching dinner data");
        break;
    }
  }

  String _getMealName(int index) {
    switch (index) {
      case 0:
        return "Breakfast";
      case 1:
        return "Lunch";
      case 2:
        return "Snack";
      case 3:
        return "Dinner";
      default:
        return "Dinner";
    }
  }
}

class Dinner extends StatelessWidget {
  final String callingText;
  const Dinner({super.key, required this.callingText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Details")),
      body: Center(
        child: Text("Selected Meal: $callingText",
            style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MealsScreen(),
  ));
}
