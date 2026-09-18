import '../models/detalle_venta.dart';
import '../models/venta.dart';

class VentaController {
  static final VentaController instancia =
  VentaController._interno();

  VentaController._interno();

  final List<Venta> _ventas = [];

  final List<DetalleVenta> _detalles = [];

  List<Venta> obtenerVentas() {
    return List.unmodifiable(_ventas);
  }

  Venta? obtenerPorId(String id) {
    try {
      return _ventas.firstWhere(
            (venta) => venta.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  List<DetalleVenta> obtenerDetallesVenta(
      String ventaId,
      ) {
    return _detalles
        .where(
          (detalle) =>
      detalle.ventaId == ventaId,
    )
        .toList();
  }

  bool crearVenta({
    required String sucursalId,
    required String usuarioId,
    required double subtotal,
    required double impuesto,
    required double total,
    required String metodoPago,
  }) {
    if (subtotal < 0 ||
        impuesto < 0 ||
        total < 0) {
      return false;
    }

    if (metodoPago.trim().isEmpty) {
      return false;
    }

    final venta = Venta(
      id: 'VEN-${_ventas.length + 1}',
      sucursalId: sucursalId,
      usuarioId: usuarioId,
      subtotal: subtotal,
      impuesto: impuesto,
      total: total,
      metodoPago: metodoPago,
      estado: 'completada',
      fecha: DateTime.now(),
    );

    _ventas.add(venta);

    return true;
  }

  bool agregarDetalle({
    required String ventaId,
    required String productoId,
    required int cantidad,
    required double precioUnitario,
  }) {
    final venta = obtenerPorId(ventaId);

    if (venta == null) {
      return false;
    }

    if (cantidad <= 0) {
      return false;
    }

    if (precioUnitario < 0) {
      return false;
    }

    final subtotal =
        cantidad * precioUnitario;

    final detalle = DetalleVenta(
      id: 'DET-${_detalles.length + 1}',
      ventaId: ventaId,
      productoId: productoId,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      subtotal: subtotal,
    );

    _detalles.add(detalle);

    return true;
  }

  double calcularSubtotal(
      String ventaId,
      ) {
    return obtenerDetallesVenta(ventaId)
        .fold(
      0,
          (total, detalle) =>
      total + detalle.subtotal,
    );
  }

  double calcularTotal({
    required String ventaId,
    required double impuestoPorcentaje,
  }) {
    final subtotal =
    calcularSubtotal(ventaId);

    if (impuestoPorcentaje < 0) {
      return subtotal;
    }

    final impuesto =
        subtotal *
            (impuestoPorcentaje / 100);

    return subtotal + impuesto;
  }
}