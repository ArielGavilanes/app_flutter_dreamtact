import "package:cloud_firestore/cloud_firestore.dart";
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore bd = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getContactos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cedula = prefs.getString('cedula');

  List<Map<String, dynamic>> contactos = [];
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("contactos");
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await collectionReference.where('cedula', isEqualTo: cedula).get();

  for (var documento in querySnapshot.docs) {
    Map<String, dynamic> data = documento.data();
    contactos.add(data);
  }

  return contactos;
}

Future<void> register(user) async {
  try {
    CollectionReference collectionReferenceUsers = bd.collection('usuarios');
    await collectionReferenceUsers.add(user);
  } catch (e) {
    print('Error al registro');
    print(e);
  }
}

Future<bool> login(payload) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await bd
        .collection('usuarios')
        .where('cedula', isEqualTo: payload['cedula'])
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      String storedPassword = userData['contrasena'];

      if (storedPassword == payload['password']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('cedula', userData['cedula']);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    print('Error al buscar usuario por cédula: $e');
    throw Exception();
  }
}

Future<QuerySnapshot<Map<String, dynamic>>> getProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cedula = prefs.getString('cedula');

  QuerySnapshot<Map<String, dynamic>> queryProfile = await bd
      .collection('usuarios')
      .where('cedula', isEqualTo: cedula)
      .limit(1)
      .get();

  return queryProfile;
}

Future<void> addContact(contact) async {
  String id = await getNextContactId();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? cedula = prefs.getString('cedula');

  Map<String, dynamic> contactWithUser = {
    ...contact,
    'cedula': cedula,
    'id': id,
  };
  print(contactWithUser);
  try {
    CollectionReference collectionReferenceUsers = bd.collection('contactos');
    await collectionReferenceUsers.add(contactWithUser);
  } catch (e) {
    print('Error al registro');
    print(e);
  }
}

Future<List<Map<String, dynamic>>> getAllContactos() async {
  List<Map<String, dynamic>> contactos = [];
  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection("contactos");

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await collectionReference.get();

  for (var documento in querySnapshot.docs) {
    Map<String, dynamic> data = documento.data();
    contactos.add(data);
  }

  return contactos;
}

Future<String> getNextContactId() async {
  List<Map<String, dynamic>> contactos = await getAllContactos();
  int nextId = contactos.length + 1;
  return nextId.toString();
}

Future<QuerySnapshot<Map<String, dynamic>>> getSpecificContact(id) async {
  QuerySnapshot<Map<String, dynamic>> querySpecificContact = await bd
      .collection('contactos')
      .where('id', isEqualTo: id)
      .limit(1)
      .get();

  return querySpecificContact;
}

Future<void> updateContact(String id, contact) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await bd
        .collection('contactos')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference<Map<String, dynamic>> docRef =
          querySnapshot.docs.first.reference;

      await docRef.update(contact);

      print('Documento actualizado con éxito.');
    } else {
      print('Errr en if');
    }
  } catch (e) {
    print('Error al actualizar el documento: $e');
  }
}

Future<void> deleteContact(String id) async {
  try {
    // Referencia al documento que se va a eliminar
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await bd
        .collection('contactos')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentReference<Map<String, dynamic>> docRef =
          querySnapshot.docs.first.reference;

      await docRef.delete();

      print('Documento eliminado con éxito.');
    } else {
      print('Error en if');
    }

    print('Documento eliminado con éxito.');
  } catch (e) {
    print('Error al eliminar el documento: $e');
  }
}

Future<void> updateProfile(data) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cedula = prefs.getString('cedula');

    QuerySnapshot<Map<String, dynamic>> queryProfile = await bd
        .collection('usuarios')
        .where('cedula', isEqualTo: cedula)
        .limit(1)
        .get();

    // QuerySnapshot<Map<String, dynamic>> querySnapshot = await bd
    //     .collection('contactos')
    //     .where('id', isEqualTo: id)
    //     .limit(1)
    //     .get();

    if (queryProfile.docs.isNotEmpty) {
      DocumentReference<Map<String, dynamic>> docRef =
          queryProfile.docs.first.reference;

      await docRef.update(data);

      print('Documento actualizado con éxito.');
    } else {
      print('Errr en if');
    }
  } catch (e) {
    print('Error al actualizar el documento: $e');
  }
}
