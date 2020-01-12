import 'dart:convert';

import 'package:notes/models/api_response.dart';
import 'package:notes/models/note.dart';
import 'package:http/http.dart' as http;
import 'package:notes/models/note_detail.dart';
import 'package:notes/models/note_insert.dart';

class NotesService {
  static const API = "http://api.notes.programmingaddict.com";
  static const headers = {
    'apiKey': '08d796df-e56e-b87b-e020-39a875cf3e1e',
    'Content-Type': 'application/json'
  };

  Future<APIResponse<bool>> createNoteDetail(NoteInsert item) {
    return http // convert map to json (json.encode)
        .post(API + "/notes",
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        json.decode(data.body);
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    }).catchError((context) {
      return APIResponse<bool>(error: true, errorMessage: 'An error occurred');
    });
  }

  Future<APIResponse<NoteDetail>> getNoteDetail(String noteID) {
    return http.get(API + "/notes/" + noteID, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<NoteDetail>(data: NoteDetail.fromJson(jsonData));
      }
      return APIResponse<NoteDetail>(
          error: true, errorMessage: 'An error occurred');
    }).catchError((context) {
      return APIResponse<NoteDetail>(
          error: true, errorMessage: 'An error occurred');
    });
  }

  Future<APIResponse<List<Note>>> getNotesList() {
    return http.get(API + "/notes", headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <Note>[];

        for (var item in jsonData) {
          notes.add(Note.fromJson(item));
        }
        return APIResponse<List<Note>>(data: notes);
      }
      return APIResponse<List<Note>>(
          error: true, errorMessage: 'An error occurred');
    }).catchError((context) {
      return APIResponse<List<Note>>(
          error: true, errorMessage: 'An error occurred');
    });
  }
}
