class Inventario {
  final String id;
  final String productoId;
  final String sucursalId;
  final int stock;
  final int stockMinimo;

  const Inventario({
    required this.id,
    required this.productoId,
    required this.sucursalId,
    required this.stock,
    required this.stockMinimo,
  });

  Inventario copyWith({
    String? id,
    String? productoId,
    String? sucursalId,
    int? stock,
    int? stockMinimo,
  }) {
    return Inventario(
      id: id ?? this.id,
      productoId: productoId ?? this.productoId,
      sucursalId: sucursalId ?? this.sucursalId,
      stock: stock ?? this.stock,
      stockMinimo: stockMinimo ?? this.stockMinimo,
    );
  }

  bool get stockBajo {
    return stock <= stockMinimo;
  }
}