// // lib/data/dummy/club_data.dart
// import '../../domain/entities/marker_model.dart';
// import '../../domain/entities/event_model.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

// final List<ClubMarkerModel> clubMarkers = [
//   ClubMarkerModel(
//     Position(139.695274, 35.658306),
//     'HARLEM TOKYO',
//     'assets/harlem.png',
//     '東京都渋谷区円山町2−4 Dr.ジーカンス',
//     '1997年のオープン以来、日本における“HIP HOPの聖地”として支持され続けているHARLEMは、今日では日本はもとより海外でもその名を知られるようになっている。 HIP HOPのクラブとしてはケタ外れなダンスフロアを操るDJ陣は、まさに日本最高峰と言っても過言ではない。加えて、海外からのDJ・ARTISTの招聘も定期的に行い、真のHIP HOP PARTYを体感できるのも魅力の一つであろう。年間を通してのべ16万人を超える集客数を誇るHARLEMの魅力は毎週火・木・金・土曜のレギュラーイベントのみならず、JAPANESE HIP HOPを語る上で欠くことの出来ないイベントがめじろ押し。クラブ初心者から上級者まで楽しめるクラブとして、国内外にその名を轟かせている。',
//     [
//       Event(
//         title: 'SABATO vol.2',
//         date: '2024.11.08',
//         time: 'OPEN 22:00 CLOSE 5:00',
//         entryFee: 3000,
//         description: 'イベント詳細...',
//         imagePath: 'assets/sabato2ree.png',
//         artists: ['JohnKNihil', 'OROCHI & ISSAEA'],
//         djs: ['AKIRA ORPHEUS'],
//         heads: ['キャベツ太郎', 'minami', 'ayaka'],
//       ),
//     ],
//   ),
//   ClubMarkerModel(
//     Position(139.701902, 35.662259),
//     'OR',
//     'assets/orTokyo.jpg',
//     '東京都渋谷区道玄坂2−4−3 ORビル',
//     '人・音楽・アートが交差するカルチャーハブステーション OR” ストリート / アート / ファッション / ミュージック / デザインに焦点を当て、サスティナブルな社会に対する取り組みも実施する複合型エンターテインメント施設は、1 階カフェ ・2 階アートギャ ラリー ・3 階ミュージックバーの3階層から構成され、フロア毎に多彩なジャンルの音楽を最良のサ ウンドシステムで楽しむことができます。 また店内にはポップアップスペース、アートギャラリー、 ショーウィンドウが設置され、最新のアートやデザインにも触れることができます。',
//     [
//       Event(
//         title: 'MIDNIGHT PARTY',
//         date: '2024.11.15',
//         time: 'OPEN 22:00 CLOSE 5:00',
//         entryFee: 4000,
//         description: '大人気DJによるクラブイベント。',
//         imagePath: 'assets/sabato2ree.png',
//         artists: ['DJ SOMEBODY'],
//         djs: ['DJ SOMEBODY'],
//         heads: ['ユーザー1', 'ユーザー2'],
//       ),
//     ],
//   ),
//   ClubMarkerModel(
//     Position(139.705597, 35.654169),
//     'CIRCUS Tokyo', 
//     'assets/CircusTokyo.png',
//     '東京都渋谷区渋谷３丁目２６−１６ 第５叶ビル 1F/B1F',
//     '2015年にクローズしたAMRAX(アマテラグジー)の跡地。 大阪アメリカ村のCLUB CIRCUSの姉妹店。 渋谷駅東口駅前の立体歩道橋を登り、明治通りを恵比寿方面に直進。CIRCUS Tokyoは、国内外からのクラブミュージック界からトップアーティストが集結し、ダンスミュージックやアンダーグラウンドDJを中心としたリアルなダンスカルチャーを発信しています。',
//     [
//       Event(
//         title: 'MIDNIGHT PARTY',
//         date: '2024.11.15',
//         time: 'OPEN 22:00 CLOSE 5:00',
//         entryFee: 4000,
//         description: '大人気DJによるクラブイベント。',
//         imagePath: 'assets/sabato2ree.png',
        // artists: ['DJ SOMEBODY'],
        // djs: ['DJ SOMEBODY'],
        // heads: ['ユーザー1', 'ユーザー2'],
//       ),
//     ]
//   ),
//   ClubMarkerModel(
//     Position(139.667672, 35.660842),
//     'SPREAD 下北沢',
//     'assets/spread.jpg',
//     '東京都世田谷区北沢2-12-6 リバーストーンビルB1F',
//     '下北沢駅から歩いて徒歩1分のナイトクラブSPREAD(スプレッド)です。こだわりのサウンドシステムと豊富なお酒をご用意しており、非日常をご体感していただくことができます。下北沢のSPREADにぜひ足をお運びください。',
//     [
//       Event(
//         title:'The Summer Sumash',
//         date: '2024.11.15',
//         time: 'OPEN 22:00 CLOSE 5:00',
//         entryFee: 4000,
//         description: '大人気DJによるクラブイベント。',
//         imagePath: 'assets/lemonade.png',
//         artists: ['DJ SOMEBODY'],
//         djs: ['DJ SOMEBODY'],
//         heads: ['ユーザー1', 'ユーザー2'],
//       ),
//     ]
//   ),
//   ClubMarkerModel(
//     Position(139.70055, 35.695967),
//     'ZERO TOKYO', 
//     'assets/zerotokyo.png', 
//     '東京都新宿区歌舞伎町１丁目２９−１', 
//     '新宿歌舞伎町のナイトエンターテインメント施設が「ZEROTOKYO」。「ENTERTAINMENT JUNCTION」をコンセプトに掲げ、これまでにない新たなエンターテインメント体験を生み出し、様々な人の”好きを極める”場となることを目指します', 
//     [
//       Event(
//         title: 'TOKIO F1lthy',
//         date: '2024.11.15',
//         time: 'OPEN 22:00 CLOSE 5:00',
//         entryFee: 4000,
//         description: '大人気DJによるクラブイベント。',
//         imagePath: 'assets/f1lthy.png',
//         artists: ['DJ SOMEBODY'],
//         djs: ['DJ SOMEBODY'],
//         heads: ['ユーザー1', 'ユーザー2'],
//       ),
//     ]
//   ),
//     ClubMarkerModel(
//     Position(139.668119, 35.638219),
//     '3pm TOKYO', 
//     'assets/3pmshop.jpg', 
//     '東京都世田谷区上馬１丁目１７−８ モリヤビル', 
//     '三軒茶屋にあるハンバーガーショップ。DJブースもあり、時には音楽イベントも。多様なカルチャーが集う異色のハンバーガー店', 
//     [
//       Event(
//         title: 'YEAR END PARTY',
//         date: '2024.12.13',
//         time: 'OPEN 22:00 CLOSE 4:00',
//         entryFee: 4000,
//         description: '大人気DJによるクラブイベント。',
//         imagePath: 'assets/3pmtokyo.jpg',
//         artists: ['DJ SOMEBODY'],
//         djs: ['DJ SOMEBODY'],
//         heads: ['ユーザー1', 'ユーザー2'],
//       ),
//     ]
//   ),
// ];
