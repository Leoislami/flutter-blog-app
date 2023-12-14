// Definiert die Datenstruktur für einen Blog-Beitrag.
class Blog {
  // Titel des Blog-Beitrags.
  String title;

  // Inhalt des Blog-Beitrags.
  String content;

  // Das Datum, an dem der Blog-Beitrag veröffentlicht wurde.
  DateTime publishedAt;

  // Konstruktor, der es erfordert, dass alle Eigenschaften bei der Erstellung eines Blog-Objekts bereitgestellt werden müssen.
  Blog({
    required this.title,
    required this.content,
    required this.publishedAt,
  });

  // Getter, um das Veröffentlichungsdatum als String im Format "Tag.Monat.Jahr" zu erhalten.
  // Beispiel: "14.12.2023"
  String get publishedDateString =>
      "${publishedAt.day}.${publishedAt.month}.${publishedAt.year}";
}
