// widgets/date_time_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as picker;
import '../../core/util/no_seconds_picker.dart';

class DateTimeSection extends StatelessWidget {
  final String label;
  final DateTime? date;
  final TimeOfDay? time;
  final bool isStart;
  final BuildContext parentContext; // 親Contextを受け取る
  final void Function(DateTime?) onDateSelected;
  final void Function(TimeOfDay?) onTimeSelected;

  const DateTimeSection({
    super.key,
    required this.label,
    required this.date,
    required this.time,
    required this.isStart,
    required this.parentContext, // 親Contextを受け取る
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final dateStr = DateFormat('MM月dd日').format(date);
    return dateStr;
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '';
    // 24時間形式で表示
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    picker.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      // 過去の日付も選択できるように、2010年1月1日から設定
      minTime: DateTime(2010, 1, 1),
      maxTime: DateTime.now().add(const Duration(days: 365)),
      theme: const picker.DatePickerTheme(
        backgroundColor: Colors.black,
        containerHeight: 210.0,
        itemStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        doneStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cancelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        headerColor: Colors.black,
        titleHeight: 45,
      ),
      onConfirm: (date) {
        onDateSelected(date); // コールバック関数で日付を親Widgetに渡す
      },
      // 現在の日付をデフォルトとして表示（もしくは既に選択されている日付があればそれを表示）
      currentTime: date ?? DateTime.now(),
      locale: picker.LocaleType.jp,
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    // 時間を表す基準となる日付オブジェクトを作成
    final DateTime baseTime = DateTime.now();
    
    // ここを変更: デフォルトを00:00に設定
    final DateTime currentTimeValue = time != null
        ? DateTime(baseTime.year, baseTime.month, baseTime.day, time!.hour, time!.minute, 0)
        : DateTime(baseTime.year, baseTime.month, baseTime.day, 0, 0, 0); // 00:00を設定

    picker.DatePicker.showPicker(
      context,
      showTitleActions: true,
      pickerModel: NoSecondsPicker(
        currentTime: currentTimeValue,
        locale: picker.LocaleType.jp,
      ),
      theme: const picker.DatePickerTheme(
        backgroundColor: Colors.black,
        containerHeight: 210.0,
        itemStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        doneStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        cancelStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
        headerColor: Colors.black,
        titleHeight: 45,
      ),
      locale: picker.LocaleType.jp,
      onConfirm: (time) {
        final TimeOfDay timeOfDay = TimeOfDay.fromDateTime(time);
        onTimeSelected(timeOfDay);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return _buildDateTimeSection();
  }


  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _selectDate(parentContext, isStart), // 親Contextを使用
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(date),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(parentContext, isStart), // 親Contextを使用
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(time),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}