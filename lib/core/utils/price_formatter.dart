// lib/core/utils/price_formatter.dart
import 'package:intl/intl.dart';

class PriceFormatter {
  /// Ví dụ: format(135, currency: 'USD', locale: 'vi_VN') -> $135.00
  static String format(num price,
      {String currency = 'USD', String locale = 'en_US', int? decimalDigits}) {
    final f = NumberFormat.simpleCurrency(
      locale: locale,
      name: currency,
      decimalDigits: decimalDigits,
    );
    return f.format(price);
  }
}
