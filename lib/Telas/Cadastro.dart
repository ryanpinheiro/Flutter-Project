import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nomeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função para cadastro com email e senha
  Future<void> _registerWithEmailPassword() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/Home'); // Redireciona ao home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao cadastrar: ${e.toString()}")),
      );
    }
  }

  // Função para cadastro com Google
  Future<void> _registerWithGoogle() async {
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

      // Faz o cadastro com o Google no Firebase
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, '/Home'); // Redireciona ao home
    } catch (e) {
      print('Erro ao registrar com Google: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao registrar com Google: ${e.toString()}"),
        ),
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
            // Campo de nome
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
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
            // Botão de cadastro com email e senha
            ElevatedButton(
              onPressed: _registerWithEmailPassword,
              child: Text("Cadastrar com Email"),
            ),
            SizedBox(height: 20),
            // Botão de cadastro com Google
            ElevatedButton(
              onPressed: _registerWithGoogle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/Image/ico.png', // Logo do Google
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text("Cadastrar com Google"),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Botão para redirecionar para a tela de login
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/Login'),
              child: Text("Já tem uma conta? Faça login"),
            ),
          ],
        ),
      ),
    );
  }
}
