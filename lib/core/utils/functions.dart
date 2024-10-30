String? passwordValidator(String? password) {
  if (password == null || password.isEmpty) {
    return "Please enter password";
  } else if (password.length < 8) {
    return "Password should at least 8 character";
  }
  return null;
}

bool isEmailFormatCorrect(String email) {
  return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) {
    return "Please enter email";
  } else if (!isEmailFormatCorrect(email)) {
    return "Email format not correct";
  }

  return null;
}



String? usernameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return "Please enter username";
  } else if (name.length < 3) {
    return "Username is short";
  }
  return null;
}