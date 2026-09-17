import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/usuario.dart';
import '../../widgets/app_card.dart';
import '../../widgets/section_title.dart';

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    final Usuario? usuario =
        AppController.usuario.usuarioActual;

    if (usuario == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No hay un usuario autenticado.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 45,
                child: Text(
                  usuario.nombre.isNotEmpty
                      ? usuario.nombre[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                usuario.nombre,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Center(
              child: Text(
                usuario.correo,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),
            ),

            const SizedBox(height: 30),

            const SectionTitle(
              title: 'Información de la cuenta',
              subtitle: 'Datos del usuario actual',
            ),

            const SizedBox(height: 16),

            AppCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.person_outline,
                    title: 'Nombre',
                    value: usuario.nombre,
                  ),
                  const Divider(height: 28),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    title: 'Correo electrónico',
                    value: usuario.correo,
                  ),
                  const Divider(height: 28),
                  _InfoRow(
                    icon: Icons.badge_outlined,
                    title: 'Rol',
                    value: _formatearRol(usuario.rol),
                  ),
                  const Divider(height: 28),
                  _InfoRow(
                    icon: Icons.store_outlined,
                    title: 'Sucursal',
                    value: usuario.sucursalId,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const SectionTitle(
              title: 'Cuenta',
              subtitle: 'Opciones disponibles',
            ),

            const SizedBox(height: 16),

            AppCard(
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'La opción de cerrar sesión se implementará posteriormente.',
                    ),
                  ),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Cerrar sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatearRol(String rol) {
    switch (rol) {
      case 'administrador':
        return 'Administrador';

      case 'encargado':
        return 'Encargado de sucursal';

      case 'vendedor':
        return 'Vendedor';

      case 'almacen':
        return 'Almacén';

      case 'consulta':
        return 'Consulta';

      default:
        return rol;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall,
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}