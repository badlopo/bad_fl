extension ListExt<Item> on List<Item> {
  List<Product> slotted<Product>({
    required Product Function(Item item) builder,
    required Product slot,
  }) {
    final result = <Product>[];
    for (var i = 0; i < length; i++) {
      result.add(builder(this[i]));
      if (i < length - 1) {
        result.add(slot);
      }
    }
    return result;
  }
}
