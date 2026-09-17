class MovimientoInventario {
  final String id;
  final String inventarioId;
  final String productoId;
  final String sucursalId;
  final String tipo;
  final int cantidad;
  final int stockAnterior;
  final int stockNuevo;
  final String motivo;
  final String usuarioId;
  final DateTime fecha;

  const MovimientoInventario({
    required this.id,
    required this.inventarioId,
    required this.productoId,
    required this.sucursalId,
    required this.tipo,
    required this.cantidad,
    required this.stockAnterior,
    required this.stockNuevo,
    required this.motivo,
    required this.usuarioId,
    required this.fecha,
  });

  MovimientoInventario copyWith({
    String? id,
    String? inventarioId,
    String? productoId,
    String? sucursalId,
    String? tipo,
    int? cantidad,
    int? stockAnterior,
    int? stockNuevo,
    String? motivo,
    String? usuarioId,
    DateTime? fecha,
  }) {
    return MovimientoInventario(
      id: id ?? this.id,
      inventarioId: inventarioId ?? this.inventarioId,
      productoId: productoId ?? this.productoId,
      sucursalId: sucursalId ?? this.sucursalId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      stockAnterior: stockAnterior ?? this.stockAnterior,
      stockNuevo: stockNuevo ?? this.stockNuevo,
      motivo: motivo ?? this.motivo,
      usuarioId: usuarioId ?? this.usuarioId,
      fecha: fecha ?? this.fecha,
    );
  }
}