import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/permission_manager.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PermissionManager permissionManager =
        context.watch<PermissionManager>();
    final bool micPermissionGranted = permissionManager.micPermissionGranted;
    final bool notificationPermissionGranted =
        permissionManager.notificationPermissionGranted;
    final bool ignoreBatteryOptimizationsGranted =
        permissionManager.ignoreBatteryOptimizationsGranted;
    final bool allPermissionsGranted = permissionManager.allPermissionsGranted;

    final ThemeData theme = Theme.of(context);
    final TextStyle styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );
    final TextStyle styleSubtitle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Conceda los siguientes permisos',
                textAlign: TextAlign.center, softWrap: true, style: styleTitle),
            const SizedBox(height: 30),
            Text(
                'Pulse en cada botón para conceder cada permiso \n'
                'Si el botón está desactivado, el permiso ya está concedido',
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
            Text(
                'Si se le presentan varias opciones, seleccione "Siempre" o '
                '"Mientras se usa la aplicación"',
                textAlign: TextAlign.center,
                softWrap: true,
                style: styleSubtitle),
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
            Text(
                'Si se le presentan varias opciones, seleccione '
                '"Sin restricciones"',
                textAlign: TextAlign.center,
                softWrap: true,
                style: styleSubtitle),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
