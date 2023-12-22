import 'dart:typed_data';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<int> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;
  //final String htmlContent; // New field for HTML content

  ItemModel({
    required this.id,
    required this.deleted,
    required this.type,
    required this.by,
    required this.time,
    required this.text,
    required this.dead,
    required this.parent,
    required this.kids,
    required this.url,
    required this.score,
    required this.title,
    required this.descendants,
   // required this.htmlContent, // Include htmlContent in the constructor
  });

  factory ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    return ItemModel(
      id: parsedJson['id'] as int? ?? 0,
      deleted: parsedJson['deleted'] as bool? ?? false,
      type: parsedJson['type'] as String? ?? '',
      by: parsedJson['by'] as String? ?? '',
      time: parsedJson['time'] ?? 0,
      text: parsedJson['text'] ?? '',
      dead: parsedJson['dead'] ?? false,
      parent: parsedJson['parent'] ?? 0,
      kids: _parseKids(parsedJson['kids'] as String? ?? ''),
      url: parsedJson['url'] ?? '',
      score: parsedJson['score'] ?? 0,
      title: parsedJson['title'] ?? '',
      descendants: parsedJson['descendants'] ?? 0,
      //htmlContent: parsedJson['htmlContent'] ?? '', // Parse and assign HTML content from the API response
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      "parent": parent,
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants,
      "dead": dead,
      "deleted": deleted,
       "kids": kids.join(',')
    };
  }

  static Future<ItemModel?> fromDb(Map<String, Object?> first) async {
  try {
    final item = ItemModel(
      id: first['id'] as int? ?? 0,
      deleted: (first['deleted'] as int? ?? 0) == 1,
      type: first['type'] as String? ?? '',
      by: first['by'] as String? ?? '',
      time: first['time'] as int? ?? 0,
      text: first['text'] as String? ?? '',
      dead: (first['dead'] as int? ?? 0) == 1,
      parent: first['parent'] as int? ?? 0,
      kids: _parseKids(first['kids'] as String? ?? ''),
      url: first['url'] as String? ?? '',
      score: first['score'] as int? ?? 0,
      title: first['title'] as String? ?? '',
      descendants: first['descendants'] as int? ?? 0,
      //htmlContent: first['htmlContent'] as String? ?? '',
      
    );
    return item;
  } catch (e) {
    print('Error in fromDb: $e');
    return null;
  }
}

static List<int> _parseKids(String kidsString) {
  if (kidsString.isEmpty) {
    return [];
  }

  return kidsString.split(',').map((id) => int.tryParse(id) ?? 0).toList();
}

}
