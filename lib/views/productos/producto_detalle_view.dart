import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/permiso.dart';
import '../../models/producto.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';
import 'producto_form_view.dart';

class ProductoDetalleView extends StatelessWidget {
  final Producto producto;

  const ProductoDetalleView({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    final puedeEditar =
    AppController.usuario.tienePermiso(
      Permiso.editarProductos,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del producto'),
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
              title: 'Información',
              subtitle:
              'Datos generales del producto.',
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  _dato(
                    context,
                    'Código',
                    producto.codigo,
                    Icons.qr_code_2_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Categoría',
                    producto.categoria,
                    Icons.category_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Marca',
                    producto.marca,
                    Icons.business_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SectionTitle(
              title: 'Inventario',
              subtitle:
              'Existencias y nivel mínimo.',
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  _dato(
                    context,
                    'Stock actual',
                    '${producto.stock} unidades',
                    Icons.inventory_2_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Stock mínimo',
                    '${producto.stockMinimo} unidades',
                    Icons.warning_amber_outlined,
                  ),
                  const Divider(),
                  _estadoStock(context),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SectionTitle(
              title: 'Precios',
              subtitle:
              'Información comercial del producto.',
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  _dato(
                    context,
                    'Precio de compra',
                    '\$${producto.precioCompra.toStringAsFixed(2)}',
                    Icons.shopping_cart_outlined,
                  ),
                  const Divider(),
                  _dato(
                    context,
                    'Precio de venta',
                    '\$${producto.precioVenta.toStringAsFixed(2)}',
                    Icons.sell_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SectionTitle(
              title: 'Descripción',
            ),

            const SizedBox(height: 12),

            AppCard(
              child: Text(
                producto.descripcion.isEmpty
                    ? 'Sin descripción.'
                    : producto.descripcion,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ),

            const SizedBox(height: 24),

            if (puedeEditar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final actualizado =
                    await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductoFormView(
                              producto: producto,
                            ),
                      ),
                    );

                    if (actualizado == true &&
                        context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                  ),
                  label: const Text(
                    'Editar producto',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _encabezado(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer,
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 32,
              color: Theme.of(context)
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
                  producto.nombre,
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
                  producto.codigo,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 8),

                _estadoProducto(context),
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

  Widget _estadoStock(BuildContext context) {
    final stockBajo = producto.stockBajo;

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

  Widget _estadoProducto(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: producto.activo
            ? Theme.of(context)
            .colorScheme
            .primaryContainer
            : Theme.of(context)
            .colorScheme
            .errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        producto.activo
            ? 'Producto activo'
            : 'Producto inactivo',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: producto.activo
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