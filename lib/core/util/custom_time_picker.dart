import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;

class TenMinutesPicker extends picker.TimePickerModel {
  TenMinutesPicker({DateTime? currentTime, picker.LocaleType? locale})
      : super(currentTime: currentTime, locale: locale);

  @override
  List<int> layoutProportions() => [1, 1, 0];

  @override
  String? rightStringAtIndex(int index) => null;

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      if (index % 10 == 0) {
        return digits(index);
      } else {
        return null;
      }
    }
    return null;
  }

  String digits(int value) => '$value'.padLeft(2, '0');

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index);
    }
    return null;
  }

  @override
  String leftDivider() => ':';
  @override
  String rightDivider() => '';

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentLeftIndex(),
            currentMiddleIndex(),
            currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentLeftIndex(),
            currentMiddleIndex(),
            currentRightIndex());
  }
}