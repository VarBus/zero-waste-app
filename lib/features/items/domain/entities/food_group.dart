enum FoodGroup {
  vegetables('vegetables', 'Vegetables'),
  fruit('fruit', 'Fruit'),
  protein('protein', 'Protein'),
  dairy('dairy', 'Dairy'),
  grains('grains', 'Grains'),
  snack('snack', 'Snack'),
  other('other', 'Other');

  final String key;
  final String label;
  const FoodGroup(this.key, this.label);

  static FoodGroup fromKey(String? key) {
    for (final g in FoodGroup.values) {
      if (g.key == key) return g;
    }
    return FoodGroup.other;
  }
}
