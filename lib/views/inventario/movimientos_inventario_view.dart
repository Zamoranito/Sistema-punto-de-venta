import 'package:flutter/material.dart';

import '../../controllers/inventario_controller.dart';
import '../../controllers/producto_controller.dart';
import '../../models/movimiento_inventario.dart';
import '../../models/producto.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';

class MovimientosInventarioView extends StatefulWidget {
  const MovimientosInventarioView({
    super.key,
  });

  @override
  State<MovimientosInventarioView> createState() =>
      _MovimientosInventarioViewState();
}

class _MovimientosInventarioViewState
    extends State<MovimientosInventarioView> {
  final InventarioController _inventarioController =
      InventarioController.instancia;

  final ProductoController _productoController =
      ProductoController.instancia;

  List<MovimientoInventario> _movimientos = [];

  String _tipoSeleccionado = 'todos';

  @override
  void initState() {
    super.initState();
    _cargarMovimientos();
  }

  void _cargarMovimientos() {
    setState(() {
      _movimientos =
          _inventarioController.obtenerMovimientos();
    });
  }

  List<MovimientoInventario> get _movimientosFiltrados {
    if (_tipoSeleccionado == 'todos') {
      return _movimientos;
    }

    return _movimientos.where(
          (movimiento) {
        return movimiento.tipo == _tipoSeleccionado;
      },
    ).toList();
  }

  Producto? _obtenerProducto(
      MovimientoInventario movimiento,
      ) {
    return _productoController.obtenerPorId(
      movimiento.productoId,
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
        return sucursalId;
    }
  }

  String _nombreTipo(String tipo) {
    switch (tipo) {
      case 'entrada':
        return 'Entrada';

      case 'salida':
        return 'Salida';

      case 'ajuste':
        return 'Ajuste';

      default:
        return tipo;
    }
  }

  IconData _iconoTipo(String tipo) {
    switch (tipo) {
      case 'entrada':
        return Icons.arrow_downward_rounded;

      case 'salida':
        return Icons.arrow_upward_rounded;

      case 'ajuste':
        return Icons.tune_rounded;

      default:
        return Icons.swap_vert_rounded;
    }
  }

  Color _colorTipo(
      BuildContext context,
      String tipo,
      ) {
    final colores =
        Theme.of(context).colorScheme;

    switch (tipo) {
      case 'entrada':
        return colores.primary;

      case 'salida':
        return colores.error;

      case 'ajuste':
        return colores.tertiary;

      default:
        return colores.primary;
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();

    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/$anio $hora:$minuto';
  }

  @override
  Widget build(BuildContext context) {
    final movimientos =
        _movimientosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movimientos de inventario',
        ),
        actions: [
          IconButton(
            onPressed: _cargarMovimientos,
            icon: const Icon(
              Icons.refresh,
            ),
            tooltip: 'Actualizar',
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
              title: 'Historial de movimientos',
              subtitle:
              'Consulta las entradas, salidas y ajustes de inventario.',
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _tipoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de movimiento',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'todos',
                  child: Text('Todos'),
                ),
                DropdownMenuItem(
                  value: 'entrada',
                  child: Text('Entradas'),
                ),
                DropdownMenuItem(
                  value: 'salida',
                  child: Text('Salidas'),
                ),
                DropdownMenuItem(
                  value: 'ajuste',
                  child: Text('Ajustes'),
                ),
              ],
              onChanged: (valor) {
                if (valor == null) return;

                setState(() {
                  _tipoSeleccionado = valor;
                });
              },
            ),

            const SizedBox(height: 24),

            if (movimientos.isEmpty)
              _estadoVacio(context)
            else
              ...movimientos.map(
                    (movimiento) {
                  final producto =
                  _obtenerProducto(
                    movimiento,
                  );

                  return Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: _MovimientoItem(
                      movimiento: movimiento,
                      producto: producto,
                      sucursal: _nombreSucursal(
                        movimiento.sucursalId,
                      ),
                      tipo:
                      _nombreTipo(
                        movimiento.tipo,
                      ),
                      icono:
                      _iconoTipo(
                        movimiento.tipo,
                      ),
                      color:
                      _colorTipo(
                        context,
                        movimiento.tipo,
                      ),
                      fecha:
                      _formatearFecha(
                        movimiento.fecha,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _estadoVacio(BuildContext context) {
    return AppCard(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 20,
          ),
          child: Column(
            children: [
              Icon(
                Icons.history_rounded,
                size: 56,
                color: Theme.of(context)
                    .colorScheme
                    .outline,
              ),

              const SizedBox(height: 16),

              Text(
                'No hay movimientos registrados',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Cuando se registre una entrada, '
                    'salida o ajuste, aparecerá aquí.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MovimientoItem extends StatelessWidget {
  final MovimientoInventario movimiento;
  final Producto? producto;
  final String sucursal;
  final String tipo;
  final IconData icono;
  final Color color;
  final String fecha;

  const _MovimientoItem({
    required this.movimiento,
    required this.producto,
    required this.sucursal,
    required this.tipo,
    required this.icono,
    required this.color,
    required this.fecha,
  });

  @override
  Widget build(BuildContext context) {
    final esAjuste =
        movimiento.tipo == 'ajuste';

    final cantidadTexto = esAjuste
        ? '${movimiento.cantidad > 0 ? '+' : ''}'
        '${movimiento.cantidad}'
        : movimiento.tipo == 'entrada'
        ? '+${movimiento.cantidad}'
        : '-${movimiento.cantidad}';

    return AppCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  icono,
                  color: color,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto?.nombre ??
                          'Producto desconocido',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      producto?.codigo ??
                          movimiento.productoId,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ],
                ),
              ),

              Text(
                cantidadTexto,
                style: TextStyle(
                  fontWeight:
                  FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
              ),
            ],
          ),

          const Divider(height: 24),

          _dato(
            context,
            'Movimiento',
            tipo,
            Icons.swap_vert_rounded,
          ),

          const SizedBox(height: 10),

          _dato(
            context,
            'Sucursal',
            sucursal,
            Icons.store_outlined,
          ),

          const SizedBox(height: 10),

          _dato(
            context,
            'Stock',
            '${movimiento.stockAnterior} → '
                '${movimiento.stockNuevo}',
            Icons.inventory_2_outlined,
          ),

          const SizedBox(height: 10),

          _dato(
            context,
            'Motivo',
            movimiento.motivo,
            Icons.description_outlined,
          ),

          const SizedBox(height: 10),

          _dato(
            context,
            'Fecha',
            fecha,
            Icons.schedule_outlined,
          ),

          const SizedBox(height: 10),

          _dato(
            context,
            'Usuario',
            movimiento.usuarioId,
            Icons.person_outline,
          ),
        ],
      ),
    );
  }

  Widget _dato(
      BuildContext context,
      String titulo,
      String valor,
      IconData icono,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Icon(
          icono,
          size: 20,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            titulo,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
        ),

        const SizedBox(width: 12),

        Flexible(
          child: Text(
            valor,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
