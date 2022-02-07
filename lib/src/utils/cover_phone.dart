class CoverPhone{
  static String coverPhone(String phone){

    if(phone.length != 0 && phone.substring(0, 1) == '0'){
      return phone.substring(1, phone.length);
    }else{
      return phone;
    }
  }
}