import '../models/permiso.dart';
import '../models/rol.dart';

class PermisoController {
  bool tienePermiso({
    required Rol rol,
    required Permiso permiso,
  }) {
    switch (rol) {
      case Rol.administrador:
        return true;

      case Rol.encargado:
        return _permisosEncargado.contains(permiso);

      case Rol.vendedor:
        return _permisosVendedor.contains(permiso);

      case Rol.almacen:
        return _permisosAlmacen.contains(permiso);

      case Rol.consulta:
        return _permisosConsulta.contains(permiso);
    }
  }

  static const Set<Permiso> _permisosEncargado = {
    Permiso.verDashboard,
    Permiso.verProductos,
    Permiso.crearProductos,
    Permiso.editarProductos,
    Permiso.verInventario,
    Permiso.modificarInventario,
    Permiso.verVentas,
    Permiso.crearVentas,
    Permiso.cancelarVentas,
    Permiso.verTransferencias,
    Permiso.crearTransferencias,
    Permiso.verPedidos,
    Permiso.crearPedidos,
    Permiso.verPrestamos,
  };

  static const Set<Permiso> _permisosVendedor = {
    Permiso.verDashboard,
    Permiso.verProductos,
    Permiso.verInventario,
    Permiso.verVentas,
    Permiso.crearVentas,
    Permiso.verPedidos,
  };

  static const Set<Permiso> _permisosAlmacen = {
    Permiso.verDashboard,
    Permiso.verProductos,
    Permiso.verInventario,
    Permiso.modificarInventario,
    Permiso.verTransferencias,
    Permiso.crearTransferencias,
    Permiso.verPedidos,
    Permiso.crearPedidos,
    Permiso.verPrestamos,
  };

  static const Set<Permiso> _permisosConsulta = {
    Permiso.verDashboard,
    Permiso.verProductos,
    Permiso.verInventario,
    Permiso.verVentas,
    Permiso.verPedidos,
  };
}