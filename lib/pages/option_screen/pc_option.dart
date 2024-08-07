class PcOption {
  final String name;
  final String image;
  bool _hovered = false;

  PcOption({required this.name, required this.image});

  void setHovered(bool hovered) {
    _hovered = hovered;
  }

  bool isHovered() {
    return _hovered;
  }
}
