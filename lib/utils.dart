String? validateNotEmpty(String? value) {
  return value == null || value.isEmpty ? 'This field cannot be empty' : null;
}
