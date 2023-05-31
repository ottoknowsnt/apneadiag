import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:apneadiag/utilities/app_data.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var appData = context.watch<AppData>();
    String id = '';
    int age = 0;
    double weight = 0.0;
    int height = 0;

    var theme = Theme.of(context);
    var styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Introduzca los datos del paciente',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: styleTitle),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El ID está vacío.';
                  }
                  return null;
                },
                onSaved: (value) {
                  id = value!;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edad',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La edad está vacía.';
                  }
                  return null;
                },
                onSaved: (value) {
                  age = int.parse(value!);
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Peso (kg)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El peso está vacío.';
                  }
                  return null;
                },
                onSaved: (value) {
                  weight = double.parse(value!);
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Convert comma to dot
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return newValue.copyWith(
                      text: newValue.text.replaceAll(',', '.'),
                    );
                  }),
                  // Allow Decimal Number With Precision of 2 Only
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Altura (cm)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La altura está vacía.';
                  }
                  return null;
                },
                onSaved: (value) {
                  height = int.parse(value!);
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Confirmación',
                                textAlign: TextAlign.left, softWrap: true),
                            content: const Text('¿Desea confirmar los datos?',
                                textAlign: TextAlign.left, softWrap: true),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar',
                                    textAlign: TextAlign.center,
                                    softWrap: true),
                              ),
                              TextButton(
                                onPressed: () {
                                  _formKey.currentState!.save();
                                  appData.login(id, age, weight, height);
                                  Navigator.pop(context);
                                },
                                child: const Text('Confirmar',
                                    textAlign: TextAlign.center,
                                    softWrap: true),
                              ),
                            ],
                          );
                        },
                      ),
                    },
                },
                child: const Text('Confirmar',
                    textAlign: TextAlign.center, softWrap: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
