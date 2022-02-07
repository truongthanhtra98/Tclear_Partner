class PaymentMethod{
  String value;
  String method;
  double money;

  PaymentMethod(this.value, this.method, {this.money});

  static List<PaymentMethod> listMethod(){
    return [
      PaymentMethod('1', 'Tiền mặt'),
      PaymentMethod('2', 'Ví Momo'),
      PaymentMethod('3', 'Chuyển khoản qua thẻ ngân hàng'),
    ];
  }
}