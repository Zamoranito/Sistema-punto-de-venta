import 'package:flutter/material.dart';

import '../../controllers/inventario_controller.dart';
import '../../controllers/producto_controller.dart';
import '../../models/inventario.dart';
import '../../models/producto.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_title.dart';

class MovimientoSalidaView extends StatefulWidget {
  const MovimientoSalidaView({
    super.key,
  });

  @override
  State<MovimientoSalidaView> createState() =>
      _MovimientoSalidaViewState();
}

class _MovimientoSalidaViewState
    extends State<MovimientoSalidaView> {
  final InventarioController _inventarioController =
      InventarioController.instancia;

  final ProductoController _productoController =
      ProductoController.instancia;

  final TextEditingController _cantidadController =
  TextEditingController();

  final TextEditingController _motivoController =
  TextEditingController();

  String? _inventarioSeleccionado;

  List<Inventario> get _inventarios {
    return _inventarioController.obtenerInventarios();
  }

  Producto? _obtenerProducto(
      String productoId,
      ) {
    return _productoController.obtenerPorId(
      productoId,
    );
  }

  String _nombreSucursal(
      String sucursalId,
      ) {
    switch (sucursalId) {
      case 'SUC-001':
        return 'Sucursal Norte';

      case 'SUC-002':
        return 'Sucursal Sur';

      case 'SUC-003':
        return 'Sucursal Centro';

      default:
        return sucursalId;
    }
  }

  Inventario? get _inventarioActual {
    if (_inventarioSeleccionado == null) {
      return null;
    }

    return _inventarioController.obtenerPorId(
      _inventarioSeleccionado!,
    );
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  void _registrarSalida() {
    if (_inventarioSeleccionado == null) {
      _mostrarMensaje(
        'Selecciona un producto y sucursal.',
      );
      return;
    }

    final cantidad = int.tryParse(
      _cantidadController.text.trim(),
    );

    if (cantidad == null || cantidad <= 0) {
      _mostrarMensaje(
        'Ingresa una cantidad válida.',
      );
      return;
    }

    final motivo =
    _motivoController.text.trim();

    if (motivo.isEmpty) {
      _mostrarMensaje(
        'Ingresa el motivo de la salida.',
      );
      return;
    }

    final inventario =
    _inventarioController.obtenerPorId(
      _inventarioSeleccionado!,
    );

    if (inventario == null) {
      _mostrarMensaje(
        'No se encontró el inventario seleccionado.',
      );
      return;
    }

    if (cantidad > inventario.stock) {
      _mostrarMensaje(
        'No hay suficiente stock disponible.',
      );
      return;
    }

    final resultado =
    _inventarioController.registrarMovimiento(
      inventarioId: _inventarioSeleccionado!,
      tipo: 'salida',
      cantidad: cantidad,
      motivo: motivo,
      usuarioId: 'USR-001',
    );

    if (!resultado) {
      _mostrarMensaje(
        'No fue posible registrar la salida.',
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Salida registrada correctamente.',
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inventario = _inventarioActual;

    final producto = inventario == null
        ? null
        : _obtenerProducto(
      inventario.productoId,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar salida',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Salida de inventario',
              subtitle:
              'Registra la salida de productos de una sucursal.',
            ),

            const SizedBox(height: 20),

            AppCard(
              child: DropdownButtonFormField<String>(
                initialValue: _inventarioSeleccionado,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText:
                  'Producto y sucursal',
                  border:
                  OutlineInputBorder(),
                ),
                items: _inventarios.map(
                      (inventario) {
                    final producto =
                    _obtenerProducto(
                      inventario.productoId,
                    );

                    return DropdownMenuItem<String>(
                      value: inventario.id,
                      child: SizedBox(
                        width: 180,
                        height: 40,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              producto?.nombre ??
                                  'Producto desconocido',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              _nombreSucursal(
                                inventario.sucursalId,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );

                  },
                ).toList(),
                onChanged: (valor) {
                  setState(() {
                    _inventarioSeleccionado =
                        valor;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            if (inventario != null &&
                producto != null)
              AppCard(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      producto.codigo,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _dato(
                            context,
                            'Sucursal',
                            _nombreSucursal(
                              inventario
                                  .sucursalId,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _dato(
                            context,
                            'Stock actual',
                            '${inventario.stock}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            AppTextField(
              controller:
              _cantidadController,
              label: 'Cantidad',
              hint: 'Ej. 5',
              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller:
              _motivoController,
              label: 'Motivo',
              hint: 'Ej. Venta',
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            AppButton(
              text: 'Registrar salida',
              icon:
              Icons.remove_circle_outline,
              onPressed:
              _registrarSalida,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dato(
      BuildContext context,
      String titulo,
      String valor,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: Theme.of(context)
              .textTheme
              .bodySmall,
        ),

        const SizedBox(height: 4),

        Text(
          valor,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}