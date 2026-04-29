import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

class NoSecondsPicker extends picker.TimePickerModel {
  NoSecondsPicker({DateTime? currentTime, picker.LocaleType? locale})
      : super(currentTime: currentTime, locale: locale);

  @override
  List<int> layoutProportions() => [1, 1, 0]; // 秒数の列の幅を 0 に設定
}
