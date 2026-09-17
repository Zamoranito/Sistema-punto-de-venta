import 'package:flutter/material.dart';

import '../../models/inventario.dart';
import '../../models/producto.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';

class InventarioDetalleView extends StatelessWidget {
  final Inventario inventario;
  final Producto? producto;

  const InventarioDetalleView({
    super.key,
    required this.inventario,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    final stockBajo = inventario.stockBajo;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del inventario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _encabezado(context),

            const SizedBox(height: 24),

            SectionTitle(
              title: 'Información del producto',
              subtitle:
              'Producto asociado a este inventario.',
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  _dato(
                    context,
                    'Producto',
                    producto?.nombre ??
                        'Producto desconocido',
                    Icons.inventory_2_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Código',
                    producto?.codigo ??
                        inventario.productoId,
                    Icons.qr_code_2_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Categoría',
                    producto?.categoria ??
                        'No disponible',
                    Icons.category_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Marca',
                    producto?.marca ??
                        'No disponible',
                    Icons.business_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SectionTitle(
              title: 'Existencias',
              subtitle:
              'Estado actual del inventario.',
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  _dato(
                    context,
                    'Sucursal',
                    _nombreSucursal(
                      inventario.sucursalId,
                    ),
                    Icons.store_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Stock actual',
                    '${inventario.stock} unidades',
                    Icons.inventory_2_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Stock mínimo',
                    '${inventario.stockMinimo} unidades',
                    Icons.warning_amber_outlined,
                  ),
                  const Divider(),
                  _estadoStock(
                    context,
                    stockBajo,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SectionTitle(
              title: 'Estado',
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  Icon(
                    stockBajo
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_outline,
                    size: 48,
                    color: stockBajo
                        ? Theme.of(context)
                        .colorScheme
                        .error
                        : Theme.of(context)
                        .colorScheme
                        .primary,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    stockBajo
                        ? 'El inventario necesita atención'
                        : 'Inventario en nivel normal',
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
                    stockBajo
                        ? 'La existencia actual está '
                        'en el nivel mínimo o por debajo.'
                        : 'La existencia actual está '
                        'por encima del nivel mínimo.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _encabezado(BuildContext context) {
    final stockBajo = inventario.stockBajo;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: stockBajo
                  ? Theme.of(context)
                  .colorScheme
                  .errorContainer
                  : Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Icon(
              stockBajo
                  ? Icons.warning_amber_outlined
                  : Icons.inventory_2_outlined,
              size: 32,
              color: stockBajo
                  ? Theme.of(context)
                  .colorScheme
                  .error
                  : Theme.of(context)
                  .colorScheme
                  .primary,
            ),
          ),

          const SizedBox(width: 16),

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
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _nombreSucursal(
                    inventario.sucursalId,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 8),

                Container(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: stockBajo
                        ? Theme.of(context)
                        .colorScheme
                        .errorContainer
                        : Theme.of(context)
                        .colorScheme
                        .primaryContainer,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Text(
                    stockBajo
                        ? 'Stock bajo'
                        : 'Stock normal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w600,
                      color: stockBajo
                          ? Theme.of(context)
                          .colorScheme
                          .onErrorContainer
                          : Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
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
      children: [
        Icon(
          icono,
          size: 22,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),

        const SizedBox(width: 12),

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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _estadoStock(
      BuildContext context,
      bool stockBajo,
      ) {
    return Row(
      children: [
        Icon(
          stockBajo
              ? Icons.warning_amber_outlined
              : Icons.check_circle_outline,
          size: 22,
          color: stockBajo
              ? Theme.of(context)
              .colorScheme
              .error
              : Theme.of(context)
              .colorScheme
              .primary,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            'Estado del stock',
            style: Theme.of(context)
                .textTheme
                .bodyMedium,
          ),
        ),

        Text(
          stockBajo
              ? 'Stock bajo'
              : 'Stock normal',
          style: TextStyle(
            fontWeight: FontWeight.w600,
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