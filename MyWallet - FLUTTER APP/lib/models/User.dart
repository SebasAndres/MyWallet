import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  late String nombre;
  late Map<String, double> categorias_map = {};
  late List<String> categorias;
  late List<String> cuentas;
  late String foto;
  late String psw;
  late String nivel_gasto;
  late String ult_op;

  User (Map<String, dynamic> snapshot) {
    this.nombre = snapshot["nombre"];
    this.psw = snapshot["psw"];
    this.nivel_gasto = snapshot["nivel_gasto"];

    DateTime date = DateTime.parse(snapshot["ult_op"].toString());
    Timestamp timestamp_ult_op = Timestamp.fromDate(date);
    this.ult_op = timeago.format(timestamp_ult_op.toDate());

    Map<String,dynamic> temp_cats = Map.from(snapshot["pie_chart"]);
    for (String key in temp_cats.keys){
      categorias_map[key] = double.parse(temp_cats[key].toString());
    }
    this.categorias = List.from(categorias_map.keys);
    this.cuentas = List.from(snapshot["cuentas"]);
    this.foto = snapshot["foto"];
  }

  Map<String, double> EgresosMap () {
    Map<String, double> egresos_map = {};
    for (String key in this.categorias_map.keys) {
      if (this.categorias_map[key]! < 0.0) {
        egresos_map[key] = this.categorias_map[key]!;
      }
    }
    return egresos_map;
   }
}