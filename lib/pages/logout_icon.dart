import 'package:flutter/material.dart';
import '../authentications/google_authen.dart';
import 'package:restart_app/restart_app.dart';

class LogoutIcon extends StatefulWidget {
  const LogoutIcon({super.key});

  @override
  LogoutIconState createState() => LogoutIconState();
}

class LogoutIconState extends State<LogoutIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
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
      icon: const Icon(
        Icons.logout,
        color: Colors.red,
        size: 30,
      ),
      tooltip:
        'Logout',
    );
  }
}
