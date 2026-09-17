import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/producto_controller.dart';
import '../../models/permiso.dart';
import '../../models/producto.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';
import 'producto_detalle_view.dart';
import 'producto_form_view.dart';

class ProductosView extends StatefulWidget {
  const ProductosView({super.key});

  @override
  State<ProductosView> createState() => _ProductosViewState();
}

class _ProductosViewState extends State<ProductosView> {
  final ProductoController _productoController = ProductoController.instancia;

  final TextEditingController _busquedaController = TextEditingController();

  List<Producto> _productos = [];

  String? _categoriaSeleccionada;
  bool? _stockBajoSeleccionado;

  @override
  void initState() {
    super.initState();

    _productos = _productoController.filtrar();

    _busquedaController.addListener(_buscarProductos);
  }

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  void _buscarProductos() {
    setState(() {
      _productos = _productoController.filtrar(
        texto: _busquedaController.text,
        categoria: _categoriaSeleccionada,
        stockBajo: _stockBajoSeleccionado,
      );
    });
  }

  void _limpiarFiltros() {
    setState(() {
      _categoriaSeleccionada = null;
      _stockBajoSeleccionado = null;

      _productos = _productoController.filtrar(
        texto: _busquedaController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final puedeCrear =
    AppController.usuario.tienePermiso(
      Permiso.crearProductos,
    );

    final puedeEditar =
    AppController.usuario.tienePermiso(
      Permiso.editarProductos,
    );

    final puedeEliminar =
    AppController.usuario.tienePermiso(
      Permiso.eliminarProductos,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            SectionTitle(
              title: 'Catálogo de productos',
              subtitle:
              'Administra los productos de la sucursal',
              actionText:
              puedeCrear ? 'Nuevo' : null,
              onAction: puedeCrear
                  ? () async {
                final productoCreado =
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ProductoFormView(),
                  ),
                );

                if (productoCreado == true) {
                  setState(() {
                    _productos = _productoController.obtenerProductos();
                  });
                }
              }
                  : null,
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _busquedaController,
              decoration: InputDecoration(
                labelText: 'Buscar producto',
                hintText: 'Código, nombre, marca o categoría',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _busquedaController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _busquedaController.clear();
                  },
                  icon: const Icon(Icons.clear),
                )
                    : null,
              ),
            ),

            const SizedBox(height: 12),

            Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _categoriaSeleccionada,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Categoría',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Todas'),
                    ),
                    ..._productoController
                        .obtenerCategorias()
                        .map(
                          (categoria) => DropdownMenuItem<String>(
                        value: categoria,
                        child: Text(categoria),
                      ),
                    ),
                  ],
                  onChanged: (valor) {
                    setState(() {
                      _categoriaSeleccionada = valor;
                    });

                    _buscarProductos();
                  },
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<bool?>(
                  initialValue: _stockBajoSeleccionado,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    prefixIcon: Icon(Icons.inventory_outlined),
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
                      _stockBajoSeleccionado = valor;
                    });

                    _buscarProductos();
                  },
                ),
              ],
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _limpiarFiltros,
                icon: const Icon(Icons.clear_all),
                label: const Text('Limpiar filtros'),
              ),
            ),

            const SizedBox(height: 20),

            if (puedeCrear)
              Padding(
                padding:
                const EdgeInsets.only(bottom: 20),
                child: AppButton(
                  text: 'Agregar producto',
                  icon: Icons.add,
                  onPressed: () async {
                    final productoCreado =
                    await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const ProductoFormView(),
                      ),
                    );

                    if (productoCreado == true) {
                      setState(() {
                        _productos = _productoController.obtenerProductos();
                      });
                    }
                  },
                ),
              ),

            if (_productos.isEmpty)
              AppCard(
                child: Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.all(24),
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
                        const Text(
                          'No se encontraron productos.',
                          textAlign: TextAlign.center,
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
                    for (int i = 0; i < _productos.length; i++) ...[
                      _ProductoItem(
                        producto: _productos[i],
                        puedeEditar: puedeEditar,
                        puedeEliminar: puedeEliminar,

                        onVerDetalle: () async {
                          final resultado =
                          await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductoDetalleView(
                                    producto: _productos[i],
                                  ),
                            ),
                          );

                          if (resultado == true) {
                            setState(() {
                              _productos =
                                  _productoController.obtenerProductos();
                            });
                          }
                        },

                        onEditar: () async {
                          final productoEditado =
                          await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductoFormView(
                                    producto: _productos[i],
                                  ),
                            ),
                          );

                          if (productoEditado == true) {
                            setState(() {
                              _productos =
                                  _productoController.obtenerProductos();
                            });
                          }
                        },

                        onEliminar: () {
                          _confirmarEliminacion(
                            _productos[i],
                          );
                        },
                      ),

                      if (i < _productos.length - 1)
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

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  Future<void> _confirmarEliminacion(
      Producto producto,
      ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar producto'),
          content: Text(
            '¿Estás seguro de que deseas eliminar '
                'el producto "${producto.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    _productoController.eliminarProducto(
      producto.id,
    );

    setState(() {
      _productos = _productoController.obtenerProductos();
    });

    _mostrarMensaje(
      'Producto eliminado correctamente.',
    );
  }


}

class _ProductoItem extends StatelessWidget {
  final Producto producto;
  final bool puedeEditar;
  final bool puedeEliminar;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final VoidCallback onVerDetalle;

  const _ProductoItem({
    required this.producto,
    required this.puedeEditar,
    required this.puedeEliminar,
    required this.onEditar,
    required this.onEliminar,
    required this.onVerDetalle,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: Theme.of(context)
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
                      producto.nombre,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${producto.codigo} • ${producto.marca}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Stock: ${producto.stock} • '
                          '\$${producto.precioVenta.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),

                    if (producto.stockBajo) ...[
                      const SizedBox(height: 4),

                      Text(
                        'Stock bajo',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (puedeEditar)
                IconButton(
                  tooltip: 'Editar',
                  onPressed: onEditar,
                  icon: const Icon(
                    Icons.edit_outlined,
                  ),
                ),

              if (puedeEliminar)
                IconButton(
                  tooltip: 'Eliminar',
                  onPressed: onEliminar,
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
