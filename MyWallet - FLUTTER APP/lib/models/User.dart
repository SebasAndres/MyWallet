
class User {

  late String nombre;
  late Map<String, double> categorias_map = {};
  late List<String> categorias;
  late List<String> cuentas;
  late String foto;

  User (Map<String, dynamic> snapshot) {
    this.nombre = snapshot["nombre"];
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