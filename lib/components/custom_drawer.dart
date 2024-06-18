import 'package:app_dreamtact/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No se encontró información de perfil.');
        }

        Map<String, dynamic> userData = snapshot.data!.docs.first.data();
        String nombre = userData['nombre'] ?? '';
        String apellido = userData['apellido'] ?? '';
        String email = userData['email'] ?? '';
        String imageUrl = userData['url_perfil'] ?? 'images/profile.png';

        return Drawer(
          child: ListView(
            children: [
              Container(
                color: const Color(0xFF2C3E50), // Color Azul Marino
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 30,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$nombre $apellido",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle,
                    color: Color(0xFF2C3E50)), // Icono Azul Marino
                title: const Text('Perfil',
                    style: TextStyle(
                        color: Color(0xFF2C3E50))), // Texto Azul Marino
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.home,
                    color: Color(0xFF2C3E50)), // Icono Azul Marino
                title: const Text('Inicio',
                    style: TextStyle(
                        color: Color(0xFF2C3E50))), // Texto Azul Marino
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload,
                    color: Color(0xFF2C3E50)), // Icono Azul Marino
                title: const Text('Contactos',
                    style: TextStyle(
                        color: Color(0xFF2C3E50))), // Texto Azul Marino
                onTap: () {
                  Navigator.pushNamed(context, '/contacts');
                },
              ),
              ListTile(
                leading: const Icon(Icons.add,
                    color: Color(0xFF2C3E50)), // Icono Azul Marino
                title: const Text('Añadir contacto',
                    style: TextStyle(
                        color: Color(0xFF2C3E50))), // Texto Azul Marino
                onTap: () {
                  Navigator.pushNamed(context, '/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app,
                    color: Color(0xFF2C3E50)), // Icono Azul Marino
                title: const Text('Cerrar sesion',
                    style: TextStyle(
                        color: Color(0xFF2C3E50))), // Texto Azul Marino
                onTap: () {
                  logout();
                  Navigator.pushNamed(context, '/login');
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.settings,
              //       color: Color(0xFF2C3E50)), // Icono Azul Marino
              //   title: const Text('Configuración',
              //       style: TextStyle(
              //           color: Color(0xFF2C3E50))), // Texto Azul Marino
              //   onTap: () {
              //     Navigator.pushReplacementNamed(context, '/configuration');
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}
