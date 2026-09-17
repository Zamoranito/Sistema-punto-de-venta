import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/permiso.dart';
import '../dashboard/dashboard_view.dart';
import '../inventario/inventario_view.dart';
import '../perfil/perfil_view.dart';
import '../productos/productos_view.dart';
import '../ventas/ventas_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  late final List<_NavigationItem> _navigationItems;

  @override
  void initState() {
    super.initState();

    _navigationItems = _crearNavegacion();
  }

  List<_NavigationItem> _crearNavegacion() {
    final items = <_NavigationItem>[];

    if (AppController.usuario.tienePermiso(
      Permiso.verDashboard,
    )) {
      items.add(
        const _NavigationItem(
          label: 'Inicio',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          view: DashboardView(),
        ),
      );
    }

    if (AppController.usuario.tienePermiso(
      Permiso.verProductos,
    )) {
      items.add(
        const _NavigationItem(
          label: 'Productos',
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2,
          view: ProductosView(),
        ),
      );
    }

    if (AppController.usuario.tienePermiso(
      Permiso.verInventario,
    )) {
      items.add(
        const _NavigationItem(
          label: 'Inventario',
          icon: Icons.warehouse_outlined,
          selectedIcon: Icons.warehouse,
          view: InventarioView(),
        ),
      );
    }

    if (AppController.usuario.tienePermiso(
      Permiso.verVentas,
    )) {
      items.add(
        const _NavigationItem(
          label: 'Ventas',
          icon: Icons.point_of_sale_outlined,
          selectedIcon: Icons.point_of_sale,
          view: VentasView(),
        ),
      );
    }

    // El perfil pertenece al usuario autenticado,
    // por lo que siempre estará disponible.
    items.add(
      const _NavigationItem(
        label: 'Perfil',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        view: PerfilView(),
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (_navigationItems.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No tienes módulos disponibles.',
          ),
        ),
      );
    }

    if (_selectedIndex >= _navigationItems.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      body: _navigationItems[_selectedIndex].view,

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navigationItems
            .map(
              (item) => NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          ),
        )
            .toList(),
      ),
    );
  }
}

class _NavigationItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget view;

  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.view,
  });
}