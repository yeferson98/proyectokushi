class ProductPayment {
  String cantidadPoducto;
  String precioProducto;
  String montoTotal;
  String codigoProducto;
  String talla;
  String color;
  String image;
  ProductPayment(
      {this.cantidadPoducto,
      this.precioProducto,
      this.montoTotal,
      this.codigoProducto,
      this.talla,
      this.color,
      this.image});
  // ignore: non_constant_identifier_names
  Map<String, dynamic> TojsonData() {
    var map = new Map<String, dynamic>();
    map["Dco_Cantidad"] = cantidadPoducto;
    map["Dco_Precio"] = precioProducto;
    map["Dco_Totaldet"] = montoTotal;
    map["Prod_Codigo"] = codigoProducto;
    map["Tpr_Codigo"] = talla;
    map["Pco_Codigo"] = color;
    map["Prod_Imagen_Detalle"] = image;
    return map;
  }
}
