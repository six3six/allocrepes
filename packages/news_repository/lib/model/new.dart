/*import 'package:dart_rss/domain/atom_item.dart';
import 'package:dart_rss/domain/atom_person.dart';
import 'package:dart_rss/domain/rss_item.dart';*/
import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape.dart';

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

  /*static New fromAtom(AtomItem item) {
    var unescape = new HtmlUnescape();

    List<String> authors = <String>[];
    for (AtomPerson person in item.authors) {
      authors.add(unescape.convert(person.name ?? ""));
    }

    return New(
      authors: authors,
      title: unescape.convert(item.title ?? ""),
      updated: parseRfc822(item.updated ?? "0"),
      content: unescape.convert(item.content ?? ""),
      summary: unescape.convert(item.summary ?? ""),
      url: item.id ?? "",
      media: "",
    );
  }

  static New fromRss(RssItem item) {
    var unescape = new HtmlUnescape();

    return New(
      authors: [unescape.convert(item.author ?? "")],
      title: unescape.convert(item.title ?? ""),
      updated: parseRfc822(item.pubDate ?? "0"),
      content: "",
      summary: unescape.convert(item.description ?? ""),
      url: item.link ?? "",
      media: ((item.media?.contents.length ?? 0) > 0
              ? item.media?.contents.first.url
              : "") ??
          "",
    );
  }*/

  static const MONTHS = {
    'Jan': '01',
    'Feb': '02',
    'Mar': '03',
    'Apr': '04',
    'May': '05',
    'Jun': '06',
    'Jul': '07',
    'Aug': '08',
    'Sep': '09',
    'Oct': '10',
    'Nov': '11',
    'Dec': '12',
  };

  static DateTime parseRfc822(String input) {
    var splits = input.split(' ');
    var reformatted = splits[3] +
        '-' +
        (MONTHS[splits[2]] ?? "01") +
        '-' +
        (splits[1].length == 1 ? '0' + splits[1] : splits[1]) +
        ' ' +
        splits[4] +
        ' ' +
        splits[5];

    return DateTime.tryParse(reformatted) ?? DateTime(0);
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
