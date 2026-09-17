import '../models/inventario.dart';
import '../models/movimiento_inventario.dart';

class InventarioController {
  static final InventarioController instancia =
  InventarioController._interno();

  InventarioController._interno();

  final List<Inventario> _inventarios = [
    const Inventario(
      id: 'INV-001',
      productoId: 'PROD-001',
      sucursalId: 'SUC-001',
      stock: 8,
      stockMinimo: 3,
    ),

    const Inventario(
      id: 'INV-002',
      productoId: 'PROD-001',
      sucursalId: 'SUC-002',
      stock: 4,
      stockMinimo: 3,
    ),

    const Inventario(
      id: 'INV-003',
      productoId: 'PROD-001',
      sucursalId: 'SUC-003',
      stock: 1,
      stockMinimo: 3,
    ),

    const Inventario(
      id: 'INV-004',
      productoId: 'PROD-002',
      sucursalId: 'SUC-001',
      stock: 24,
      stockMinimo: 5,
    ),

    const Inventario(
      id: 'INV-005',
      productoId: 'PROD-002',
      sucursalId: 'SUC-002',
      stock: 8,
      stockMinimo: 5,
    ),

    const Inventario(
      id: 'INV-006',
      productoId: 'PROD-002',
      sucursalId: 'SUC-003',
      stock: 2,
      stockMinimo: 5,
    ),

    const Inventario(
      id: 'INV-007',
      productoId: 'PROD-003',
      sucursalId: 'SUC-001',
      stock: 4,
      stockMinimo: 5,
    ),

    const Inventario(
      id: 'INV-008',
      productoId: 'PROD-003',
      sucursalId: 'SUC-002',
      stock: 10,
      stockMinimo: 5,
    ),

    const Inventario(
      id: 'INV-009',
      productoId: 'PROD-003',
      sucursalId: 'SUC-003',
      stock: 0,
      stockMinimo: 5,
    ),
  ];

  final List<MovimientoInventario> _movimientos = [];

  List<Inventario> obtenerInventarios() {
    return List.unmodifiable(_inventarios);
  }

  Inventario? obtenerPorId(String id) {
    for (final inventario in _inventarios) {
      if (inventario.id == id) {
        return inventario;
      }
    }

    return null;
  }

  List<Inventario> obtenerPorProducto(
      String productoId,
      ) {
    return _inventarios.where(
          (inventario) {
        return inventario.productoId == productoId;
      },
    ).toList();
  }

  List<Inventario> obtenerPorSucursal(
      String sucursalId,
      ) {
    return _inventarios.where(
          (inventario) {
        return inventario.sucursalId == sucursalId;
      },
    ).toList();
  }

  List<Inventario> obtenerStockBajo() {
    return _inventarios.where(
          (inventario) {
        return inventario.stockBajo;
      },
    ).toList();
  }

  List<MovimientoInventario> obtenerMovimientos() {
    return List.unmodifiable(_movimientos);
  }

  List<MovimientoInventario> obtenerMovimientosPorInventario(
      String inventarioId,
      ) {
    return _movimientos.where(
          (movimiento) {
        return movimiento.inventarioId == inventarioId;
      },
    ).toList();
  }

  bool registrarMovimiento({
    required String inventarioId,
    required String tipo,
    required int cantidad,
    required String motivo,
    required String usuarioId,
  }) {
    final indice = _inventarios.indexWhere(
          (inventario) => inventario.id == inventarioId,
    );

    if (indice == -1) {
      return false;
    }

    if (cantidad <= 0) {
      return false;
    }

    final inventario = _inventarios[indice];

    int nuevoStock;

    switch (tipo) {
      case 'entrada':
        nuevoStock = inventario.stock + cantidad;
        break;

      case 'salida':
        nuevoStock = inventario.stock - cantidad;

        if (nuevoStock < 0) {
          return false;
        }

        break;

      default:
        return false;
    }

    final movimiento = MovimientoInventario(
      id: 'MOV-${_movimientos.length + 1}',
      inventarioId: inventario.id,
      productoId: inventario.productoId,
      sucursalId: inventario.sucursalId,
      tipo: tipo,
      cantidad: cantidad,
      stockAnterior: inventario.stock,
      stockNuevo: nuevoStock,
      motivo: motivo,
      usuarioId: usuarioId,
      fecha: DateTime.now(),
    );

    _inventarios[indice] = inventario.copyWith(
      stock: nuevoStock,
    );

    _movimientos.add(movimiento);

    return true;
  }

  bool ajustarStock({
    required String inventarioId,
    required int nuevoStock,
    required String motivo,
    required String usuarioId,
  }) {
    final indice = _inventarios.indexWhere(
          (inventario) => inventario.id == inventarioId,
    );

    if (indice == -1) {
      return false;
    }

    if (nuevoStock < 0) {
      return false;
    }

    final inventario = _inventarios[indice];

    if (inventario.stock == nuevoStock) {
      return false;
    }

    final movimiento = MovimientoInventario(
      id: 'MOV-${_movimientos.length + 1}',
      inventarioId: inventario.id,
      productoId: inventario.productoId,
      sucursalId: inventario.sucursalId,
      tipo: 'ajuste',
      cantidad: nuevoStock - inventario.stock,
      stockAnterior: inventario.stock,
      stockNuevo: nuevoStock,
      motivo: motivo,
      usuarioId: usuarioId,
      fecha: DateTime.now(),
    );

    _inventarios[indice] = inventario.copyWith(
      stock: nuevoStock,
    );

    _movimientos.add(movimiento);

    return true;
  }
}