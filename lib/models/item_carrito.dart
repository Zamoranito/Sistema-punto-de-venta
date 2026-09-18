import 'producto.dart';

class ItemCarrito {
  final Producto producto;
  int cantidad;

  ItemCarrito({
    required this.producto,
    this.cantidad = 1,
  });

  double get subtotal {
    return producto.precioVenta * cantidad;
  }

  ItemCarrito copyWith({
    Producto? producto,
    int? cantidad,
  }) {
    return ItemCarrito(
      producto: producto ?? this.producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}