import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../models/item_carrito.dart';
import '../../models/producto.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../widgets/section_title.dart';

class CarritoVentaView extends StatefulWidget {
  final List<Producto> productos;

  const CarritoVentaView({
    super.key,
    required this.productos,
  });

  @override
  State<CarritoVentaView> createState() =>
      _CarritoVentaViewState();
}

class _CarritoVentaViewState
    extends State<CarritoVentaView> {
  late final List<ItemCarrito> _carrito;

  @override
  void initState() {
    super.initState();

    _carrito = widget.productos.map(
          (producto) {
        return ItemCarrito(
          producto: producto,
        );
      },
    ).toList();
  }

  double get _subtotal {
    return _carrito.fold(
      0,
          (total, item) => total + item.subtotal,
    );
  }

  double get _impuesto {
    return _subtotal *
        (AppConfig.impuestoPorcentaje / 100);
  }

  double get _total {
    return _subtotal + _impuesto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionTitle(
            title: 'Carrito de venta',
            subtitle:
            'Revisa los productos y cantidades.',
          ),

          const SizedBox(height: 20),

          if (_carrito.isEmpty)
            AppCard(
              child: Column(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'El carrito está vacío',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          else
            ..._carrito.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _ItemCarritoWidget(
                  item: item,
                  onIncrementar: () {
                    _cambiarCantidad(
                      item,
                      item.cantidad + 1,
                    );
                  },
                  onDisminuir: () {
                    _cambiarCantidad(
                      item,
                      item.cantidad - 1,
                    );
                  },
                  onEliminar: () {
                    _eliminarItem(item);
                  },
                ),
              ),
            ),

          if (_carrito.isNotEmpty) ...[
            const SizedBox(height: 12),

            AppCard(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de la venta',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _dato(
                    context,
                    'Productos',
                    '${_carrito.length}',
                  ),

                  const SizedBox(height: 10),

                  _dato(
                    context,
                    'Subtotal',
                    _formatearMoneda(_subtotal),
                  ),

                  const SizedBox(height: 10),

                  _dato(
                    context,
                    'IVA (${AppConfig.impuestoPorcentaje.toStringAsFixed(0)}%)',
                    _formatearMoneda(_impuesto),
                  ),

                  const Divider(height: 24),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatearMoneda(_total),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            AppButton(
              text: 'Continuar',
              icon: Icons.arrow_forward,
              onPressed: _continuar,
            ),
          ],
        ],
      ),
    );
  }

  void _cambiarCantidad(
      ItemCarrito item,
      int nuevaCantidad,
      ) {
    if (nuevaCantidad <= 0) {
      _eliminarItem(item);
      return;
    }

    setState(() {
      item.cantidad = nuevaCantidad;
    });
  }

  void _eliminarItem(ItemCarrito item) {
    setState(() {
      _carrito.remove(item);
    });
  }

  void _continuar() {
    Navigator.pop(
      context,
      _carrito,
    );
  }

  Widget _dato(
      BuildContext context,
      String titulo,
      String valor,
      ) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo),
        Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatearMoneda(double valor) {
    return '\$${valor.toStringAsFixed(2)}';
  }
}

class _ItemCarritoWidget extends StatelessWidget {
  final ItemCarrito item;
  final VoidCallback onIncrementar;
  final VoidCallback onDisminuir;
  final VoidCallback onEliminar;

  const _ItemCarritoWidget({
    required this.item,
    required this.onIncrementar,
    required this.onDisminuir,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.producto.nombre,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton(
                tooltip: 'Eliminar',
                onPressed: onEliminar,
                icon: const Icon(
                  Icons.delete_outline,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            item.producto.codigo,
            style: Theme.of(context)
                .textTheme
                .bodySmall,
          ),

          const SizedBox(height: 8),

          Text(
            'Precio: ${_formatearMoneda(item.producto.precioVenta)}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              IconButton(
                onPressed: onDisminuir,
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
              ),

              Container(
                constraints: const BoxConstraints(
                  minWidth: 40,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${item.cantidad}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              IconButton(
                onPressed: onIncrementar,
                icon: const Icon(
                  Icons.add_circle_outline,
                ),
              ),

              const Spacer(),

              Text(
                _formatearMoneda(item.subtotal),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatearMoneda(double valor) {
    return '\$${valor.toStringAsFixed(2)}';
  }
}