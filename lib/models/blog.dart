/// Klasse Blog definiert die Struktur eines Blog-Objekts.
class Blog {
  // Eindeutige ID des Blogs.
  int id;

  // Titel des Blogs.
  String title;

  // Inhalt des Blogs.
  String content;

  // Datum der Veröffentlichung des Blogs.
  DateTime publishedAt;

  // Flag, das anzeigt, ob der Blog vom Benutzer geliked wurde.
  bool isLikedByMe;

  /// Konstruktor für die Erstellung eines neuen Blog-Objekts.
  ///
  /// [id] ist die eindeutige ID des Blogs und wird standardmäßig auf 0 gesetzt.
  /// [title] ist der Titel des Blogs und ist erforderlich.
  /// [content] ist der Inhalt des Blogs und ist erforderlich.
  /// [publishedAt] ist das Datum der Veröffentlichung des Blogs und ist erforderlich.
  /// [isLikedByMe] ist ein optionaler Parameter, der angibt, ob der Blog vom Benutzer geliked wurde.
  Blog({
    this.id = 0,
    required this.title,
    required this.content,
    required this.publishedAt,
    this.isLikedByMe = false,
  });

  /// Getter, um das Veröffentlichungsdatum als formatierten String zurückzugeben.
  ///
  /// Formatiert das Datum als 'Tag.Monat.Jahr'.
  String get publishedDateString =>
      "${publishedAt.day}.${publishedAt.month}.${publishedAt.year}";
}
