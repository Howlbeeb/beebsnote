import 'package:beebnotes/constants/styles.dart';
import 'package:beebnotes/services/cloud/cloud_note.dart';
import 'package:beebnotes/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesGridView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesGridView({
    super.key,
    required this.notes,
    required this.onTap,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: notes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 16.0, mainAxisSpacing: 16.0),
        itemBuilder: ((context, index) {
          final note = notes.elementAt(index);
          return GestureDetector(
            onTap: () {
              onTap(note);
            },
            onLongPress: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteNote(note);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 102,
              height: 111,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: selectedColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: kMidTextStyle.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      note.text,
                      softWrap: true,
                      maxLines: 3,
                      style:
                          kSmallTextStyle.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
