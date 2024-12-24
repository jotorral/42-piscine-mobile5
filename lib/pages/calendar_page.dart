import 'package:flutter/material.dart';
import 'package:piscine_mobile_4/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// import 'logout_button.dart';
// import '../authentications/google_authen.dart';

// Pantalla 3 - CALENDAR
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  // Controladores para los campos del formulario
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  String _selectedMood = 'neutral'; // Estado inicial del estado de ánimo
  final List<String> moods = ['neutral', 'sad', 'angry', 'excited', 'nervous', 'happy']; // Lista de moods
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pág.2 - User: ${FirebaseAuth.instance.currentUser?.displayName ?? ''}',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'DancingScript', fontSize: 24, color: Colors.black),
        ),

        Expanded(
          child: TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ),

        Expanded(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: getNotesStream(), // Usamos el Stream aquí
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay datos disponibles'));
              }
    
              final notes = snapshot.data!;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  final Timestamp? timestamp = note['date'];
                  final DateTime? dateTime = timestamp?.toDate();
                  final String day = dateTime != null
                      ? DateFormat('dd').format(dateTime)
                      : '--';
                  final String month = dateTime != null
                      ? DateFormat('MMM').format(dateTime)
                      : '--';
                  final String year = dateTime != null
                      ? DateFormat('yyyy').format(dateTime)
                      : '--';
    
                  final String moodText = note['icon'] ?? 'neutral';
                  final String emoji = moodEmojis[moodText] ?? '?';
    
                  return GestureDetector(
                    onTap: () => _showNoteDialog(context, note),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        // padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Espaciado entre elementos
                          children: <Widget>[
                            Column(
                              children: [
                                Text(
                                  day,
                                  style: const TextStyle(
                                      fontFamily: 'DancingScript',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  month,
                                  style: const TextStyle(
                                      fontFamily: 'DancingScript',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  year,
                                  style: const TextStyle(
                                      fontFamily: 'DancingScript',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Text(
                              emoji,
                              style: const TextStyle(
                                  fontFamily: 'DancingScript',
                                  fontSize: 20,
                                  color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            Container(
                                height: 40,
                                width: 1,
                                color: Colors.black, // Color de la línea
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8)),
                            const SizedBox(width: 16),
                            Expanded(
                                child: Text(
                              note['title'],
                              style: const TextStyle(
                                  fontFamily: 'DancingScript',
                                  fontSize: 14,
                                  color: Colors.grey),
                            )),
                            // Text(
                            // 	'ID: ${note['uid']}',
                            // 	style: const TextStyle(fontSize: 14, color: Colors.grey),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
    							_showNewEntryDialog(context);
            // Llamamos al callback para cambiar a Pantalla 0
            // (context.findAncestorStateOfType<PantallaPrincipalState>()!)
            //     .cambiarPantalla(0);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
          child: const Text(
            'New diary entry',
            style: TextStyle(
                fontFamily: 'DancingScript',
                fontSize: 20,
                color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centrar los iconos en la fila
          children: [
            IconButton(
              onPressed: () {
                // Lógica para el primer icono
                (context.findAncestorStateOfType<PantallaPrincipalState>()!)
                    .cambiarPantalla(0);
              },
              icon: const Icon(Icons.person),
              tooltip:
                  'Ir a Pantalla Usuario', // Tooltip que aparece al pasar el mouse
              color: Colors.blue, // Color del icono
              iconSize: 32.0, // Tamaño del icono
            ),
            const SizedBox(width: 16), // Separación entre los iconos
            IconButton(
              onPressed: () {
                // Lógica para el segundo icono
                (context.findAncestorStateOfType<PantallaPrincipalState>()!)
                    .cambiarPantalla(1);
              },
              icon: const Icon(Icons.calendar_today),
              tooltip:
                  'Ir a Pantalla Calendario', // Tooltip para el segundo icono
              color: Colors.green,
              iconSize: 32.0,
            ),
          ],
    
          // children: [
          //   ElevatedButton(
          //   	onPressed: () {
          //   		// Llamamos al callback para cambiar a Pantalla 1
          //   		(context.findAncestorStateOfType<PantallaPrincipalState>()!)
          //   				.cambiarPantalla(1);
          //   	},
          //   	child: const Text('Ir a Pantalla 1 (Log con Google/Github)'),
          //   ),
          // ],
        ),
      ],
    );
  }

  // Devuelve un Stream que emite una lista de mapas con los datos en tiempo real
  Stream<List<Map<String, dynamic>>> getNotesStream() {
    return FirebaseFirestore.instance
        .collection('notes') // Cambia 'notes' si necesitas otra colección
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'title': doc.data()['title'] ?? 'Sin título',
                'uid': doc.id,
                'icon': doc.data()['icon'] ?? 'Sin icono',
                'date': doc.data()['date'],
								'text': doc.data()['text'],
              };
            }).toList());
  }

  void _showNoteDialog(BuildContext context, Map<String, dynamic> note) {

		final Timestamp? timestamp = note['date'];
		final DateTime? dateTime = timestamp?.toDate();

		final String moodText = note['icon'] ?? 'neutral';
    final String emoji = moodEmojis[moodText] ?? '?';

		final String formattedDate = dateTime != null
			? getFormattedDate(dateTime)//DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(dateTime)
			: 'Fecha no disponible';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Detalles de la nota',
          //     style: TextStyle(fontFamily: 'DancingScript')),
          content: SingleChildScrollView(
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								Text(formattedDate,
										style: const TextStyle(fontFamily: 'DancingScript')),
								const SizedBox(height:8),
								const Divider(
									thickness: 1,
									color: Colors.black,
									indent: 16,
									endIndent: 16),
								const SizedBox(height:8),
								Text('My feeling: $emoji',
										style: const TextStyle(fontFamily: 'DancingScript')),
								const SizedBox(height:8),
								const Divider(
									thickness: 1,
									color: Colors.black,
									indent: 16,
									endIndent: 16),
								const SizedBox(height:8),
								Text('${note['text']}',
										style: const TextStyle(fontFamily: 'DancingScript')),
								const SizedBox(height: 16),
								ElevatedButton(
									onPressed: () {
										_deleteNoteFromDatabase(note['uid']);
										Navigator.of(context).pop(); // Cierra el diálogo
									},
									style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
									child: const Text('Eliminar',
											style: TextStyle(color: Colors.white)),
								),
							],
						),
					),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

void _showNewEntryDialog(BuildContext context) {
  _selectedMood = moods.first;
  _titleController.clear();
  _textController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String currentMood = _selectedMood;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('New Diary Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
									decoration: BoxDecoration(
										border: Border.all (color: Colors.grey, width: 2),
										borderRadius: BorderRadius.circular(4),
									),
									child: TextField(
										controller: _titleController,
										decoration: const InputDecoration(hintText: 'Title'),
									),
								),
								const SizedBox(height: 8),
                DropdownButton<String>(
                  value: currentMood,
                  onChanged: (String? newValue) {
                    setState(() {
                      currentMood = newValue!;
                      _selectedMood = newValue;
                    });
                  },
                  items: moods.map((String mood) {
                    return DropdownMenuItem<String>(
                      value: mood,
                      child: Text(moodEmojis[mood] ?? '😐 $mood'),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Container(
									decoration: BoxDecoration(
										border: Border.all(color: Colors.grey, width: 2),
										borderRadius: BorderRadius.circular(4),
									),
									child: TextField(
										controller: _textController,
										decoration: const InputDecoration(hintText: 'Text'),
										maxLines: 4,
									),
								),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
                // Cerrar el diálogo sin guardar
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNewEntry(); // Llamar a la función para agregar el registro
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Add'),
            ),
          ],
        );
          },
        );
      },
    );
  }

  // Agregar la nueva entrada a la base de datos de Firebase
  Future<void> _addNewEntry() async {
    final String title = _titleController.text;
    final String text = _textController.text;
    final String icon = _selectedMood;
    final DateTime date = DateTime.now();
    final String usermail = FirebaseAuth.instance.currentUser?.email ?? '';

    if (title.isNotEmpty && text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('notes').add({
          'title': title,
          'text': text,
          'icon': icon,
          'date': date,
          'usermail': usermail,
        });

        // Limpiar los campos después de agregar la entrada
        _titleController.clear();
        _textController.clear();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entrada guardada con éxito')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la entrada: $e')),
          );
        }
      }
    } else {
      // Mostrar un mensaje si los campos están vacíos
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos')),
        );
      }
    }
  }


  Future<void> _deleteNoteFromDatabase(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(documentId)
          .delete();

			if (mounted) {		
				ScaffoldMessenger.of(context).showSnackBar(
					const SnackBar(content: Text('Nota eliminada con éxito')),
				);
			}
    } catch (e) {
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text('Error al eliminar: $e')),
				);
			}
    }
  }
}


String getFormattedDate(DateTime dateTime) {
  // Formateamos la fecha
  String formattedDate = DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(dateTime);

  // Dividimos la primera letra y la restamos para ponerla en minúscula
  final String dayOfWeek = formattedDate.split(',')[0]; // "domingo" por ejemplo
  final String capitalizedDay = dayOfWeek[0].toUpperCase() + dayOfWeek.substring(1).toLowerCase();

  // Reemplazamos el nombre del día en el formato final
  formattedDate = formattedDate.replaceFirst(dayOfWeek, capitalizedDay);

  return formattedDate;
}



const Map<String, String> moodEmojis = {
  'neutral': '😐',
  'happy': '😊',
  'sad': '😢',
  'angry': '😡',
  'excited': '🤩',
  'nervous': '😬',

  // Agrega más estados y emojis según sea necesario
};
