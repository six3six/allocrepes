import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:webfeed/domain/atom_item.dart';
import 'package:webfeed/webfeed.dart';

class New extends Equatable {
  final List<String> authors;
  final String title;
  final String summary;
  final String content;
  final String url;
  final String media;
  final DateTime? updated;

  const New({
    this.authors = const [],
    required this.title,
    required this.summary,
    this.updated,
    required this.content,
    required this.url,
    required this.media,
  });

  static New fromAtom(AtomItem item) {
    var unescape = new HtmlUnescape();

    List<String> authors = <String>[];
    for (AtomPerson person in item.authors) {
      authors.add(unescape.convert(person.name));
    }
    return New(
      authors: authors,
      title: unescape.convert(item.title),
      updated: item.updated ?? DateTime(0),
      content: unescape.convert(item.content) ?? "",
      summary: unescape.convert(item.summary),
      url: item.id,
      media: "",
    );
  }

  static New fromRss(RssItem item) {
    var unescape = new HtmlUnescape();
    return New(
      authors: [unescape.convert(item.author ?? "")],
      title: unescape.convert(item.title ?? ""),
      updated: item.pubDate ?? DateTime(0),
      content: "",
      summary: unescape.convert(item.description ?? ""),
      url: item.link ?? "",
      media:
          item.media.contents.length > 0 ? item.media.contents.first.url : "",
    );
  }

  @override
  List<Object?> get props => [
        authors,
        title,
        summary,
        content,
        url,
        media,
        updated,
      ];
}
