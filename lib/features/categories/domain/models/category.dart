class Category {
  final int id;
  final String name;
  final String emoji;
  final String? description;
  final String? colorHex;

  Category({
    required this.id,
    required this.name,
    required this.emoji,
    this.description,
    this.colorHex,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
      emoji: map['emoji'] as String,
      description: map['description'] as String?,
      colorHex: map['color_hex'] as String?,
    );
  }
}
