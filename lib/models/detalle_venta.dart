class DetalleVenta {
  final String id;
  final String ventaId;
  final String productoId;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetalleVenta({
    required this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  DetalleVenta copyWith({
    String? id,
    String? ventaId,
    String? productoId,
    int? cantidad,
    double? precioUnitario,
    double? subtotal,
  }) {
    return DetalleVenta(
      id: id ?? this.id,
      ventaId: ventaId ?? this.ventaId,
      productoId: productoId ?? this.productoId,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario:
      precioUnitario ?? this.precioUnitario,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}