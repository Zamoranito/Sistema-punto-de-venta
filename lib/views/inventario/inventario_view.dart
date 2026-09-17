import 'package:flutter/material.dart';

import '../../controllers/inventario_controller.dart';
import '../../controllers/producto_controller.dart';
import '../../models/inventario.dart';
import '../../models/producto.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';
import 'inventario_detalle_view.dart';
import 'movimientos_inventario_view.dart';
import 'movimiento_entrada_view.dart';
import 'movimiento_salida_view.dart';

class InventarioView extends StatefulWidget {
  const InventarioView({super.key});

  @override
  State<InventarioView> createState() =>
      _InventarioViewState();
}

class _InventarioViewState
    extends State<InventarioView> {
  final InventarioController _inventarioController = InventarioController.instancia;

  final ProductoController _productoController = ProductoController.instancia;

  final TextEditingController _busquedaController = TextEditingController();

  List<Inventario> _inventarios = [];

  String? _sucursalSeleccionada;
  bool? _stockBajoSeleccionado;

  @override
  void initState() {
    super.initState();

    _inventarios = _inventarioController.obtenerInventarios();

    _busquedaController.addListener(
      _aplicarFiltros,
    );
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  void _aplicarFiltros() {
    final texto =
    _busquedaController.text.trim().toLowerCase();

    setState(() {
      _inventarios = _inventarioController.obtenerInventarios().where(
                (inventario) {
              if (_sucursalSeleccionada != null &&
                  inventario.sucursalId !=
                      _sucursalSeleccionada) {
                return false;
              }

              if (_stockBajoSeleccionado != null &&
                  inventario.stockBajo !=
                      _stockBajoSeleccionado) {
                return false;
              }

              if (texto.isEmpty) {
                return true;
              }

              final producto =
              _productoController.obtenerPorId(
                inventario.productoId,
              );

              if (producto == null) {
                return false;
              }

              return producto.nombre
                  .toLowerCase()
                  .contains(texto) ||
                  producto.codigo
                      .toLowerCase()
                      .contains(texto) ||
                  producto.marca
                      .toLowerCase()
                      .contains(texto) ||
                  producto.categoria
                      .toLowerCase()
                      .contains(texto);
            },
          ).toList();
    });
  }

  void _limpiarFiltros() {
    setState(() {
      _sucursalSeleccionada = null;
      _stockBajoSeleccionado = null;
      _inventarios =
          _inventarioController.obtenerInventarios();
    });
  }

  void _actualizar() {
    _aplicarFiltros();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Inventario actualizado.',
        ),
      ),
    );
  }

  Producto? _obtenerProducto(
      Inventario inventario,
      ) {
    return _productoController.obtenerPorId(
      inventario.productoId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalRegistros = _inventarios.length;

    final stockBajo = _inventarios.where(
          (inventario) => inventario.stockBajo,
    ).length;

    final unidades = _inventarios.fold<int>(
      0,
          (total, inventario) =>
      total + inventario.stock,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        actions: [
          IconButton(
            tooltip: 'Registrar entrada',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const MovimientoEntradaView(),
                ),
              );

              _actualizar();
            },
            icon: const Icon(
              Icons.add_box_outlined,
            ),
          ),

          IconButton(
            tooltip: 'Registrar salida',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const MovimientoSalidaView(),
                ),
              );

              _actualizar();
            },
            icon: const Icon(
              Icons.remove_circle_outline,
            ),
          ),

          IconButton(
            tooltip: 'Movimientos',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const MovimientosInventarioView(),
                ),
              );
            },
            icon: const Icon(
              Icons.history,
            ),
          ),

          IconButton(
            tooltip: 'Actualizar',
            onPressed: _actualizar,
            icon: const Icon(
              Icons.refresh,
            ),
          ),

        ],

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: 'Control de inventario',
              subtitle:
              'Consulta las existencias de las sucursales.',
            ),

            const SizedBox(height: 20),

            _resumen(
              context,
              totalRegistros,
              unidades,
              stockBajo,
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
                labelText: 'Buscar producto',
                hintText:
                'Código, nombre, marca o categoría',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon:
                _busquedaController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _busquedaController
                        .clear();
                  },
                  icon: const Icon(
                    Icons.clear,
                  ),
                )
                    : null,
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue:
              _sucursalSeleccionada,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Sucursal',
                prefixIcon: Icon(
                  Icons.store_outlined,
                ),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('Todas'),
                ),
                DropdownMenuItem<String>(
                  value: 'SUC-001',
                  child: Text('Sucursal Norte'),
                ),
                DropdownMenuItem<String>(
                  value: 'SUC-002',
                  child: Text('Sucursal Sur'),
                ),
                DropdownMenuItem<String>(
                  value: 'SUC-003',
                  child: Text('Sucursal Centro'),
                ),
              ],
              onChanged: (valor) {
                setState(() {
                  _sucursalSeleccionada =
                      valor;
                });

                _aplicarFiltros();
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<bool?>(
              initialValue:
              _stockBajoSeleccionado,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Estado del stock',
                prefixIcon: Icon(
                  Icons.inventory_outlined,
                ),
              ),
              items: const [
                DropdownMenuItem<bool?>(
                  value: null,
                  child: Text('Todos'),
                ),
                DropdownMenuItem<bool?>(
                  value: false,
                  child: Text('Stock normal'),
                ),
                DropdownMenuItem<bool?>(
                  value: true,
                  child: Text('Stock bajo'),
                ),
              ],
              onChanged: (valor) {
                setState(() {
                  _stockBajoSeleccionado =
                      valor;
                });

                _aplicarFiltros();
              },
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _limpiarFiltros,
                icon: const Icon(
                  Icons.clear_all,
                ),
                label: const Text(
                  'Limpiar filtros',
                ),
              ),
            ),

            const SizedBox(height: 12),

            if (_inventarios.isEmpty)
              AppCard(
                child: Padding(
                  padding:
                  const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No se encontraron registros de inventario.',
                          textAlign:
                          TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              AppCard(
                child: Column(
                  children: [
                    for (
                    int i = 0;
                    i < _inventarios.length;
                    i++
                    ) ...[
                      _InventarioItem(
                        inventario: _inventarios[i],
                        producto: _obtenerProducto(
                          _inventarios[i],
                        ),
                        onVerDetalle: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  InventarioDetalleView(
                                    inventario: _inventarios[i],
                                    producto: _obtenerProducto(
                                      _inventarios[i],
                                    ),
                                  ),
                            ),
                          );
                        },
                      ),
                      if (i <
                          _inventarios.length - 1)
                        const Divider(),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _resumen(
      BuildContext context,
      int totalRegistros,
      int unidades,
      int stockBajo,
      ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ResumenCard(
                titulo: 'Registros',
                valor: '$totalRegistros',
                icono:
                Icons.inventory_2_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ResumenCard(
                titulo: 'Unidades',
                valor: '$unidades',
                icono: Icons.numbers_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _ResumenCard(
          titulo: 'Stock bajo',
          valor: '$stockBajo',
          icono:
          Icons.warning_amber_outlined,
        ),
      ],
    );
  }
}

class _ResumenCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _ResumenCard({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Icon(
            icono,
            size: 28,
            color: Theme.of(context)
                .colorScheme
                .primary,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  titulo,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InventarioItem extends StatelessWidget {
  final Inventario inventario;
  final Producto? producto;
  final VoidCallback onVerDetalle;

  const _InventarioItem({
    required this.inventario,
    required this.producto,
    required this.onVerDetalle,
  });

  @override
  Widget build(BuildContext context) {
    final stockBajo = inventario.stockBajo;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: InkWell(
        onTap: onVerDetalle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: stockBajo
                      ? Theme.of(context)
                      .colorScheme
                      .errorContainer
                      : Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  stockBajo
                      ? Icons.warning_amber_outlined
                      : Icons.inventory_2_outlined,
                  color: stockBajo
                      ? Theme.of(context)
                      .colorScheme
                      .error
                      : Theme.of(context)
                      .colorScheme
                      .primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto?.nombre ??
                          'Producto desconocido',
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      producto?.codigo ??
                          inventario.productoId,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _nombreSucursal(
                        inventario.sucursalId,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    '${inventario.stock}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  Text(
                    'unidades',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    stockBajo
                        ? 'Stock bajo'
                        : 'Normal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
                      color: stockBajo
                          ? Theme.of(context)
                          .colorScheme
                          .error
                          : Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                ],
              ),
            ],
          ),),
      ),
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
}