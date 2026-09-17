class Producto {
  final String id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String categoria;
  final String marca;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final int stockMinimo;
  final String sucursalId;
  final bool activo;

  const Producto({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.marca,
    required this.precioCompra,
    required this.precioVenta,
    required this.stock,
    required this.stockMinimo,
    required this.sucursalId,
    required this.activo,
  });

  Producto copyWith({
    String? id,
    String? codigo,
    String? nombre,
    String? descripcion,
    String? categoria,
    String? marca,
    double? precioCompra,
    double? precioVenta,
    int? stock,
    int? stockMinimo,
    String? sucursalId,
    bool? activo,
  }) {
    return Producto(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      marca: marca ?? this.marca,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      stock: stock ?? this.stock,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      sucursalId: sucursalId ?? this.sucursalId,
      activo: activo ?? this.activo,
    );
  }

  bool get stockBajo {
    return stock <= stockMinimo;
  }
}