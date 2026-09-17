import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/permiso.dart';
import '../../models/usuario.dart';
import '../../widgets/app_card.dart';
import '../../widgets/info_card.dart';
import '../../widgets/section_title.dart';
import '../inventario/inventario_view.dart';
import '../productos/productos_view.dart';
import '../ventas/ventas_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

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

    final puedeCrearVentas =
    AppController.usuario.tienePermiso(
      Permiso.crearVentas,
    );

    final puedeCrearProductos =
    AppController.usuario.tienePermiso(
      Permiso.crearProductos,
    );

    final puedeCrearTransferencias =
    AppController.usuario.tienePermiso(
      Permiso.crearTransferencias,
    );

    final puedeModificarInventario =
    AppController.usuario.tienePermiso(
      Permiso.modificarInventario,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Bienvenida(
              usuario: usuario,
            ),

            const SizedBox(height: 28),

            const SectionTitle(
              title: 'Resumen',
              subtitle:
              'Información general de la sucursal',
            ),

            const SizedBox(height: 16),

            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.15,
              children: [
                InfoCard(
                  title: 'Ventas de hoy',
                  value: '\$12,450',
                  icon: Icons.point_of_sale_outlined,
                  onTap: () {
                    _navegarA(
                      context,
                      const VentasView(),
                    );
                  },
                ),

                InfoCard(
                  title: 'Productos',
                  value: '248',
                  icon: Icons.inventory_2_outlined,
                  onTap: () {
                    _navegarA(
                      context,
                      const ProductosView(),
                    );
                  },
                ),

                InfoCard(
                  title: 'Stock bajo',
                  value: '12',
                  icon: Icons.warning_amber_outlined,
                  onTap: () {
                    _navegarA(
                      context,
                      const InventarioView(),
                    );
                  },
                ),

                InfoCard(
                  title: 'Pedidos',
                  value: '8',
                  icon: Icons.shopping_cart_outlined,
                  onTap: () {
                    _mostrarMensaje(
                      context,
                      'Módulo de pedidos próximamente.',
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 28),

            const SectionTitle(
              title: 'Acciones rápidas',
              subtitle:
              'Accede rápidamente a las operaciones disponibles',
            ),

            const SizedBox(height: 16),

            AppCard(
              child: Column(
                children: [
                  if (puedeCrearVentas)
                    _AccionRapida(
                      icon: Icons.point_of_sale_outlined,
                      titulo: 'Nueva venta',
                      descripcion:
                      'Registrar una nueva venta',
                      onTap: () {
                        _navegarA(
                          context,
                          const VentasView(),
                        );
                      },
                    ),

                  if (puedeCrearProductos)
                    _AccionRapida(
                      icon: Icons.add_box_outlined,
                      titulo: 'Agregar producto',
                      descripcion:
                      'Registrar un nuevo producto',
                      onTap: () {
                        _navegarA(
                          context,
                          const ProductosView(),
                        );
                      },
                    ),

                  if (puedeModificarInventario)
                    _AccionRapida(
                      icon: Icons.warehouse_outlined,
                      titulo: 'Gestionar inventario',
                      descripcion:
                      'Actualizar existencias',
                      onTap: () {
                        _navegarA(
                          context,
                          const InventarioView(),
                        );
                      },
                    ),

                  if (puedeCrearTransferencias)
                    _AccionRapida(
                      icon: Icons.swap_horiz_outlined,
                      titulo: 'Transferencia',
                      descripcion:
                      'Transferir productos entre sucursales',
                      onTap: () {
                        _mostrarMensaje(
                          context,
                          'Transferencias próximamente.',
                        );
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const SectionTitle(
              title: 'Actividad reciente',
              subtitle:
              'Últimas operaciones realizadas',
            ),

            const SizedBox(height: 16),

            AppCard(
              child: Column(
                children: [
                  _ActividadItem(
                    icon: Icons.point_of_sale_outlined,
                    titulo: 'Venta registrada',
                    descripcion:
                    'Venta #V-001',
                    valor: '\$1,299.00',
                  ),

                  const Divider(),

                  _ActividadItem(
                    icon: Icons.point_of_sale_outlined,
                    titulo: 'Venta registrada',
                    descripcion:
                    'Venta #V-002',
                    valor: '\$599.00',
                  ),

                  const Divider(),

                  _ActividadItem(
                    icon: Icons.inventory_2_outlined,
                    titulo: 'Producto actualizado',
                    descripcion:
                    'Mouse Logitech',
                    valor: 'Stock: 24',
                  ),

                  const Divider(),

                  _ActividadItem(
                    icon: Icons.swap_horiz_outlined,
                    titulo: 'Transferencia',
                    descripcion:
                    'SUC-002 → SUC-001',
                    valor: '5 productos',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navegarA(
      BuildContext context,
      Widget vista,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => vista,
      ),
    );
  }

  void _mostrarMensaje(
      BuildContext context,
      String mensaje,
      ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }
}

class _Bienvenida extends StatelessWidget {
  final Usuario usuario;

  const _Bienvenida({
    required this.usuario,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            child: Text(
              usuario.nombre.isNotEmpty
                  ? usuario.nombre[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  usuario.nombre,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Sucursal ${usuario.sucursalId}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccionRapida extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  const _AccionRapida({
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Icon(icon),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(descripcion),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: onTap,
    );
  }
}

class _ActividadItem extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descripcion;
  final String valor;

  const _ActividadItem({
    required this.icon,
    required this.titulo,
    required this.descripcion,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        child: Icon(icon),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(descripcion),
      trailing: Text(
        valor,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}