import 'package:intl/intl.dart';
import 'package:password/password.dart';

var formatterDay = new DateFormat('dd/MM');
var formatter = new DateFormat('dd/MM/yyyy');
var formatter1 = new DateFormat('dd-MM-yyyy');
var formatterYYMMdd = new DateFormat('yyyy-MM-dd');
var formatterHasHour = new DateFormat('HH:mm, dd/MM/yyyy');
var formatterHour = new DateFormat('HH:mm');
final oCcy = new NumberFormat("#,##0", "vi_VN");

final algorithm = PBKDF2();
