import 'package:flutter/material.dart';
import 'ui/screens/cep_list_page.dart';
import 'package:provider/provider.dart';
import 'providers/cep_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      // Sem const
      providers: [
        ChangeNotifierProvider(create: (context) => CepProvider()), // Sem const
      ],
      child: const MyApp(), // const aqui, pois MyApp agora tem construtor const
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de CEPs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CepListPage(), //Agora pode por const aqui
    );
  }
}
