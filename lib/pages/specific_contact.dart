import 'package:flutter/material.dart';
import 'package:app_dreamtact/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_dreamtact/components/custom_drawer.dart';

class SpecificContactPage extends StatefulWidget {
  final String id;

  const SpecificContactPage({super.key, required this.id});

  @override
  State<SpecificContactPage> createState() => _SpecificContactPageState();
}

class _SpecificContactPageState extends State<SpecificContactPage> {
  Map<String, dynamic>? _contactData;

  final TextEditingController nombreController =
      TextEditingController(); // Controlador para nombre
  final TextEditingController organizacionController =
      TextEditingController(); // Controlador para organización
  final TextEditingController numeroController =
      TextEditingController(); // Controlador para número
  final TextEditingController emailController =
      TextEditingController(); // Controlador para email

  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // GlobalKey para el formulario

  @override
  void initState() {
    super.initState();
    // Cargar datos del contacto al iniciar la página
    loadContactData();
  }

  Future<void> loadContactData() async {
    try {
      var contactSnapshot = await getSpecificContact(widget.id);
      if (contactSnapshot.docs.isNotEmpty) {
        setState(() {
          _contactData = contactSnapshot.docs.first.data();
          // Actualizar los valores de los controladores con los datos del contacto
          nombreController.text = _contactData!['nombre_contacto'];
          organizacionController.text = _contactData!['organizacion'];
          numeroController.text = _contactData!['numero'];
          emailController.text = _contactData!['email'];
        });
      } else {
        // Manejar caso donde no se encontró el contacto
        print('No se encontró el contacto con ID: ${widget.id}');
      }
    } catch (e) {
      print('Error al obtener el contacto: $e');
    }
  }

  Future<void> _updateContact() async {
    var contact = {
      'nombre_contacto': nombreController.text,
      'organizacion': organizacionController.text,
      'numero': numeroController.text.toString(),
      'email': emailController.text,
    };

    try {
      await updateContact(widget.id, contact);
      print('Contacto actualizado correctamente.');
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/contacts');
    } catch (e) {
      print('Error al actualizar el contacto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del contacto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _contactData != null
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _contactData!['nombre_contacto'],
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50), // Azul Marino
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.business),
                          title: const Text(
                            'Organización',
                            style: TextStyle(
                              fontSize: 23,
                              color: Color(0xFF7F8C8D), // Gris Oscuro
                            ),
                          ),
                          subtitle: Text(
                            _contactData!['organizacion'],
                            style: const TextStyle(
                              fontSize: 23,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text(
                            'Teléfono',
                            style: TextStyle(
                              fontSize: 23,
                              color: Color(0xFF7F8C8D), // Gris Oscuro
                            ),
                          ),
                          subtitle: Text(
                            _contactData!['numero'],
                            style: const TextStyle(
                              fontSize: 23,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: const Text(
                            'Correo electrónico',
                            style: TextStyle(
                              fontSize: 23,
                              color: Color(0xFF7F8C8D), // Gris Oscuro
                            ),
                          ),
                          subtitle: Text(
                            _contactData!['email'],
                            style: const TextStyle(
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFECF0F1), // Gris Claro
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _openFormModal,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteContact,
            ),
          ],
        ),
      ),
    );
  }

  void _openFormModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Editar Contacto',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: organizacionController,
                  decoration: const InputDecoration(
                    labelText: 'Organización',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la organización';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: numeroController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el número';
                    }
                    if (value.length != 10) {
                      return 'El número debe tener exactamente 10 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el correo electrónico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _updateContact();
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteContact() {
    deleteContact(widget.id);
    Navigator.pushNamed(context, '/contacts');
  }

  @override
  void dispose() {
    // Dispose los controladores al salir de la pantalla para evitar memory leaks
    nombreController.dispose();
    organizacionController.dispose();
    numeroController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
