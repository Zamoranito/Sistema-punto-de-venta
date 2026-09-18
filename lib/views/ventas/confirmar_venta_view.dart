import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/venta_controller.dart';
import '../../models/item_carrito.dart';
import '../../models/venta.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../widgets/section_title.dart';

class ConfirmarVentaView extends StatefulWidget {
  final List<ItemCarrito> carrito;
  final String metodoPago;

  const ConfirmarVentaView({
    super.key,
    required this.carrito,
    required this.metodoPago,
  });

  @override
  State<ConfirmarVentaView> createState() =>
      _ConfirmarVentaViewState();
}

class _ConfirmarVentaViewState
    extends State<ConfirmarVentaView> {
  final VentaController _ventaController =
      VentaController.instancia;

  bool _procesando = false;

  double get _subtotal {
    return widget.carrito.fold(
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
    final usuario =
        AppController.usuario.usuarioActual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar venta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionTitle(
            title: 'Confirmar venta',
            subtitle:
            'Revisa la información antes de registrar la venta.',
          ),

          const SizedBox(height: 20),

          AppCard(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Información',
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
                  'Usuario',
                  usuario?.nombre ??
                      'No identificado',
                ),

                const SizedBox(height: 10),

                _dato(
                  context,
                  'Sucursal',
                  _nombreSucursal(
                    usuario?.sucursalId ?? '',
                  ),
                ),

                const SizedBox(height: 10),

                _dato(
                  context,
                  'Método de pago',
                  _nombreMetodoPago(
                    widget.metodoPago,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          AppCard(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Productos',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...widget.carrito.map(
                      (item) => Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                item.producto.nombre,
                                maxLines: 2,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style: const TextStyle(
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '${item.cantidad} × ${_formatearMoneda(item.producto.precioVenta)}',
                                style: Theme.of(
                                  context,
                                )
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatearMoneda(
                            item.subtotal,
                          ),
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          AppCard(
            child: Column(
              children: [
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
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatearMoneda(_total),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          AppButton(
            text: 'Confirmar venta',
            icon: Icons.check_circle_outline,
            loading: _procesando,
            onPressed:
            _procesando ? null : _confirmarVenta,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarVenta() async {
    final usuario =
        AppController.usuario.usuarioActual;

    if (usuario == null) {
      _mostrarMensaje(
        'No hay un usuario autenticado.',
      );
      return;
    }

    if (widget.carrito.isEmpty) {
      _mostrarMensaje(
        'No hay productos en la venta.',
      );
      return;
    }

    setState(() {
      _procesando = true;
    });

    final creada =
    _ventaController.crearVenta(
      sucursalId: usuario.sucursalId,
      usuarioId: usuario.id,
      subtotal: _subtotal,
      impuesto: _impuesto,
      total: _total,
      metodoPago: widget.metodoPago,
    );

    if (!creada) {
      setState(() {
        _procesando = false;
      });

      _mostrarMensaje(
        'No fue posible crear la venta.',
      );
      return;
    }

    final ventas =
    _ventaController.obtenerVentas();

    final Venta venta = ventas.last;

    bool detallesCorrectos = true;

    for (final item in widget.carrito) {
      final detalle =
      _ventaController.agregarDetalle(
        ventaId: venta.id,
        productoId: item.producto.id,
        cantidad: item.cantidad,
        precioUnitario:
        item.producto.precioVenta,
      );

      if (!detalle) {
        detallesCorrectos = false;
        break;
      }
    }

    if (!detallesCorrectos) {
      setState(() {
        _procesando = false;
      });

      _mostrarMensaje(
        'La venta se creó, pero ocurrió un problema al registrar los detalles.',
      );
      return;
    }

    if (!mounted) return;

    setState(() {
      _procesando = false;
    });

    await _mostrarVentaCreada(venta);
  }

  Future<void> _mostrarVentaCreada(
      Venta venta,
      ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Venta registrada',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'La venta ${venta.id} se registró correctamente.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Total: ${_formatearMoneda(venta.total)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.popUntil(
      context,
          (route) => route.isFirst,
    );
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  Widget _dato(
      BuildContext context,
      String titulo,
      String valor,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(titulo),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _nombreSucursal(String sucursalId) {
    switch (sucursalId) {
      case 'SUC-001':
        return 'Sucursal Norte';
      case 'SUC-002':
        return 'Sucursal Sur';
      case 'SUC-003':
        return 'Sucursal Centro';
      default:
        return sucursalId.isEmpty
            ? 'No identificada'
            : sucursalId;
    }
  }

  String _nombreMetodoPago(String metodo) {
    switch (metodo) {
      case 'efectivo':
        return 'Efectivo';
      case 'tarjeta':
        return 'Tarjeta';
      case 'transferencia':
        return 'Transferencia';
      default:
        return metodo;
    }
  }

  String _formatearMoneda(double valor) {
    return '\$${valor.toStringAsFixed(2)}';
  }
}