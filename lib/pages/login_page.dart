import 'package:app_dreamtact/services/firebase_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    var payload = {
      'cedula': _cedulaController.text,
      'password': _passwordController.text
    };

    if (_formKey.currentState!.validate()) {
      try {
        bool loggedIn = await login(payload);
        if (loggedIn) {
          Navigator.pushReplacementNamed(context, '/home');
        }

        if (!loggedIn) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: const Text('La contraseña ingresada es incorrecta.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ok'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        print('Error');
        print(e);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Ocurrió un error al intentar iniciar sesión.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF0F1), // Gris Claro
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48.0),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 800,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48.0),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _cedulaController,
                      decoration: const InputDecoration(
                        labelText: 'Cédula',
                        labelStyle:
                            TextStyle(color: Color(0xFF7F8C8D)), // Gris Oscuro
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color(0xFF2C3E50)), // Azul Marino
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color(0xFF3498DB)), // Azul Claro
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu cédula';
                        }
                        // Validación básica de cédula de Ecuador (10 dígitos)
                        if (value.length != 10) {
                          return 'La cédula debe tener 10 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle:
                            TextStyle(color: Color(0xFF7F8C8D)), // Gris Oscuro
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color(0xFF2C3E50)), // Azul Marino
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color(0xFF3498DB)), // Azul Claro
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3498DB), // Azul Claro
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: const Text(
                        '¿No tienes una cuenta? Registrate',
                        style: TextStyle(
                          color: Color(0xFF2C3E50), // Azul Marino
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}
