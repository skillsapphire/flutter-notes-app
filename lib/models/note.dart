class Note {
  String noteID;
  String noteTitle;
  DateTime createDateTime;
  DateTime lastEditDateTime;

  Note(
      {this.noteID,
      this.noteTitle,
      this.createDateTime,
      this.lastEditDateTime});

  factory Note.fromJson(Map<String, dynamic> item) {
    final note = Note(
        noteID: item['noteID'],
        noteTitle: item['noteTitle'],
        createDateTime: DateTime.parse(item['createDateTime']),
        lastEditDateTime: item['lastestEditDateTime'] != null
            ? DateTime.parse(item['lastestEditDateTime'])
            : null);
    return note;
  }
}
