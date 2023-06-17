import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../utilities/app_data.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppData appData = context.watch<AppData>();
    String id = '';
    int age = 0;
    double weight = 0;
    int height = 0;

    final ThemeData theme = Theme.of(context);
    final TextStyle styleTitle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'El ID está vacío.';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  id = value!;
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Edad',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'La edad está vacía.';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  age = int.parse(value!);
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Peso (kg)',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'El peso está vacío.';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  weight = double.parse(value!);
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  // Convert comma to dot
                  TextInputFormatter.withFunction(
                      (TextEditingValue oldValue, TextEditingValue newValue) {
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
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'La altura está vacía.';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  height = int.parse(value!);
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => <void>{
                  if (_formKey.currentState!.validate())
                    <void>{
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmación',
                                textAlign: TextAlign.left, softWrap: true),
                            content: const Text('¿Desea confirmar los datos?',
                                textAlign: TextAlign.left, softWrap: true),
                            actions: <Widget>[
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
