import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes/models/api_response.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/views/note_delete.dart';
import 'package:notes/views/note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService service = GetIt.instance<NotesService>();
  APIResponse<List<Note>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('List of notes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NoteModify()))
                .then((context) {
              _fetchNotes();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (_apiResponse.error) {
              return Center(
                child: Text(_apiResponse.errorMessage),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.green,
              ),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(_apiResponse.data[index].noteID),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context,
                        builder: (context) {
                          return NoteDelete();
                        });
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16.0),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: Text(_apiResponse.data[index].noteTitle,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    subtitle: Text(
                        'Last edited on ${formatDateTime(_apiResponse.data[index].lastEditDateTime ?? _apiResponse.data[index].createDateTime)}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NoteModify(
                              noteID: _apiResponse.data[index].noteID)));
                    },
                  ),
                );
              },
              itemCount: _apiResponse.data.length,
            );
          },
        ));
  }
}
