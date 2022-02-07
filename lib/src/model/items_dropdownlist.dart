class Item {
  int idItem;
  int thoiGian;
  int soNguoiLam;
  String dienTich;
  String soPhong;

  Item(this.thoiGian, {this.dienTich, this.soPhong, this.soNguoiLam});

  @override
  String toString() {
    return '$thoiGian, $dienTich, $soPhong';
  }

}