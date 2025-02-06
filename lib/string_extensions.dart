extension StringExtensions on String {
  String capitalize() {
    String result = '';
    if (isNotEmpty) {
      result = '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    }
    return result;
  }

  String captitalizeFirstLetters() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }
}
