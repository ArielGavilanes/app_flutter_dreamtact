import 'package:app_dreamtact/services/firebase_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _urlPerfilController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _cedulaController.dispose();
    _passwordController.dispose();
    _urlPerfilController.dispose();
    super.dispose();
  }

  bool _validarCedulaEcuatoriana(String cedula) {
    if (cedula.length != 10 || !RegExp(r'^\d+$').hasMatch(cedula)) {
      return false;
    }

    int provincia = int.parse(cedula.substring(0, 2));
    if (provincia < 1 || provincia > 24) {
      return false;
    }

    int tercerDigito = int.parse(cedula.substring(2, 3));
    if (tercerDigito < 0 || tercerDigito > 6) {
      return false;
    }

    List<int> coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
    int suma = 0;

    for (int i = 0; i < 9; i++) {
      int valor = int.parse(cedula[i]) * coeficientes[i];
      if (valor > 9) {
        valor -= 9;
      }
      suma += valor;
    }

    int digitoVerificador = (10 - (suma % 10)) % 10;
    return digitoVerificador == int.parse(cedula[9]);
  }

  Future<void> _register() async {
    var user = {
      'cedula': _cedulaController.text,
      'nombre': _nombreController.text,
      'contrasena': _passwordController.text,
      'apellido': _apellidoController.text,
      'url_perfil': _urlPerfilController.text
    };

    await register(user);
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
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
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
                        if (value.length != 10) {
                          return 'La cédula debe tener exactamente 10 dígitos';
                        }
                        if (!_validarCedulaEcuatoriana(value)) {
                          return 'Cédula no válida';
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _urlPerfilController,
                      decoration: const InputDecoration(
                        labelText: 'Foto de perfil',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la url de tu foto de perfil';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _register();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3498DB), // Azul Claro
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Registrarse',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        '¿Ya tienes una cuenta? Inicia sesión',
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
