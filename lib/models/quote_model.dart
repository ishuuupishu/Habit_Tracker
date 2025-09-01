class QuoteModel {
  final String id;
  final String text;
  final String author;
  final List<String> tags;
  bool isFavorite;

  QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    this.tags = const [],
    this.isFavorite = false,
  });

  // Add this method:
  QuoteModel copyWith({
    String? id,
    String? text,
    String? author,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  factory QuoteModel.fromMap(Map<String, dynamic> data, String documentId) {
    return QuoteModel(
      id: documentId,
      text: data['text'] ?? '',
      author: data['author'] ?? 'Unknown',
      tags: List<String>.from(data['tags'] ?? []),
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'author': author,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }
}