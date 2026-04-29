import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  final String eventImagePath; // イベント画像のパス
  final String eventName; // イベント名

  const FeedbackScreen({
    super.key,
    required this.eventImagePath,
    required this.eventName,
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int? _selectedFeedback; // 選択されたフィードバックのインデックス

  final List<Map<String, dynamic>> feedbackOptions = [
    {"imagePath": "assets/love_smile.png", "label": "よかった"},
    {"imagePath": "assets/normal_smile.png", "label": "ふつう"},
    {"imagePath": "assets/angry.png", "label": "いまいち"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // スキップボタン
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextButton(
                    onPressed: () {
                    // スキップボタンのアクション
                  },
                  child: const Text(
                    "スキップ",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 質問テキスト
              const Text(
                "参加したライブは\nどうでしたか？",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // イベント画像
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  widget.eventImagePath, // プロパティから取得
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              // イベント名
              Text(
                widget.eventName, // プロパティから取得
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // フィードバックオプション
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: feedbackOptions
                    .asMap()
                    .entries
                    .map((entry) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFeedback = entry.key;
                            });
                          },
                          child: Container(
                            width: 105,
                            height: 105,
                            decoration: BoxDecoration(
                              gradient: _selectedFeedback == entry.key
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Color(0xFF6C5EE3), Color(0xFF2F83EC)],
                                    )
                                  : null,
                              color: _selectedFeedback == entry.key
                                  ? null
                                  : const Color(0xFF242930), // デフォルトの背景色
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                if (_selectedFeedback == entry.key)
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    entry.value["imagePath"] as String,
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.value["label"] as String,
                                  style: TextStyle(
                                    color: _selectedFeedback == entry.key
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              // フィードバック説明
              const Text(
                "このフィードバックはライブ関係者に共有されません。\nHEADSのおすすめイベントの参考にさせていただきます。",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              // 次へボタン
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedFeedback != null
                      ? () {
                          // 次へボタンのアクション
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: _selectedFeedback != null
                          ? const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xFF6C5EE3), Color(0xFF2F83EC)],
                            )
                          : null,
                      color: _selectedFeedback != null ? null : Colors.grey,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 50,
                      ),
                      child: const Text(
                        "決定",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
