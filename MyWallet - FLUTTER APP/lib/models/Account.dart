class Account {

  late String nombre;

  late String tipo;
  late double saldo;

  late String cierre;
  late String vencimiento;

  Account (Map<String, dynamic> snapshot) {
    this.nombre = snapshot["nombre"];
    this.saldo = double.parse(snapshot["Saldo"]);
    this.tipo = snapshot["tipo"];

    if (this.tipo == "credito") {
      this.cierre = snapshot["Ciere"];
      this.vencimiento = snapshot["Vencimiento"];
    }
  }

}