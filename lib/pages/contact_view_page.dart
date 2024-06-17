import 'package:flutter/material.dart';
import 'package:app_dreamtact/components/custom_drawer.dart';
import 'package:app_dreamtact/services/firebase_service.dart'; // Asegúrate de importar el servicio correcto aquí

class ContactView extends StatefulWidget {
  const ContactView({super.key});

  @override
  State<ContactView> createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Contactos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C3E50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List>(
        future:
            getContactos(), // Asegúrate de que getContactos() devuelva una lista de contactos
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los contactos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay contactos disponibles.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var cliente = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/specific',
                    arguments: cliente[
                        'id'], // Pasamos el ID del cliente como argumento
                  );
                },
                child: Card(
                  color: const Color(0xFFECF0F1),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cliente['nombre_contacto'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Organización: ${cliente['organizacion']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Teléfono: ${cliente['numero']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF3498DB),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Correo electrónico: ${cliente['email']}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      drawer: const CustomDrawer(),
      backgroundColor: const Color(0xFFECF0F1),
    );
  }
}
