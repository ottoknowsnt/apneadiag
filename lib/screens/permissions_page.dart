import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/permission_manager.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var permissionManager = context.watch<PermissionManager>();
    var micPermissionGranted = permissionManager.micPermissionGranted;
    var notificationPermissionGranted =
        permissionManager.notificationPermissionGranted;
    var ignoreBatteryOptimizationsGranted =
        permissionManager.ignoreBatteryOptimizationsGranted;
    var allPermissionsGranted = permissionManager.allPermissionsGranted;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Permisos'),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: micPermissionGranted
                ? null
                : () async {
                    await permissionManager.requestMicPermission();
                  },
            child: const Text('Permitir acceso al micrófono'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: notificationPermissionGranted
                ? null
                : () async {
                    await permissionManager.requestNotificationPermission();
                  },
            child: const Text('Permitir notificaciones'),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: ignoreBatteryOptimizationsGranted
                ? null
                : () async {
                    await permissionManager.requestIgnoreBatteryOptimizations();
                  },
            child: const Text('Desactivar optimización de batería'),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                allPermissionsGranted ? Icons.check : Icons.close,
                color: allPermissionsGranted ? Colors.green : Colors.red,
              ),
              Text(allPermissionsGranted
                  ? 'Todos los permisos concedidos, puede continuar'
                  : 'Faltan permisos por conceder, no puede continuar'),
            ],
          ),
        ],
      ),
    );
  }
}
