import 'package:flutter/material.dart';
import 'package:flutter_blog_app/models/blog.dart';
import 'package:flutter_blog_app/providers/blog_provider.dart';
import 'package:flutter_blog_app/services/blog_service.dart';
import 'package:flutter_blog_app/services/blog_api.dart';
import 'package:provider/provider.dart';

// BlogDetailPage dient zum Anzeigen und Bearbeiten der Details eines Blog-Beitrags.
class BlogDetailPage extends StatefulWidget {
  final Blog blog;
  const BlogDetailPage({required this.blog, super.key});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

// Enum zur Verwaltung des Zustands der Seite.
enum _PageStates { loading, ready }

class _BlogDetailPageState extends State<BlogDetailPage> {
  late String title;
  late String content;

  var pageState = _PageStates.ready;

  @override
  void initState() {
    super.initState();
    title = widget.blog.title;
    content = widget.blog.content;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.blog.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Widget für bearbeitbaren Text mit Validierungsfunktion.
                TextWithEditOption(
                    label: "Title",
                    content: title,
                    isEditable: true,
                    onEdit: _editTitle,
                    validator: _textLongerThanTwoChars,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8.0),
                TextWithEditOption(
                  label: "Content",
                  content: content,
                  multiLines: true,
                  isEditable: true,
                  onEdit: _editContent,
                  validator: _textLongerThanTwoChars,
                ),
                const SizedBox(height: 8.0),
                // Anzeige des Veröffentlichungsdatums.
                Text(widget.blog.publishedDateString,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
        // Anzeige eines Ladeindikators während der Bearbeitung.
        if (pageState == _PageStates.loading)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  // Funktion zum Bearbeiten des Titels.
  void _editTitle(String newTitle) async {
    setState(() {
      pageState = _PageStates.loading;
    });
    var blogProvider = context.read<BlogProvider>();
    await blogProvider.updateBlog(
        widget.blog.id, newTitle, widget.blog.content);
    if (mounted) {
      setState(() {
        title = newTitle;
        pageState = _PageStates.ready;
      });
    }
  }

  // Funktion zum Bearbeiten des Inhalts.
  void _editContent(String newContent) async {
    setState(() {
      pageState = _PageStates.loading;
    });
    var blogProvider = context.read<BlogProvider>();
    await blogProvider.updateBlog(
        widget.blog.id, widget.blog.title, newContent);
    if (mounted) {
      setState(() {
        content = newContent;
        pageState = _PageStates.ready;
      });
    }
  }

  // Einfache Validierungsfunktion, die überprüft, ob der Text mehr als zwei Zeichen enthält.
  bool _textLongerThanTwoChars(String text) {
    return text.length > 2;
  }
}

// TextWithEditOption ist ein wiederverwendbares Widget, das einen Text anzeigt
// und optional eine Bearbeitungsfunktion bereitstellt.
class TextWithEditOption extends StatelessWidget {
  final String content;
  final String label;
  final bool isEditable;
  final void Function(String) onEdit;
  final bool multiLines;
  final bool Function(String)? validator;
  final TextStyle? style;

  const TextWithEditOption(
      {required this.content,
      required this.label,
      required this.onEdit,
      this.isEditable = false,
      this.multiLines = false,
      this.validator,
      this.style,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(content, style: style)),
        // Bearbeitungssymbol, das bei Klick das Bearbeitungsmenü öffnet.
        if (isEditable)
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editTextSheet(context),
          ),
      ],
    );
  }

  // Zeigt ein unteres Blatt an, um den Text zu bearbeiten.
  void _editTextSheet(BuildContext context) {
    var textController = TextEditingController(text: content);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.headlineSmall),
                Expanded(
                  child: TextField(
                    controller: textController,
                    autofocus: true,
                    maxLines: multiLines ? null : 1,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (validator != null && validator!(textController.text)) {
                      onEdit(textController.text);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
