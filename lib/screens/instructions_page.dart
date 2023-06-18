import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text('Instrucciones de uso',
                textAlign: TextAlign.center, softWrap: true, style: styleTitle),
            const SizedBox(height: 10),
            Text('Por favor lea detenidamente las siguientes instrucciones.',
                textAlign: TextAlign.center,
                softWrap: true,
                style: styleSubtitle),
            const SizedBox(height: 30),
            FutureBuilder<String>(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/text/instructions.txt'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data as String,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: styleSubtitle);
                } else if (snapshot.hasError) {
                  return Text('Error al cargar las instrucciones',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: styleSubtitle);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
