import '../models/producto.dart';

class ProductoController {
  static final ProductoController instancia = ProductoController._interno();

  ProductoController._interno();

  final List<Producto> _productos = [
    const Producto(
      id: 'PROD-001',
      codigo: 'LAP-001',
      nombre: 'Laptop Lenovo',
      descripcion: 'Laptop para uso general',
      categoria: 'Computación',
      marca: 'Lenovo',
      precioCompra: 12000,
      precioVenta: 15999,
      stock: 8,
      stockMinimo: 3,
      sucursalId: 'SUC-001',
      activo: true,
    ),

    const Producto(
      id: 'PROD-002',
      codigo: 'MOU-001',
      nombre: 'Mouse Logitech',
      descripcion: 'Mouse inalámbrico',
      categoria: 'Accesorios',
      marca: 'Logitech',
      precioCompra: 350,
      precioVenta: 599,
      stock: 24,
      stockMinimo: 5,
      sucursalId: 'SUC-001',
      activo: true,
    ),

    const Producto(
      id: 'PROD-003',
      codigo: 'TEC-001',
      nombre: 'Teclado Mecánico',
      descripcion: 'Teclado mecánico RGB',
      categoria: 'Accesorios',
      marca: 'Redragon',
      precioCompra: 800,
      precioVenta: 1299,
      stock: 4,
      stockMinimo: 5,
      sucursalId: 'SUC-001',
      activo: true,
    ),
  ];

  List<Producto> obtenerProductos() {
    return List.unmodifiable(
      _productos.where((producto) => producto.activo),
    );
  }

  Producto? obtenerPorId(String id) {
    for (final producto in _productos) {
      if (producto.id == id) {
        return producto;
      }
    }

    return null;
  }

  List<Producto> buscar(String texto) {
    final busqueda = texto.trim().toLowerCase();

    final productosActivos = _productos.where(
          (producto) => producto.activo,
    );

    if (busqueda.isEmpty) {
      return productosActivos.toList();
    }

    return productosActivos.where((producto) {
      return producto.codigo.toLowerCase().contains(busqueda) ||
          producto.nombre.toLowerCase().contains(busqueda) ||
          producto.marca.toLowerCase().contains(busqueda) ||
          producto.categoria.toLowerCase().contains(busqueda);
    }).toList();
  }

  List<Producto> obtenerStockBajo() {
    return _productos
        .where(
          (producto) =>
      producto.activo && producto.stockBajo,
    )
        .toList();
  }

  List<String> obtenerCategorias() {
    final categorias = _productos
        .where((producto) => producto.activo)
        .map((producto) => producto.categoria)
        .toSet()
        .toList();

    categorias.sort();

    return categorias;
  }

  List<Producto> filtrar({
    String texto = '',
    String? categoria,
    bool? stockBajo,
  }) {
    final busqueda = texto.trim().toLowerCase();

    return _productos.where((producto) {
      if (!producto.activo) {
        return false;
      }

      final coincideTexto =
          busqueda.isEmpty ||
              producto.codigo.toLowerCase().contains(busqueda) ||
              producto.nombre.toLowerCase().contains(busqueda) ||
              producto.marca.toLowerCase().contains(busqueda) ||
              producto.categoria.toLowerCase().contains(busqueda);

      final coincideCategoria =
          categoria == null ||
              categoria.isEmpty ||
              producto.categoria == categoria;

      final coincideStock =
          stockBajo == null ||
              producto.stockBajo == stockBajo;

      return coincideTexto &&
          coincideCategoria &&
          coincideStock;
    }).toList();
  }

  void agregarProducto(Producto producto) {
    _productos.add(producto);
  }

  void actualizarProducto(Producto productoActualizado) {
    final indice = _productos.indexWhere(
          (producto) => producto.id == productoActualizado.id,
    );

    if (indice == -1) {
      return;
    }

    _productos[indice] = productoActualizado;
  }

  void eliminarProducto(String id) {
    final indice = _productos.indexWhere(
          (producto) => producto.id == id,
    );

    if (indice == -1) {
      return;
    }

    _productos[indice] = _productos[indice].copyWith(
      activo: false,
    );
  }
}