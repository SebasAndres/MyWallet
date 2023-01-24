import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String name;
  late String key;

  late Map<String, double> spent_map; // mapa de egresos

  void load_data (Map<String, double> category_data) {
    spent_map = category_data;
    // spent_map = new Map<String, double>.from(category_data);
    // for (var key in category_data.keys) {
    //   spent_map[key] = double.parse(category_data[key].toDouble());
    // }
  }
}