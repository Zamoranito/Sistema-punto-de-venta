
import 'package:flutter/material.dart';

import '../../controllers/venta_controller.dart';
import '../../models/venta.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_card.dart';
import '../../widgets/section_title.dart';
import 'nueva_venta_view.dart';

class VentasView extends StatefulWidget {
  const VentasView({
    super.key,
  });

  @override
  State<VentasView> createState() =>
      _VentasViewState();
}

class _VentasViewState extends State<VentasView> {
  final VentaController _ventaController =
      VentaController.instancia;

  List<Venta> get _ventas {
    return _ventaController.obtenerVentas();
  }

  double get _totalVentas {
    return _ventas.fold(
      0,
          (total, venta) => total + venta.total,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ventas = _ventas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: _actualizar,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _actualizar,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SectionTitle(
              title: 'Ventas',
              subtitle:
              'Consulta y administra las ventas realizadas.',
              action: FilledButton.icon(
                onPressed: _nuevaVenta,
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Nueva',
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: InfoCard(
                    title: 'Ventas',
                    value: '${ventas.length}',
                    icon: Icons.receipt_long,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InfoCard(
                    title: 'Total',
                    value: _formatearMoneda(
                      _totalVentas,
                    ),
                    icon: Icons.attach_money,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            if (ventas.isEmpty)
              AppCard(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Theme.of(context)
                          .colorScheme
                          .primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No hay ventas registradas',
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
                      'Las ventas realizadas aparecerán aquí.',
                      textAlign:
                      TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              )
            else
              ...ventas.map(
                    (venta) => Padding(
                  padding:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: _VentaItem(
                    venta: venta,
                    onTap: () {
                      _mostrarDetalle(
                        venta,
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _actualizar() async {
    setState(() {});
  }

  void _nuevaVenta() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NuevaVentaView(),
      ),
    );

    setState(() {});
  }

  void _mostrarDetalle(Venta venta) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                'Detalle de venta',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _dato(
                context,
                'Venta',
                venta.id,
              ),

              _dato(
                context,
                'Sucursal',
                _nombreSucursal(
                  venta.sucursalId,
                ),
              ),

              _dato(
                context,
                'Método de pago',
                venta.metodoPago,
              ),

              _dato(
                context,
                'Estado',
                _nombreEstado(
                  venta.estado,
                ),
              ),

              _dato(
                context,
                'Fecha',
                _formatearFecha(
                  venta.fecha,
                ),
              ),

              const SizedBox(height: 12),

              const Divider(),

              _dato(
                context,
                'Subtotal',
                _formatearMoneda(
                  venta.subtotal,
                ),
              ),

              _dato(
                context,
                'Impuesto',
                _formatearMoneda(
                  venta.impuesto,
                ),
              ),

              _dato(
                context,
                'Total',
                _formatearMoneda(
                  venta.total,
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _dato(
      BuildContext context,
      String titulo,
      String valor,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
          const SizedBox(width: 16),
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

  String _nombreEstado(
      String estado,
      ) {
    switch (estado) {
      case 'completada':
        return 'Completada';

      case 'cancelada':
        return 'Cancelada';

      default:
        return estado;
    }
  }

  String _formatearMoneda(
      double valor,
      ) {
    return '\$${valor.toStringAsFixed(2)}';
  }

  String _formatearFecha(
      DateTime fecha,
      ) {
    final dia = fecha.day
        .toString()
        .padLeft(2, '0');

    final mes = fecha.month
        .toString()
        .padLeft(2, '0');

    final anio = fecha.year;

    final hora = fecha.hour
        .toString()
        .padLeft(2, '0');

    final minuto = fecha.minute
        .toString()
        .padLeft(2, '0');

    return '$dia/$mes/$anio $hora:$minuto';
  }
}

class _VentaItem extends StatelessWidget {
  final Venta venta;
  final VoidCallback onTap;

  const _VentaItem({
    required this.venta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.receipt_long,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  venta.id,
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
                  venta.metodoPago,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),

                const SizedBox(height: 4),

                Text(
                  _formatearFecha(
                    venta.fecha,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Text(
                _formatearMoneda(
                  venta.total,
                ),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              _EstadoVenta(
                estado: venta.estado,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatearMoneda(
      double valor,
      ) {
    return '\$${valor.toStringAsFixed(2)}';
  }

  String _formatearFecha(
      DateTime fecha,
      ) {
    final dia = fecha.day
        .toString()
        .padLeft(2, '0');

    final mes = fecha.month
        .toString()
        .padLeft(2, '0');

    final hora = fecha.hour
        .toString()
        .padLeft(2, '0');

    final minuto = fecha.minute
        .toString()
        .padLeft(2, '0');

    return '$dia/$mes ${hora}:$minuto';
  }
}

class _EstadoVenta extends StatelessWidget {
  final String estado;

  const _EstadoVenta({
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final esCompletada =
        estado == 'completada';

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: esCompletada
            ? Theme.of(context)
            .colorScheme
            .primaryContainer
            : Theme.of(context)
            .colorScheme
            .errorContainer,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Text(
        esCompletada
            ? 'Completada'
            : 'Cancelada',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: esCompletada
              ? Theme.of(context)
              .colorScheme
              .onPrimaryContainer
              : Theme.of(context)
              .colorScheme
              .onErrorContainer,
        ),
      ),
    );
  }
}
