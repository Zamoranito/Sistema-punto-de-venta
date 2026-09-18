import 'package:flutter/material.dart';

import '../../controllers/app_controller.dart';
import '../../models/usuario.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_button.dart';
import '../../widgets/section_title.dart';
import 'seleccionar_productos_view.dart';
import '../../models/producto.dart';

class NuevaVentaView extends StatefulWidget {
  const NuevaVentaView({super.key});

  @override
  State<NuevaVentaView> createState() => _NuevaVentaViewState();
}

class _NuevaVentaViewState extends State<NuevaVentaView> {
  String _metodoPago = 'efectivo';

  Usuario? get _usuario {
    return AppController.usuario.usuarioActual;
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva venta'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SectionTitle(
            title: 'Nueva venta',
            subtitle:
            'Configura la venta antes de agregar productos.',
          ),

          const SizedBox(height: 24),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Información de la venta',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                _dato(
                  context,
                  'Usuario',
                  usuario?.nombre ?? 'No identificado',
                ),

                const SizedBox(height: 12),

                _dato(
                  context,
                  'Sucursal',
                  _nombreSucursal(
                    usuario?.sucursalId ?? '',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Método de pago',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _metodoPago,
                  decoration: const InputDecoration(
                    labelText: 'Método de pago',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'efectivo',
                      child: Text('Efectivo'),
                    ),
                    DropdownMenuItem(
                      value: 'tarjeta',
                      child: Text('Tarjeta'),
                    ),
                    DropdownMenuItem(
                      value: 'transferencia',
                      child: Text('Transferencia'),
                    ),
                  ],
                  onChanged: (valor) {
                    if (valor == null) return;

                    setState(() {
                      _metodoPago = valor;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          AppButton(
            text: 'Continuar',
            icon: Icons.arrow_forward,
            onPressed: _continuar,
          ),
        ],
      ),
    );
  }

  Future<void> _continuar() async {
    final productosSeleccionados =
    await Navigator.push<List<Producto>>(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const SeleccionarProductosView(),
      ),
    );

    if (!mounted) return;

    if (productosSeleccionados == null ||
        productosSeleccionados.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${productosSeleccionados.length} producto(s) seleccionado(s).',
        ),
      ),
    );
  }

  Widget _dato(
      BuildContext context,
      String titulo,
      String valor,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            titulo,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            valor,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _nombreSucursal(String sucursalId) {
    switch (sucursalId) {
      case 'SUC-001':
        return 'Sucursal Norte';

      case 'SUC-002':
        return 'Sucursal Sur';

      case 'SUC-003':
        return 'Sucursal Centro';

      default:
        return sucursalId.isEmpty
            ? 'No identificada'
            : sucursalId;
    }
  }
}