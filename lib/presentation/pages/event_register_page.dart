import 'dart:io';
import '../../core/util/generate_id.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/events_provider.dart';
import '../../domain/entities/event_entity.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/register_event_custom_text_field.dart';
import '../widgets/venue_selector.dart';
import '../widgets/date_time_section.dart';
import '../widgets/image_picker_section.dart';
import '../../core/util/exceptions.dart';
import '../widgets/atomic_event_card_widget.dart';
import '../widgets/genre_selector.dart';

class EventRegisterPage extends ConsumerStatefulWidget {
  const EventRegisterPage({super.key});
  @override
  ConsumerState<EventRegisterPage> createState() => _EventRegisterPageState();
}

class _EventRegisterPageState extends ConsumerState<EventRegisterPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  List<EventGenre> _selectedGenres = []; // EventGenreリストに変更
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  String? _selectedClubId;
  String? _selectedClubName;
  bool _isLoading = false;
  String? _flyerImagePath;

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _setImagePath(String? path) {
    setState(() {
      _flyerImagePath = path;
    });
  }

  // URLを起動するメソッドを追加
  void _launchClubFormUrl(BuildContext context) async {
    final Uri url = Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSfMi84T73Q1sMIdrKfk6ekD2SVXifIUHwkTyry6gqBafCWs6Q/viewform?usp=header');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('URLを開くことができませんでした'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('エラーが発生しました'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'キャンセル',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          title: const Text(
            'イベントを追加',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _eventNameController,
                      label: 'ライブ・イベント名',
                      maxLength: 50,
                    ),
                    DateTimeSection(
                      label: '開始日時',
                      date: _startDate,
                      time: _startTime,
                      isStart: true,
                      parentContext: context,
                      onDateSelected: (date) {
                        setState(() {
                          _startDate = date;
                        });
                      },
                      onTimeSelected: (time) {
                        setState(() {
                          _startTime = time;
                        });
                      },
                    ),
                    DateTimeSection(
                      label: '終了日時',
                      date: _endDate,
                      time: _endTime,
                      isStart: false,
                      parentContext: context,
                      onDateSelected: (date) {
                        setState(() {
                          _endDate = date;
                        });
                      },
                      onTimeSelected: (time) {
                        setState(() {
                          _endTime = time;
                        });
                      },
                    ),
                    VenueSelector(
                      selectedClubId: _selectedClubId,
                      selectedClubName: _selectedClubName,
                      onClubSelected: (clubId, clubName) {
                        setState(() {
                          _selectedClubId = clubId;
                          _selectedClubName = clubName;
                        });
                      },
                    ),
                    // クラブがない場合のリンクテキストを追加
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      child: GestureDetector(
                        onTap: () => _launchClubFormUrl(context),
                        child: const Text(
                          'クラブ（イベント開催場所）がなかった場合はこちら',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    CustomTextField(
                      controller: _priceController,
                      label: '料金',
                      keyboardType: TextInputType.number,
                    ),
                    ImagePickerSection(
                      onImagePathChanged: _setImagePath,
                    ),
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'イベント紹介文（任意）',
                      maxLength: 1000,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    GenreSelector(
                      selectedGenres: _selectedGenres,
                      onGenresChanged: (genres) {
                        setState(() {
                          _selectedGenres = genres;
                        });
                      },
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        onPressed: _registerEvent,
                        text: '登録する',
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<String?> _uploadImageToFireStorage(String imagePath, String eventId) async {
    try {
      if (eventId.isEmpty) {
        debugPrint('Error: eventId is null or empty');
        return null;
      }
      final file = File(imagePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storageRef = FirebaseStorage.instance.ref();
      final destination = 'events/$eventId/flyerImage/flyer_$timestamp.png';
      debugPrint(destination);
      final fileRef = storageRef.child(destination);

      final uploadTask = fileRef.putFile(file);

      try {
        TaskSnapshot snapshot = await uploadTask;
        final downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } on FirebaseException catch (e) {
        if (e.code == 'canceled') {
          debugPrint('Upload was canceled by the user');
        } else {
          debugPrint('Firebase Storage Error: ${e.code}');
          debugPrint('Error Message: ${e.message}');
        }
        return null;
      }
    } catch (e) {
      debugPrint('Unexpected error during image upload: $e');
      return null;
    }
  }

  // イベント登録処理
  Future<void> _registerEvent() async {
    setState(() {
      _isLoading = true;
    });
    final eventName = _eventNameController.text;
    final description = _descriptionController.text;
    final priceText = _priceController.text;
    final clubId = _selectedClubId;
    final eventId = GeneratedId().generateIdFromUuid();

    if (eventName.isEmpty || clubId == null || _startDate == null || _startTime == null || _endDate == null || _endTime == null || priceText.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('必須項目を入力してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int? entranceFee = int.tryParse(priceText);
    if (entranceFee == null) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('料金は数字で入力してください'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // DateTime オブジェクトを作成
    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );
    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    String? flyerPhotoUrl;
    if (_flyerImagePath != null) {
      flyerPhotoUrl = await _uploadImageToFireStorage(_flyerImagePath!, eventId);
      if (!mounted) return;
      if (flyerPhotoUrl == null) {
        setState(() => _isLoading = false);
        CustomSnackBar.show(
          context: context,
          message: 'フライヤー写真のアップロードに失敗しました',
          isSuccess: false,
        );
        return;
      }
    }


    final EventEntity registerEventEntity = EventEntity(
      eventId: eventId,
      clubId: clubId,
      eventName: eventName,
      flyerPhotoUrl: flyerPhotoUrl ?? '',
      description: description,
      date: _startDate!,
      startDatetime: startDateTime,
      endDatetime: endDateTime,
      entranceFee: entranceFee,
      genre: _selectedGenres.isNotEmpty ? _selectedGenres : null, 
    );

    try {
      await ref.read(registerEventProvider(registerEventEntity).future);

      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSuccessDialog(context);

    } on EventRegistrationException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showDuplicateEventsDialog(context, e.duplicateEvents);

    } catch (error) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      CustomSnackBar.show(
        context: context,
        message: 'イベントの追加に失敗しました',
        isSuccess: false,
      );
      debugPrint('イベント登録予期しないエラー: $error');
    }
  }

  void _showDuplicateEventsDialog(BuildContext context, List<EventEntity> duplicateEvents) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '同じイベントがすでに追加されています。',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 260,
                child: duplicateEvents.isEmpty
                    ? const Center(
                        child: Text(
                          'イベントが見つかりませんでした',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Center(
                        child: duplicateEvents.length == 1
                            ? AtomicEventCard(
                                event: duplicateEvents[0],
                                width: 150,
                                imageHeight: 200,
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: duplicateEvents.length,
                                separatorBuilder: (context, index) => const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  return AtomicEventCard(
                                    event: duplicateEvents[index],
                                    width: 150,
                                    imageHeight: 200,
                                  );
                                },
                              ),
                      ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('確認しました'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                'イベント申請完了',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'イベント申請が完了しました。\n審査完了後に掲載されます。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  text: '確認しました',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}