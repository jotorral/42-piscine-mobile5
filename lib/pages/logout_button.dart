import 'package:flutter/material.dart';
import '../authentications/google_authen.dart';
import 'package:restart_app/restart_app.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  LogoutButtonState createState() => LogoutButtonState();
}

class LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Realiza el logout de Firebase forma asíncrona
        await firebaseAuth.signOut();
//        await FirebaseAuth.instance.signOut(); // Redundante quitable. En este caso se crea una nueva instancia
        
//        await FirebaseAuth.instance.signOut();
        final currentFirebaseUser = firebaseAuth.currentUser;
        if (currentFirebaseUser == null){
          debugPrint("Usuario desautenticado)");
        } else{
          debugPrint("Sesión no cerrada correctamente");
        }
        // Realiza el logout de Google de forma asíncrona
        await googleSignIn.signOut();
//        await GoogleSignIn().signOut(); // Redundante quitable. En este caso se crea una nueva instancia

        // Forzar el cierre de la aplicación, primero reiniciando.
        Restart.restartApp();
//        exit(0);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 85, 85),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text(
        '    Logout     ',
        style: TextStyle(fontFamily: 'DancingScript', color: Colors.white, fontSize: 22),
      ),
    );
  }
}
