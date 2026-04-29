import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_provider.dart';
import '../providers/location_visibility_state_notifier.dart';
import '../widgets/custom_snackbar.dart';

class LocationSettingsModal extends ConsumerStatefulWidget {
  const LocationSettingsModal({super.key});

  @override
  ConsumerState<LocationSettingsModal> createState() => _LocationSettingsModalState();
}

class _LocationSettingsModalState extends ConsumerState<LocationSettingsModal> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  Future<void> _initializeSettings() async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser != null) {
      await ref.read(locationVisibilityProvider.notifier).fetchSetting(currentUser.uid);
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  String _getButtonTitle(LocationVisibilitySettingType type) {
    switch (type) {
      case LocationVisibilitySettingType.EVERYONE:
        return "だれでも";
      case LocationVisibilitySettingType.FOLLOWERS:
        return "相互フォローのみ";
      case LocationVisibilitySettingType.CLOSE_FRIENDS:
        return "親しい友達のみ"; // ここは残しますが表示はしません
      case LocationVisibilitySettingType.NONE:
        return "共有しない";
    }
  }

  Widget _buildContent(bool isLoading, LocationVisibilityState state, UserEntity? currentUser, ScrollController scrollController) {
    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator()
      );
    }

    return Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "位置情報の設定",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF3E3E3E),
                          Color(0xFF2C2C2C),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "※クラブの半径100m以内にいるときのみ位置情報が公開されます。",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "共有範囲",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...[
                    LocationVisibilitySettingType.EVERYONE,
                    LocationVisibilitySettingType.FOLLOWERS,
                    LocationVisibilitySettingType.NONE,
                  ].map((type) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(locationVisibilityProvider.notifier).updateSelectedSetting(type);
                          },
                          child: _buildOptionButton(
                            _getButtonTitle(type),
                            state.setting == type,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: !isLoading ? () async {
                      if (currentUser != null) {
                        try {
                          await ref.read(locationVisibilityProvider.notifier).saveSettings(currentUser.uid);
                          if (context.mounted) {
                            CustomSnackBar.show(
                              context: context,
                              message: '位置情報設定を更新しました',
                              isSuccess: true,
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                             CustomSnackBar.show(
                              context: context,
                              message: '位置情報設定の更新に失敗しました',
                              isSuccess: false,
                            );
                          }
                        }
                      }
                    } : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        gradient: !isLoading
                            ? const LinearGradient(
                                colors: [
                                  Color(0xFF6C5EE3),
                                  Color(0xFF2F83EC),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                            : null,
                        color: isLoading
                            ? const Color(0xFF444444)
                            : null,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          '更新',
                          style: TextStyle(
                            color: !isLoading
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationVisibilityProvider);
    final currentUser = ref.watch(currentUserProvider).value;
    final isLoading = state.isLoading;
    bool isClosing = false;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (notification.extent < 0.2 && !isClosing) {
          isClosing = true;
          if (context.mounted) {
            Navigator.of(context).maybePop();
          }
        }
        return true;
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [1.0],
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: _buildContent(isLoading, state, currentUser, scrollController),
          );
        },
      ),
    );
  }

  Widget _buildOptionButton(String title, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [
                  Color(0xFF6C5EE3),
                  Color(0xFF2F83EC),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isSelected ? null : const Color(0xFF222222),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}