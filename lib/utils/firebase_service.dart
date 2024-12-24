import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getNotes() async {
	List notes = [];
	CollectionReference collectionReferenceNotes = db.collection('notes'); // este notes tiene que coincidir con el mismo nombre que hemos dado a la tabla de la base de datos en Firestore

	QuerySnapshot querySnapshot = await collectionReferenceNotes.get(); // Cuando noa hay muchos registros se puede hacer un get. SI son muchos tardaría demasiado

	for (var doc in querySnapshot.docs) {
		final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
		final person = {
			"name": data['title'],
			"uid": doc.id,
		};
		notes.add(person);
	}
	// await Future.delayed(const Duration(seconds: 5)); // Espera de prueba para ver el círculo de espera en la pantalla cuandop espera datos de la DB
	return notes;
}

// Guardar un name en base de datos
Future<void> addNotes(String name) async {
	await db.collection("notes").add({"title": name});
}

// Editar y actualizar un name en base de datos
Future<void> updateNotes(String uid, String newName) async {
	await db.collection("notes").doc(uid).set({"title": newName});
}

// Eliminar dato de Firebase
Future<void> deleteNotes(String uid) async {
	await db.collection("notes").doc(uid).delete();
}