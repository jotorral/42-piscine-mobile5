import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';
// import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'pages/welcome_page.dart';
import 'pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/pages/profile_page.dart';
import '/pages/calendar_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();	 				// Inicializar Firebase
	await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform,	// No sé si esta línea hace falta
	);
  await initializeDateFormatting('es_ES', null);
  await dotenv.load(); // Carga las variables de entorno del fichero .env que contienen datos conexión Auth0
	runApp(const MyApp());
}


class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Navegación sin stack',
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: const PantallaPrincipal(),
		);
	}
}


class PantallaPrincipal extends StatefulWidget {
	const PantallaPrincipal({super.key});

	@override
	PantallaPrincipalState createState() => PantallaPrincipalState();
}


class PantallaPrincipalState extends State<PantallaPrincipal> {
	// Controlamos el estado con un índice para cambiar el contenido
	int _currentIndex = 0;

	// Lista de pantallas que vamos a mostrar, basada en el índice
	final List<Widget> _pantallas = [
		const Welcome(),      // Pantalla 0
		const Login(),        // Pantalla 1
		const ProfilePage(),  // Pantalla 2
    const CalendarPage(),    // Pantalla 3
	];

	// Función callback para cambiar el índice desde las pantallas hijas
	void cambiarPantalla(int nuevoIndex) {
    debugPrint('cambiar pantalla lamado con nuevoIndex: $nuevoIndex');
		setState(() {
			_currentIndex = nuevoIndex;  // Cambia la pantalla según el nuevo índice
		});
	}

	@override
	Widget build(BuildContext context) {
    // Si el usurio está ya logado y quiere ir a logarse
    if (FirebaseAuth.instance.currentUser != null && _currentIndex == 1){
      //Saltarse la pantalla para logarse
      _currentIndex = 2;
    }

		return Scaffold(
			/*appBar: AppBar(title: const Text('Pantalla Principal')),*/
			body: _pantallas[_currentIndex],  // Muestra la pantalla correspondiente
/*      bottomNavigationBar: BottomNavigationBar(
				currentIndex: _currentIndex,
				onTap: (int index) {
					cambiarPantalla(index);  // Usamos el callback para cambiar la pantalla
				},
				items: const [
					BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Pantalla 1'),
					BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Pantalla 2'),
					BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Pantalla 3'),
				],
			),
*/    );
	}
}


// Pantalla 3
class Pantalla3 extends StatelessWidget {
	const Pantalla3({super.key});


	@override
	Widget build(BuildContext context) {
		return Center(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
          Text('Pág.3 - User: ${FirebaseAuth.instance.currentUser?.displayName ?? ''}', textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'DancingScript',fontSize: 24, color: Colors.black),),
					ElevatedButton(
						onPressed: () {
							// Llamamos al callback para cambiar a Pantalla 0
							(context.findAncestorStateOfType<PantallaPrincipalState>()!)
									.cambiarPantalla(0);
						},
						child: const Text('Ir a Pantalla Welcome.'),
					),
					ElevatedButton(
						onPressed: () {
							// Llamamos al callback para cambiar a Pantalla 1
							(context.findAncestorStateOfType<PantallaPrincipalState>()!)
									.cambiarPantalla(1);
						},
						child: const Text('Ir a Pantalla 1 (Log con Google/Github)'),
					),
				],
			),
		);
	}
}
