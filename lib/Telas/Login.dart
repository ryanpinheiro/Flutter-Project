import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para login com email e senha
  Future<void> _loginWithEmailPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/Home'); // Redireciona ao home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao entrar: ${e.toString()}")),
      );
    }
  }

  // Função para login ou cadastro com Google
  Future<void> _loginWithGoogle() async {
    try {
      // Inicia a autenticação com o Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // O usuário cancelou o login
        return;
      }

      // Autenticação com o Firebase
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Verifica se o usuário já está registrado
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Se for o primeiro login com Google, o Firebase cria a conta automaticamente
      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(
          context,
          '/Home',
        ); // Redireciona ao home após login/cadastro
      }
    } catch (e) {
      print('Erro ao logar com Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao entrar com Google: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de e-mail
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            // Campo de senha
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Botão de login com email e senha
            ElevatedButton(
              onPressed: _loginWithEmailPassword,
              child: Text("Entrar com Email"),
            ),
            SizedBox(height: 20),
            // Botão de login com Google
            ElevatedButton(
              onPressed: _loginWithGoogle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/Image/ico.png', // Logo do Google
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text("Entrar com Google"),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Botão para redirecionar para a tela de cadastro
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/Cadastro'),
              child: Text("Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}
