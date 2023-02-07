class Account {

  late String nombre;

  late String tipo;
  late double saldo;

  late String cierre;
  late String vencimiento;

  Account (Map<String, dynamic> snapshot, String nombre) {
    this.nombre = nombre;
    this.saldo = double.parse(snapshot["Saldo"].toString());
    this.tipo = snapshot["tipo"];

    if (this.tipo == "credito") {
      this.cierre = snapshot["Cierre"];
      this.vencimiento = snapshot["Vencimiento"];
    }
    else {
      this.cierre = "--";
      this.vencimiento = "--";
    }
  }

}