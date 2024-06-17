import 'package:app_dreamtact/components/custom_drawer.dart';
import 'package:app_dreamtact/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tu perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar el perfil'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No se encontró información de perfil'));
          }

          Map<String, dynamic> userData = snapshot.data!.docs.first.data();
          String nombre = userData['nombre'] ?? '';
          String apellido = userData['apellido'] ?? '';
          String cedula = userData['cedula'] ?? '';

          String urlFotoPerfil = userData['url_perfil'] ?? '';

          return Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 200,
                      backgroundImage: urlFotoPerfil.isNotEmpty
                          ? NetworkImage(urlFotoPerfil)
                          : const AssetImage(
                                  'assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$nombre $apellido',
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cedula,
                      style: const TextStyle(
                        fontSize: 38,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/contacts');
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2C3E50),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: const CustomDrawer(),
    );
  }
}
