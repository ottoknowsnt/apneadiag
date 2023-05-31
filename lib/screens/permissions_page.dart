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

    var theme = Theme.of(context);
    var styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    var styleSubtitle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Conceda los siguientes permisos',
                textAlign: TextAlign.center, softWrap: true, style: styleTitle),
            const SizedBox(height: 30),
            Text(
                'Pulse en cada botón para conceder cada permiso \nSi el botón está desactivado, el permiso ya está concedido',
                textAlign: TextAlign.center,
                softWrap: true,
                style: styleSubtitle),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: micPermissionGranted
                  ? null
                  : () async {
                      await permissionManager.requestMicPermission();
                    },
              child: const Text(
                'Permitir acceso al micrófono',
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: notificationPermissionGranted
                  ? null
                  : () async {
                      await permissionManager.requestNotificationPermission();
                    },
              child: const Text('Permitir notificaciones',
                  textAlign: TextAlign.center, softWrap: true),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: ignoreBatteryOptimizationsGranted
                  ? null
                  : () async {
                      await permissionManager
                          .requestIgnoreBatteryOptimizations();
                    },
              child: const Text('Desactivar optimización de batería',
                  textAlign: TextAlign.center, softWrap: true),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  allPermissionsGranted ? Icons.check : Icons.close,
                  color: allPermissionsGranted ? Colors.green : Colors.red,
                ),
                Flexible(
                  child: Text(
                      allPermissionsGranted
                          ? 'Todos los permisos concedidos, puede continuar'
                          : 'Faltan permisos por conceder, no puede continuar',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: styleSubtitle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
