import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes/models/note_detail.dart';
import 'package:notes/models/note_insert.dart';
import 'package:notes/services/notes_service.dart';

class NoteModify extends StatefulWidget {
// needs to be final because its stateless widget
  final String noteID;

// optional parameter
  NoteModify({this.noteID});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool isEditing() {
    return widget.noteID != null ? true : false;
  }

  NotesService service = GetIt.instance<NotesService>();
  String errorMsg = '';
  NoteDetail noteDetail;

  // helps to bind to any text field and edit its value at any point of time
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (isEditing()) {
      setState(() {
        _isLoading = true;
      });
      service.getNoteDetail(widget.noteID).then((response) {
        setState(() {
          _isLoading = false;
        });

        if (response.error) {
          errorMsg = response.errorMessage ?? 'An error occurred';
        }
        noteDetail = response.data;
        _titleController.text = noteDetail.noteTitle;
        _contentController.text = noteDetail.noteContent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing() ? 'Edit note' : 'Create note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Note title'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Note content'),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 35.0,
                    child: RaisedButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        if (isEditing()) {
                          // update logic
                        } else {
                          setState(() {
                            _isLoading = true;
                          });
                          final noteInsert = NoteInsert(
                              noteTitle: _titleController.text,
                              noteContent: _contentController.text);
                          final result =
                              await service.createNoteDetail(noteInsert);
                          final title = 'Done';
                          final text = result.error
                              ? result.errorMessage ?? 'An error occurred'
                              : 'Note successfully created!';

                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )).then((data) {
                            if (result.data) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
