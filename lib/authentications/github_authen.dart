import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piscine_mobile_4/main.dart';

class GithubAuthentication extends StatefulWidget{
	const GithubAuthentication({super.key});

	@override
	State<GithubAuthentication> createState() => _GithubAuthenticationState();
}

class _GithubAuthenticationState extends State<GithubAuthentication> with Func{
	@override
	Widget build(BuildContext context){
		return Container(
			padding: const EdgeInsets.only(top:10),
			height: 60,
			child: SizedBox( width: MediaQuery.of(context).size.width,
			child: SignInButton(
				Buttons.GitHub,
				onPressed:() async {
					try {
						UserCredential userCredential = await signInWithGithub();
						if(context.mounted){
				            (context.findAncestorStateOfType<PantallaPrincipalState>()!)
                				.cambiarPantalla(2);
							
						}
					} catch (e){
						debugPrint(e.toString());
					}
				},
			))
		);
	}
	Future<UserCredential> signInWithGithub() async {
		GithubAuthProvider githubAuthProvider = GithubAuthProvider();
		return await FirebaseAuth.instance.signInWithProvider(githubAuthProvider);
	}
}


Future<UserCredential> signInWithGitHub() async {
	// Create a new provider
	GithubAuthProvider githubProvider = GithubAuthProvider();

	return await FirebaseAuth.instance.signInWithProvider(githubProvider);
}

mixin Func {
  void callCustomStatusAlert(BuildContext context, String message, bool isSuccess) {
    final color = isSuccess ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
