
class Validation{

  static bool isValidName(String name){
    return name.length != 0 && name != null;
  }

  static bool isValidPhone(String phone){
    return phone != null && phone.length > 8 && phone.length < 15;
  }

  static bool isValidEmail(String email){
    return email.contains('@') && !email.contains(' ') && email != null;
  }

  static bool isValidPassword(String password){
    return password.length > 6 && password != null;
  }

  static bool isValidCMND(String cmnd){
    return cmnd.length == 9 && cmnd != null;
  }
  //Service
  static bool isValidApartment(String apartment){
    return apartment.length != 0 && apartment != null;
  }
}