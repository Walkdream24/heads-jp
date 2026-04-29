import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/name_input_page.dart';
import '../pages/login_page.dart';
import '../widgets/custom_snackbar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 200), // 上部のスペース
            SvgPicture.asset(
              'assets/heads.svg',
              width: 250,
            ),
            const SizedBox(height: 20.0),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (context) {
                          return const NameInputPage();
                        }),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF6C5EE3), Color(0xFF2F83EC)],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: const Text(
                          '新規登録する',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                GestureDetector(
                  onTap: () {
                    // ログインボタンの処理
                  },
                  child: const Text(
                    'すでにHEADSアカウントをお持ちですか？',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      color: Color(0xFF2F83EC),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => launchWebUrl(context, 'https://headsapp.jp/%e5%88%a9%e7%94%a8%e8%a6%8f%e7%b4%84/'),
                          child: const Text(
                            '利用規約',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Text(
                          '   と   ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => launchWebUrl(context, 'https://headsapp.jp/%e3%83%97%e3%83%a9%e3%82%a4%e3%83%90%e3%82%b7%e3%83%bc%e3%83%9d%e3%83%aa%e3%82%b7%e3%83%bc/'),
                          child: const Text(
                            'プライバシーポリシー',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300), // 最大横幅を制限
                      child: const Text(
                        'HEADSを利用することで利用規約およびプライバシーポリシーに同意したものとします',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24.0), // 下部のスペース
          ],
        ),
      ),
    );
  }
  void launchWebUrl(BuildContext context, String url) async {
    final Uri parsedUrl = Uri.parse(url);
    try {
      if (await canLaunchUrl(parsedUrl)) {
        await launchUrl(parsedUrl, mode: LaunchMode.externalApplication);
      } else {
        // URLを開けない場合のエラーハンドリング
        CustomSnackBar.show(
          context: context,
          message: 'URLを開くことができませんでした',
          isSuccess: false,
        );
      }
    } catch (e) {
      // 例外発生時のエラーハンドリング
      CustomSnackBar.show(
        context: context,
        message: 'エラーが発生しました',
        isSuccess: false,
      );
    }
  }
}