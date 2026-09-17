import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'config/app_theme.dart';
//import 'views/shared/app_shell.dart';
import 'views/login/login_view.dart';

void main() {
  runApp(const PuntoVentaApp());
}

class PuntoVentaApp extends StatelessWidget {
  const PuntoVentaApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: AppConfig.appName,

      theme: AppTheme.lightTheme,

      //home: const AppShell(),
      home: const LoginView(),
    );
  }
}




/*
import 'package:flutter/material.dart';

void main() {
  runApp(const PuntoVentaApp());
}

class PuntoVentaApp extends StatelessWidget {
  const PuntoVentaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Punto de Venta',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardView(),
    ProductosView(),
    InventarioView(),
    VentasView(),
    PerfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),

          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),

          NavigationDestination(
            icon: Icon(Icons.warehouse_outlined),
            selectedIcon: Icon(Icons.warehouse),
            label: 'Inventario',
          ),

          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Ventas',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}


class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Punto de Venta',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'Resumen de operaciones',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Ventas',
                    value: '\$12,450',
                    icon: Icons.attach_money,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _StatCard(
                    title: 'Productos',
                    value: '248',
                    icon: Icons.inventory_2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Pedidos',
                    value: '12',
                    icon: Icons.shopping_cart,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _StatCard(
                    title: 'Stock bajo',
                    value: '8',
                    icon: Icons.warning_amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Acciones rápidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _ActionButton(
              icon: Icons.point_of_sale,
              title: 'Nueva venta',
              subtitle: 'Registrar una venta',
              onTap: () {},
            ),

            _ActionButton(
              icon: Icons.inventory,
              title: 'Consultar inventario',
              subtitle: 'Revisar existencias',
              onTap: () {},
            ),

            _ActionButton(
              icon: Icons.local_shipping,
              title: 'Transferencia',
              subtitle: 'Enviar productos a otra sucursal',
              onTap: () {},
            ),

            const SizedBox(height: 30),

            const Text(
              'Productos con stock bajo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            _LowStockItem(
              product: 'Cable HDMI 2.0',
              stock: 2,
            ),

            _LowStockItem(
              product: 'Cargador USB-C',
              stock: 3,
            ),

            _LowStockItem(
              product: 'Adaptador HDMI',
              stock: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 30,
            ),

            const SizedBox(height: 15),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),

        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(subtitle),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),

        onTap: onTap,
      ),
    );
  }
}

class _LowStockItem extends StatelessWidget {
  final String product;
  final int stock;

  const _LowStockItem({
    required this.product,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.warning_amber,
        ),

        title: Text(product),

        subtitle: Text(
          'Existencias: $stock',
        ),

        trailing: const Text(
          'Stock bajo',
        ),
      ),
    );
  }
}

class ProductosView extends StatelessWidget {
  const ProductosView({super.key});

  final List<Map<String, dynamic>> productos = const [
    {
      'codigo': 'PROD-001',
      'nombre': 'ESP32',
      'categoria': 'Microcontroladores',
      'precio': 185.00,
      'stock': 18,
    },
    {
      'codigo': 'PROD-002',
      'nombre': 'Arduino UNO',
      'categoria': 'Microcontroladores',
      'precio': 250.00,
      'stock': 12,
    },
    {
      'codigo': 'PROD-003',
      'nombre': 'Cable HDMI',
      'categoria': 'Cables',
      'precio': 120.00,
      'stock': 5,
    },
    {
      'codigo': 'PROD-004',
      'nombre': 'Cargador USB-C',
      'categoria': 'Accesorios',
      'precio': 280.00,
      'stock': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Productos',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: productos.length,
              itemBuilder: (context, index) {

                final producto = productos[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${index + 1}',
                      ),
                    ),

                    title: Text(
                      producto['nombre'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '${producto['codigo']} • '
                          '${producto['categoria']}\n'
                          'Stock: ${producto['stock']}',
                    ),

                    isThreeLine: true,

                    trailing: Text(
                      '\$${producto['precio']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InventarioView extends StatelessWidget {
  const InventarioView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Inventario',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Control de existencias',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.store,
                ),

                title: const Text(
                  'Sucursal Tec',
                ),

                subtitle: const Text(
                  '248 productos registrados',
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.warning_amber,
                ),

                title: const Text(
                  'Productos con stock bajo',
                ),

                subtitle: const Text(
                  '8 productos necesitan atención',
                ),

                trailing: const Text(
                  '8',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Últimos movimientos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const ListTile(
              leading: Icon(
                Icons.arrow_downward,
              ),

              title: Text(
                'Entrada de mercancía',
              ),

              subtitle: Text(
                'ESP32 • +20 unidades',
              ),
            ),

            const ListTile(
              leading: Icon(
                Icons.arrow_upward,
              ),

              title: Text(
                'Salida por venta',
              ),

              subtitle: Text(
                'Arduino UNO • -2 unidades',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VentasView extends StatelessWidget {
  const VentasView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Ventas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_shopping_cart,
                ),
                label: const Text(
                  'Nueva venta',
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Ventas recientes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.receipt_long,
                  ),
                ),

                title: Text(
                  'Venta #000125',
                ),

                subtitle: Text(
                  '03/09/2026 • 3 productos',
                ),

                trailing: Text(
                  '\$1,250.00',
                ),
              ),
            ),

            const Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    Icons.receipt_long,
                  ),
                ),

                title: Text(
                  'Venta #000124',
                ),

                subtitle: Text(
                  '03/09/2026 • 2 productos',
                ),

                trailing: Text(
                  '\$580.00',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerfilView extends StatelessWidget {
  const PerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Perfil',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const Center(
              child: CircleAvatar(
                radius: 45,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Administrador',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Center(
              child: Text(
                'admin@puntoventa.com',
              ),
            ),

            const SizedBox(height: 30),

            const ListTile(
              leading: Icon(
                Icons.store,
              ),
              title: Text(
                'Sucursal',
              ),
              subtitle: Text(
                'Sucursal Tec',
              ),
            ),

            const ListTile(
              leading: Icon(
                Icons.badge,
              ),
              title: Text(
                'Rol',
              ),
              subtitle: Text(
                'Administrador',
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text(
                'Cerrar sesión',
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}


*/