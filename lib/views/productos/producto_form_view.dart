import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../controllers/producto_controller.dart';
import '../../models/permiso.dart';
import '../../models/producto.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/section_title.dart';

class ProductoFormView extends StatefulWidget {
  final Producto? producto;

  const ProductoFormView({
    super.key,
    this.producto,
  });

  @override
  State<ProductoFormView> createState() =>
      _ProductoFormViewState();
}

class _ProductoFormViewState extends State<ProductoFormView> {
  final ProductoController _productoController = ProductoController.instancia;

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController _codigoController =
  TextEditingController();

  final TextEditingController _nombreController =
  TextEditingController();

  final TextEditingController _descripcionController =
  TextEditingController();

  final TextEditingController _categoriaController =
  TextEditingController();

  final TextEditingController _marcaController =
  TextEditingController();

  final TextEditingController _precioCompraController =
  TextEditingController();

  final TextEditingController _precioVentaController =
  TextEditingController();

  final TextEditingController _stockController =
  TextEditingController();

  final TextEditingController _stockMinimoController =
  TextEditingController();

  bool _activo = true;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();

    final producto = widget.producto;

    if (producto != null) {
      _codigoController.text = producto.codigo;
      _nombreController.text = producto.nombre;
      _descripcionController.text =
          producto.descripcion;
      _categoriaController.text =
          producto.categoria;
      _marcaController.text = producto.marca;
      _precioCompraController.text =
          producto.precioCompra.toString();
      _precioVentaController.text =
          producto.precioVenta.toString();
      _stockController.text =
          producto.stock.toString();
      _stockMinimoController.text =
          producto.stockMinimo.toString();

      _activo = producto.activo;
    }
  }

  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    _categoriaController.dispose();
    _marcaController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _stockController.dispose();
    _stockMinimoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final puedeCrear =
    AppController.usuario.tienePermiso(
      Permiso.crearProductos,
    );

    if (!puedeCrear) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.producto == null
                ? 'Nuevo producto'
                : 'Editar producto',
          ),
        ),
        body: const Center(
          child: Text(
            'No tienes permiso para crear productos.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.producto == null
              ? 'Nuevo producto'
              : 'Editar producto',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: widget.producto == null
                    ? 'Registrar producto'
                    : 'Editar producto',
                subtitle: widget.producto == null
                    ? 'Ingresa la información del nuevo producto.'
                    : 'Modifica la información del producto.',
              ),

              const SizedBox(height: 24),

              AppTextField(
                label: 'Código',
                hint: 'Ej. AUD-001',
                controller: _codigoController,
                prefixIcon: Icons.qr_code_2,
                validator: _validarTexto,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Nombre',
                hint: 'Ej. Audífonos Bluetooth',
                controller: _nombreController,
                prefixIcon: Icons.inventory_2_outlined,
                validator: _validarTexto,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Descripción',
                hint: 'Descripción del producto',
                controller: _descripcionController,
                prefixIcon: Icons.description_outlined,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Categoría',
                hint: 'Ej. Accesorios',
                controller: _categoriaController,
                prefixIcon: Icons.category_outlined,
                validator: _validarTexto,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Marca',
                hint: 'Ej. Logitech',
                controller: _marcaController,
                prefixIcon: Icons.branding_watermark_outlined,
                validator: _validarTexto,
              ),

              const SizedBox(height: 24),

              Text(
                'Precios',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Precio de compra',
                hint: '0.00',
                controller: _precioCompraController,
                prefixIcon: Icons.attach_money,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validarPrecio,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Precio de venta',
                hint: '0.00',
                controller: _precioVentaController,
                prefixIcon: Icons.sell_outlined,
                keyboardType:
                const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: _validarPrecio,
              ),

              const SizedBox(height: 24),

              Text(
                'Inventario',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Stock inicial',
                hint: '0',
                controller: _stockController,
                prefixIcon:
                Icons.inventory_outlined,
                keyboardType:
                TextInputType.number,
                validator: _validarEntero,
              ),

              const SizedBox(height: 16),

              AppTextField(
                label: 'Stock mínimo',
                hint: '0',
                controller: _stockMinimoController,
                prefixIcon:
                Icons.warning_amber_outlined,
                keyboardType:
                TextInputType.number,
                validator: _validarEntero,
              ),

              const SizedBox(height: 20),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Producto activo',
                ),
                subtitle: const Text(
                  'El producto estará disponible en el catálogo.',
                ),
                value: _activo,
                onChanged: (value) {
                  setState(() {
                    _activo = value;
                  });
                },
              ),

              const SizedBox(height: 28),

              AppButton(
                text: widget.producto == null
                    ? 'Guardar producto'
                    : 'Guardar cambios',
                icon: Icons.save_outlined,
                loading: _guardando,
                onPressed: _guardarProducto,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validarTexto(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }

    return null;
  }

  String? _validarPrecio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa un precio';
    }

    final precio = double.tryParse(
      value.trim(),
    );

    if (precio == null) {
      return 'Ingresa un número válido';
    }

    if (precio <= 0) {
      return 'El precio debe ser mayor a 0';
    }

    return null;
  }

  String? _validarEntero(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa una cantidad';
    }

    final cantidad = int.tryParse(
      value.trim(),
    );

    if (cantidad == null) {
      return 'Ingresa un número entero';
    }

    if (cantidad < 0) {
      return 'La cantidad no puede ser negativa';
    }

    return null;
  }

  Future<void> _guardarProducto() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _guardando = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    final productoOriginal = widget.producto;

    final producto = Producto(
      id: productoOriginal?.id ??
          'PROD-${DateTime.now().millisecondsSinceEpoch}',
      codigo: _codigoController.text.trim(),
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      categoria: _categoriaController.text.trim(),
      marca: _marcaController.text.trim(),
      precioCompra: double.parse(
        _precioCompraController.text.trim(),
      ),
      precioVenta: double.parse(
        _precioVentaController.text.trim(),
      ),
      stock: int.parse(
        _stockController.text.trim(),
      ),
      stockMinimo: int.parse(
        _stockMinimoController.text.trim(),
      ),
      sucursalId:
      productoOriginal?.sucursalId ?? 'SUC-001',
      activo: _activo,
    );

    if (productoOriginal == null) {
      _productoController.agregarProducto(
        producto,
      );
    } else {
      _productoController.actualizarProducto(
        producto,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _guardando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          productoOriginal == null
              ? 'Producto creado correctamente.'
              : 'Producto actualizado correctamente.',
        ),
      ),
    );

    Navigator.pop(context, true);
  }
}
