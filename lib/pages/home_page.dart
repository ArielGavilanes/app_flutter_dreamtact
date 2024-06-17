import 'package:app_dreamtact/components/custom_drawer.dart';
import 'package:app_dreamtact/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inicio',
          style: TextStyle(color: Colors.white), // Texto en blanco
        ),
        backgroundColor: const Color(0xFF2C3E50), // Azul Marino
        iconTheme: const IconThemeData(color: Colors.white), // Íconos en blanco
      ),
      drawer: const CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Asegura que todo el contenido esté alineado a la izquierda
        children: [
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Hola, $nombre!',
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left, // Alinea el texto a la izquierda
                ),
              );
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                'Contenido de la página',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
