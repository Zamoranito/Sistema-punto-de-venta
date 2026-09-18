import 'package:flutter/material.dart';

import '../../controllers/inventario_controller.dart';
import '../../controllers/producto_controller.dart';
import '../../models/inventario.dart';
import '../../models/producto.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_title.dart';

class MovimientoAjusteView extends StatefulWidget {
  const MovimientoAjusteView({
    super.key,
  });

  @override
  State<MovimientoAjusteView> createState() =>
      _MovimientoAjusteViewState();
}

class _MovimientoAjusteViewState
    extends State<MovimientoAjusteView> {
  final InventarioController _inventarioController =
      InventarioController.instancia;

  final ProductoController _productoController =
      ProductoController.instancia;

  final TextEditingController _nuevoStockController =
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
    _nuevoStockController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  void _registrarAjuste() {
    if (_inventarioSeleccionado == null) {
      _mostrarMensaje(
        'Selecciona un producto y sucursal.',
      );
      return;
    }

    final nuevoStock = int.tryParse(
      _nuevoStockController.text.trim(),
    );

    if (nuevoStock == null || nuevoStock < 0) {
      _mostrarMensaje(
        'Ingresa un nuevo stock válido.',
      );
      return;
    }

    final motivo = _motivoController.text.trim();

    if (motivo.isEmpty) {
      _mostrarMensaje(
        'Ingresa el motivo del ajuste.',
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

    if (nuevoStock == inventario.stock) {
      _mostrarMensaje(
        'El nuevo stock debe ser diferente al stock actual.',
      );
      return;
    }

    final resultado =
    _inventarioController.ajustarStock(
      inventarioId: _inventarioSeleccionado!,
      nuevoStock: nuevoStock,
      motivo: motivo,
      usuarioId: 'USR-001',
    );

    if (!resultado) {
      _mostrarMensaje(
        'No fue posible registrar el ajuste.',
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Ajuste registrado correctamente.',
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
          'Ajustar inventario',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Ajuste de inventario',
              subtitle:
              'Corrige el stock cuando el inventario físico no coincide con el registrado.',
            ),

            const SizedBox(height: 20),

            AppCard(
              child: DropdownButtonFormField<String>(
                initialValue:
                _inventarioSeleccionado,
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
                        child: Column(
                          mainAxisSize:
                          MainAxisSize.min,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              producto?.nombre ??
                                  'Producto desconocido',
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              _nombreSucursal(
                                inventario
                                    .sucursalId,
                              ),
                              overflow:
                              TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(
                                context,
                              )
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

                    final inventario =
                    _inventarioController
                        .obtenerPorId(
                      valor!,
                    );

                    if (inventario != null) {
                      _nuevoStockController
                          .text =
                          inventario.stock
                              .toString();
                    }
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
              _nuevoStockController,
              label: 'Nuevo stock',
              hint: 'Ej. 10',
              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 16),

            AppTextField(
              controller:
              _motivoController,
              label: 'Motivo',
              hint:
              'Ej. Conteo físico de inventario',
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            AppButton(
              text: 'Ajustar inventario',
              icon: Icons.tune,
              onPressed: _registrarAjuste,
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