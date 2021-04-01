import 'package:intl/intl.dart';

class DateFormatHelper{
  static var dateFormat = DateFormat.d();
  static  var monthFormat = DateFormat.MMMM();
  static  var yearFormat = DateFormat.y();
  static  var dayFormat = DateFormat('EEEE');
  static var eventDate = DateFormat.yMMMMd();
  static var hour = DateFormat.Hm();
}
