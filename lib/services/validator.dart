String? emailValidator(String? value) {
  if (value == null || value == "") {
    return "Veuillez renseigner ce champ";
  } else if (!value.contains("@") || !value.contains(".")) {
    return "Renseignez un email valide";
  }
}
