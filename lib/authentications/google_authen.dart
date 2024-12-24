import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:piscine_mobile_4/main.dart';
import '/utils/firebase_service.dart';

//export 'google_authen.dart' show firebaseAuth, googleSignIn;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();


class GoogleAuthen extends StatefulWidget {
  const GoogleAuthen({super.key});

  @override
  State<GoogleAuthen> createState() => _GoogleAuthenState();
}

class _GoogleAuthenState extends State<GoogleAuthen> {


  String? userName = '';

  Future<void> signInWithGoogle() async {
    if (firebaseAuth.currentUser != null) {
      userName = firebaseAuth.currentUser?.displayName;
      debugPrint('Usuario logueado: $userName');

      // final notes = await getNotes();
      // debugPrint('Personas obtenidas: $notes');

      (context.findAncestorStateOfType<PantallaPrincipalState>()!)
          .cambiarPantalla(2);



    } else {
      try {
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn(); //await googleSignIn.signOut();
        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleSignInAuthentication =
              await googleSignInAccount.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );
          await firebaseAuth.signInWithCredential(credential);

          if (firebaseAuth.currentUser?.displayName != null) {
            userName = firebaseAuth.currentUser?.displayName;
            debugPrint(userName);
            final userEmail = firebaseAuth.currentUser?.email;
            debugPrint(userEmail);
          }

          final notes = await getNotes();
          debugPrint('Personas obtenidas: $notes');

          if (mounted) {
            (context.findAncestorStateOfType<PantallaPrincipalState>()!)
                .cambiarPantalla(2);
          }
//        Navigator.push(context, MaterialPageRoute(builder:(context) => HomeScreen2(),));
        }
      } catch (e) {
        String errorMessage;
        if (e is FirebaseAuthException){
          switch (e.code){
            case 'network-request-failed':
              errorMessage = 'No hay conexión a internet.';
              break;
            case 'user-disabled':
              errorMessage = 'La cuenta está deshabilitada.';
              break;
            default:
              errorMessage = 'Error de autenticación: ${e.message}';
          }
        } else {
          errorMessage = 'Ocurrió un error inesperado.';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: ElevatedButton(
          onPressed: signInWithGoogle,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
            padding: const EdgeInsets.symmetric(horizontal:16),
          ),
      //        child: const Text('Iniciar sesión con Google'));
            child: Row(
              children: <Widget>[
                Image.asset('assets/images/google_logo.png', height: 24),
                const SizedBox(width:8),
                const Text('Continuar con Google')
              ]
            )
      ),
    );
  }
}
