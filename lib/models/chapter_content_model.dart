class ChapterContent {
  final String title;
  final List<ContentSection> sections;

  const ChapterContent({required this.title, required this.sections});
}

class ContentSection {
  final String? subtitle;
  final List<ContentBlock> blocks;

  const ContentSection({this.subtitle, required this.blocks});
}

class ContentBlock {
  final String text;
  final BlockType type;

  const ContentBlock({required this.text, this.type = BlockType.paragraph});
}

enum BlockType {
  paragraph,
  heading,
  subheading,
  bulletPoint,
  numberPoint,
  image,
  note,
}
