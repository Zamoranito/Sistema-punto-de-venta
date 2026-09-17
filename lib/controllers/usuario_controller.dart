import '../models/permiso.dart';
import '../models/rol.dart';
import '../models/usuario.dart';
import 'permiso_controller.dart';

class UsuarioController {
  Usuario? _usuarioActual;

  final PermisoController _permisoController =
  PermisoController();

  Usuario? get usuarioActual => _usuarioActual;

  bool get hayUsuarioAutenticado {
    return _usuarioActual != null;
  }

  void establecerUsuario(Usuario usuario) {
    _usuarioActual = usuario;
  }

  void cerrarSesion() {
    _usuarioActual = null;
  }

  Rol? get rolActual {
    if (_usuarioActual == null) {
      return null;
    }

    return Rol.values.firstWhere(
          (rol) => rol.name == _usuarioActual!.rol,
      orElse: () => Rol.consulta,
    );
  }

  bool tieneRol(Rol rol) {
    return rolActual == rol;
  }

  bool tienePermiso(Permiso permiso) {
    final rol = rolActual;

    if (rol == null) {
      return false;
    }

    return _permisoController.tienePermiso(
      rol: rol,
      permiso: permiso,
    );
  }
}