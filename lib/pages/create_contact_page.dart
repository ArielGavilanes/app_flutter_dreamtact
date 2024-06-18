import 'package:app_dreamtact/services/firebase_service.dart';
import 'package:flutter/material.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _organizacionController = TextEditingController();

  Future<void> _addContact() async {
    var contact = {
      'email': _emailController.text,
      'nombre_contacto': _nombreController.text,
      'numero': _numeroController.text.toString(),
      'organizacion': _organizacionController.text
    };

    try {
      await addContact(contact);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Añadir contacto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 48.0),
              const Center(
                child: Text(
                  'Añadir contacto',
                  style: TextStyle(
                    color: Color(0xFF2C3E50), // Azul Marino
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Contacto',
                  labelStyle:
                      TextStyle(color: Color(0xFF7F8C8D)), // Gris Oscuro
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF2C3E50), // Azul Marino
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF3498DB), // Azul Claro
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del contacto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Color(0xFF7F8C8D)), // Gris Oscuro
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF2C3E50), // Azul Marino
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF3498DB), // Azul Claro
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el email';
                  }

                  RegExp emailRegExp =
                      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                  if (!emailRegExp.hasMatch(value)) {
                    return 'Por favor ingrese un email válido';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: 'Número',
                  labelStyle:
                      TextStyle(color: Color(0xFF7F8C8D)), // Gris Oscuro
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF2C3E50), // Azul Marino
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF3498DB), // Azul Claro
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número';
                  }
                  if (value.length != 10) {
                    return 'El número debe tener exactamente 10 dígitos';
                  }
                  // Validar que el número sea de Ecuador
                  RegExp ecuadorPhoneRegExp = RegExp(r'^09[0-9]{8}$');
                  if (!ecuadorPhoneRegExp.hasMatch(value)) {
                    return 'Por favor ingrese un número de teléfono válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _organizacionController,
                decoration: const InputDecoration(
                  labelText: 'Organización',
                  labelStyle:
                      TextStyle(color: Color(0xFF7F8C8D)), // Gris Oscuro
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF2C3E50), // Azul Marino
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF3498DB), // Azul Claro
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la organizacion';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addContact();
                    Navigator.pushNamed(context, '/contacts');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contacto guardado')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3498DB), // Azul Claro
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Guardar Contacto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose de los controladores
    _emailController.dispose();
    _nombreController.dispose();
    _numeroController.dispose();
    _organizacionController.dispose();
    super.dispose();
  }
}
