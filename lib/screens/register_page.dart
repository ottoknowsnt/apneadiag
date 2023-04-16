import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/widgets/confirm_dialog.dart';
import 'package:apneadiag/utilities/app_data.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    String id = '';

    var theme = Theme.of(context);
    var style = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Introduzca el ID del Paciente', style: style),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ID Paciente',
              ),
              onChanged: (value) {
                id = value;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => {
                if (id.isEmpty)
                  {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('ID del Paciente Vacío'),
                        content: const Text('El ID del Paciente está vacío.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  }
                else
                  {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDialog(
                          confirmText:
                              'Ha introducido el ID de Paciente $id.\n¿Desea continuar?',
                          confirmAction: () => appData.login(id)),
                    ),
                  }
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
