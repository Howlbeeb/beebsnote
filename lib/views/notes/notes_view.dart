import 'package:beebnotes/constants/routes.dart';
import 'package:beebnotes/services/auth/auth_service.dart';
import 'package:beebnotes/services/auth/crud/notes_service.dart';
import 'package:beebnotes/utilities/dialogs/logout_dialog.dart';
import 'package:beebnotes/views/notes/notes_list_view.dart';
import 'package:flutter/material.dart';
import 'package:beebnotes/enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesService _notesService;
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Beeb\'s Notes'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    createOrUpdateNotesRoute,
                  );
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton<MenuAction>(
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
                ];
              },
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logout();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                    }
                }
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(id: note.id);
                              },
                              onTap: (note) {
                                Navigator.of(context).pushNamed(
                                    createOrUpdateNotesRoute,
                                    arguments: note);
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
