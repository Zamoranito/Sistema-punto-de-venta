class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String rol;
  final String sucursalId;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.sucursalId,
  });

  Usuario copyWith({
    String? id,
    String? nombre,
    String? correo,
    String? rol,
    String? sucursalId,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      rol: rol ?? this.rol,
      sucursalId: sucursalId ?? this.sucursalId,
    );
  }
}