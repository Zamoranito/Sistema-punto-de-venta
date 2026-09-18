import 'package:flutter/material.dart';

import '../../controllers/inventario_controller.dart';
import '../../controllers/producto_controller.dart';
import '../../models/inventario.dart';
import '../../models/producto.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_title.dart';

class SeleccionarProductosView extends StatefulWidget {
  const SeleccionarProductosView({super.key});

  @override
  State<SeleccionarProductosView> createState() =>
      _SeleccionarProductosViewState();
}

class _SeleccionarProductosViewState
    extends State<SeleccionarProductosView> {
  final ProductoController _productoController =
      ProductoController.instancia;

  final InventarioController _inventarioController =
      InventarioController.instancia;

  final TextEditingController _busquedaController =
  TextEditingController();

  String _textoBusqueda = '';

  final List<Producto> _productosSeleccionados = [];

  @override
  void initState() {
    super.initState();

    _busquedaController.addListener(() {
      setState(() {
        _textoBusqueda = _busquedaController.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  List<Inventario> get _inventariosDisponibles {
    return _inventarioController.obtenerInventarios().where(
          (inventario) {
        return inventario.sucursalId == 'SUC-001' &&
            inventario.stock > 0;
      },
    ).toList();
  }

  List<_ProductoInventario> get _productos {
    final resultado = <_ProductoInventario>[];

    for (final inventario in _inventariosDisponibles) {
      final producto = _productoController.obtenerPorId(
        inventario.productoId,
      );

      if (producto == null || !producto.activo) {
        continue;
      }

      final coincide = _textoBusqueda.isEmpty ||
          producto.nombre.toLowerCase().contains(
            _textoBusqueda.toLowerCase(),
          ) ||
          producto.codigo.toLowerCase().contains(
            _textoBusqueda.toLowerCase(),
          );

      if (!coincide) {
        continue;
      }

      resultado.add(
        _ProductoInventario(
          producto: producto,
          inventario: inventario,
        ),
      );
    }

    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar productos'),
        actions: [
          IconButton(
            tooltip: 'Continuar',
            onPressed: _productosSeleccionados.isEmpty
                ? null
                : _continuar,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionTitle(
            title: 'Productos',
            subtitle:
            'Selecciona los productos que formarán parte de la venta.',
          ),

          const SizedBox(height: 20),

          AppTextField(
            controller: _busquedaController,
            label: 'Buscar producto',
            hint: 'Nombre o código',
          ),

          const SizedBox(height: 20),

          if (_productosSeleccionados.isNotEmpty)
            AppCard(
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_productosSeleccionados.length} producto(s) seleccionado(s)',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _continuar,
                    child: const Text('Continuar'),
                  ),
                ],
              ),
            ),

          if (_productosSeleccionados.isNotEmpty)
            const SizedBox(height: 20),

          if (productos.isEmpty)
            AppCard(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No se encontraron productos',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Prueba con otro nombre o código.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...productos.map(
                  (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProductoItem(
                  producto: item.producto,
                  inventario: item.inventario,
                  seleccionado:
                  _estaSeleccionado(item.producto.id),
                  onTap: () {
                    _alternarProducto(item.producto);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _estaSeleccionado(String productoId) {
    return _productosSeleccionados.any(
          (producto) => producto.id == productoId,
    );
  }

  void _alternarProducto(Producto producto) {
    setState(() {
      if (_estaSeleccionado(producto.id)) {
        _productosSeleccionados.removeWhere(
              (item) => item.id == producto.id,
        );
      } else {
        _productosSeleccionados.add(producto);
      }
    });
  }

  void _continuar() {
    Navigator.pop(
      context,
      _productosSeleccionados,
    );
  }
}

class _ProductoInventario {
  final Producto producto;
  final Inventario inventario;

  const _ProductoInventario({
    required this.producto,
    required this.inventario,
  });
}

class _ProductoItem extends StatelessWidget {
  final Producto producto;
  final Inventario inventario;
  final bool seleccionado;
  final VoidCallback onTap;

  const _ProductoItem({
    required this.producto,
    required this.inventario,
    required this.seleccionado,
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
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              seleccionado
                  ? Icons.check
                  : Icons.inventory_2_outlined,
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  producto.codigo,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),

                const SizedBox(height: 4),

                Text(
                  'Stock disponible: ${inventario.stock}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${producto.precioVenta.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Icon(
                seleccionado
                    ? Icons.check_circle
                    : Icons.add_circle_outline,
                color: seleccionado
                    ? Theme.of(context)
                    .colorScheme
                    .primary
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}