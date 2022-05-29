class RegisterUser {
  String fullName;
  String email;
  String city;
  String phoneNumber;
  String password;

  get getFullName => fullName;

  set setFullName(fullName) => this.fullName = fullName;

  get getEmail => email;

  set setEmail(email) => this.email = email;

  get getCity => city;

  set setCity(city) => this.city = city;

  get getPhoneNumber => phoneNumber;

  set setPhoneNumber(phoneNumber) => this.phoneNumber = phoneNumber;

  get getPassword => password;

  set setPassword(password) => this.password = password;

  RegisterUser({
    this.fullName = "",
    this.email = "",
    this.city = "",
    this.phoneNumber = "",
    this.password = "",
  });
}
