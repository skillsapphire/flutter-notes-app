class NoteDetail {
  String noteID;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime lastEditDateTime;

  NoteDetail(
      {this.noteID,
      this.noteTitle,
      this.noteContent,
      this.createDateTime,
      this.lastEditDateTime});

  factory NoteDetail.fromJson(Map<String, dynamic> item) {
    final note = NoteDetail(
        noteID: item['noteID'],
        noteTitle: item['noteTitle'],
        noteContent: item['noteContent'],
        createDateTime: DateTime.parse(item['createDateTime']),
        lastEditDateTime: item['lastestEditDateTime'] != null
            ? DateTime.parse(item['lastestEditDateTime'])
            : null);
    return note;
  }
}
