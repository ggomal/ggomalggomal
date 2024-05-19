import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ggomal/services/dio.dart';
import 'package:go_router/go_router.dart';

import '../../get_storage.dart';
import '../../utils/notification_dialog.dart';
import '../../widgets/kid_report.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  List<Map<String, dynamic>> _items = [];

  final List<Map<String, dynamic>> refer_items = [
    {"furnitureId": 0 ,"asset": 'assets/images/home/sofa.png',"asset2": 'assets/images/home/sofa2.png', "audio": 'images/home/audio/sofa.mp3', "x": -0.45, "y": -0.43, "width": 650, "isVisible": false, "name" : "소파", "size" : 250, "count" : 2},
    {"furnitureId": 0 ,"asset": 'assets/images/home/tv.png', "asset2": 'assets/images/home/tv2.png', "audio": 'images/home/audio/tv.mp3', "x": -0.99, "y": -0.2, "width": 370, "isVisible": false, "name" : "텔레비전", "size" : 130, "count" : 3},
    {"furnitureId": 0 ,"asset": 'assets/images/home/table.png', "asset2": 'assets/images/home/table2.png',"audio": 'images/home/audio/table.mp3', "x": -0.45, "y": 0.4, "width": 650, "isVisible": false, "name" : "식탁", "size" : 250, "count" : 4},
    {"furnitureId": 0 ,"asset": 'assets/images/home/chair.png', "asset2": 'assets/images/home/chair2.png',"audio": 'images/home/audio/chair.mp3', "x": 0.5, "y": -0.1, "width": 350, "isVisible": false, "name" : "의자", "size" : 120, "count" : 5},
    {"furnitureId": 0 ,"asset": 'assets/images/home/window.png', "asset2": 'assets/images/home/window2.png',"audio": 'images/home/audio/window.mp3', "x": 0.5, "y": -0.9, "width": 300, "isVisible": false, "name" : "창문", "size" : 130, "count" : 6},
    {"furnitureId": 0 ,"asset": 'assets/images/home/photo.png', "asset2": 'assets/images/home/photo2.png',"audio": 'images/home/audio/photo.mp3', "x": -0.9, "y": -0.9, "width": 200, "isVisible": false, "name" : "액자", "size" : 80, "count" : 7},
  ];

  Future<void> fetchFurniture() async {
    var dio = await useDio();
    var response = await dio.get('/furniture');
    var data = response.data as List;

    List<Map<String, dynamic>> newItems = [];

    for (var item in data) {
      Map<String, dynamic> newItem = {
        "furnitureId": item['id'],
        "asset": refer_items[item['id'] - 1]['asset'],
        "asset2": refer_items[item['id'] - 1]['asset2'],
        "audio": refer_items[item['id'] - 1]['audio'],
        "x": refer_items[item['id'] - 1]['x'], // 예시 값, 실제 애플리케이션에서는 적절히 조정
        "y": refer_items[item['id'] - 1]['y'], // 예시 값
        "width": refer_items[item['id'] - 1]['width'], // 예시 값
        "isVisible": item['acquired'],
        "name": item['name'],
        "size": refer_items[item['id'] - 1]['size'], // 예시 값
        "count": refer_items[item['id'] - 1]['count'], // 예시 계산
      };
      newItems.add(newItem);
    }

    // _items 업데이트
    setState(() {
      _items = newItems;
      print("fetchFurniture: _items 업데이트 완료");
    });
  }

  Future<void> buyFurniture(int index) async {
    print("=============================");
    print("물건 사기" );
    print(index);
    print("=============================");

    var dio = await useDio();
    var response = await dio.post('/furniture', data: {
      "furnitureId" : index
    });


    // if(response.data['isDone']){
    //   print("isDoneeeeeeeeeeeeeeeeee");
    //   setState(() {
    //     _items[index-1]['isVisible'] = true;
    //   });
    // }
    //
    // print(response.data);

    //await fetchFurniture();

    print(response.data);

    if (response.data['isDone'] == true) {
      print("가구 구매 성공, fetchFurniture 호출");
      await fetchFurniture();
    } else {
      print("가구 구매 실패");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFurniture();
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NavBarHome(items: _items, buyFurniture: buyFurniture,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: _items.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            if (!item['isVisible']) return Container();
            return Positioned(
              left: (screenSize.width / 2) * (1 + item['x']),
              top: (screenSize.height / 2) * (1 + item['y']),
              child: InkWell(
                onTap: () {
                  player.play(AssetSource(item['audio']));
                },
                child: Image.asset(item['asset'], width: item['width'] / 1.0,),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// NavBar
class NavBarHome extends StatelessWidget implements PreferredSizeWidget {
  final List<Map<String, dynamic>> items;
  final Future<void> Function(int) buyFurniture;
  
  const NavBarHome({
    required this.items, 
    required this.buyFurniture,
    super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget showPurchaseDialog2(BuildContext context, int index, int count, int furnitureId) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.6;
    double height = screenSize.height * 0.7;
    return Dialog(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/home/purchase_modal.png"),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Flexible(flex: 8, child: Container()),
                  Flexible(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          child: Text(
                            "${count}개",
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Maplestory',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      )),
                  Flexible(flex: 4, child: Container()),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: ElevatedButton(
                        onPressed: () async{
                          print("=================");
                          print(index + 1);
                          await buyFurniture(index + 1);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            "네",
                            style: TextStyle(
                                fontSize: 35,
                                fontFamily: 'Maplestory',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCFE4D1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide(
                                    color: Colors.black, width: 4.0))),
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            "아니오",
                            style: TextStyle(
                                fontSize: 35,
                                fontFamily: 'Maplestory',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFFD2D2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide(
                                    color: Colors.black, width: 4.0))),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    Get.find<CoinController>().coin();
    TextStyle baseText(double size, FontWeight weight) {
      return TextStyle(
        fontFamily: 'Maplestory',
        fontWeight: weight,
        fontSize: size,
        color: Colors.black,
      );
    }

    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.8;
    double height = screenSize.height * 0.8;

    return AppBar(
      backgroundColor: Color(0xffFFFEF1),
      toolbarHeight: preferredSize.height,
      leadingWidth: 320,
      centerTitle: true,
      leading: SizedBox(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                context.go('/kids');
              },
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                child: Image.asset('assets/images/home_button.png', fit: BoxFit.contain),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            width: width,
                            height: height,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/home/room_modal.png"),
                                  fit: BoxFit.fill,
                                )),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: Container(
                                            margin: EdgeInsets.only(top: 20, right: 20),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF39855E), shape: BoxShape.circle),
                                            child: Container(
                                                child: IconButton(
                                                  iconSize: height * 0.1,
                                                  icon: Icon(Icons.close, color: Colors.white),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )))),
                                  ],
                                ),
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                        margin: EdgeInsets.only(
                                            top: 10, left: 60, right: 60, bottom: 20),
                                        child: GridView.count(
                                          crossAxisCount: 3,
                                          // childAspectRatio: 1.0 / 0.7,
                                          childAspectRatio: 1 / 0.7, // 1:1 비율로 조정
                                          mainAxisSpacing: 10, // 세로 간격 추가
                                          crossAxisSpacing: 10, // 가로 간격 추가
                                          children:
                                          List.generate(items.length, (index) {
                                            var item = items[index];
                                            // if (!item['isVisible']) return Container();
                                            return InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (builder) {
                                                      return showPurchaseDialog2(
                                                          context, index, item['count'], item['furnitureId']);
                                                    });
                                              },
                                              child: Container(
                                                // padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        child: Text(item['name'],
                                                            style: TextStyle(
                                                                fontFamily: 'Maplestory',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 40)),
                                                      ),
                                                      item['isVisible'] ? Image.asset(
                                                        item['asset'],
                                                        fit: BoxFit.contain,
                                                        width: item['size'] / 1.0,
                                                      ) : Image.asset(
                                                        item['asset2'],
                                                        fit: BoxFit.contain,
                                                        width: item['size'] / 1.0,
                                                      ),
                                                    ],
                                                  )),
                                            );
                                          }),
                                        ),
                                      )
                                )
                              ],
                            ),
                          ));
                    }
                );
              },
              child:
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 0, 8),
                child: Image.asset('assets/images/room_button.png', fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),

      title: Container(
        height: kToolbarHeight + 20,
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: (
              ){
            showDialog(
                context: context,
                builder: (context) => NotificationDialog()
            );
          },
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/letter.png', width: 50,),
                Text(
                  ' 알림장  ',
                  style: baseText(25.0, FontWeight.w800),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: (
              ){
            showDialog(
              context: context,
              builder: (BuildContext context) => Dialog(
                backgroundColor: Colors.transparent,
                child:  SizedBox(
                  width: 1000, height: 600,
                  child: Stack(
                    children: [
                      Image.asset("assets/images/chick/chick_modal.png",
                          width: 1000, height: 600, fit: BoxFit.fill),
                      Center(child: SizedBox(width:800, height: 350, child: KidReport('0')))],
                  ),
                ),
              ),
            );
          },
          child: Container(
            child: Row(
              children: [
                Image.asset('assets/images/flower.png', width: 50),
                Text(
                  '학습현황  ',
                  style: baseText(25.0, FontWeight.w800),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Row(
            children: [
              Image.asset('assets/images/reward.png'),
              GetX<CoinController>(builder: (controller) {
                return Text(
                  'x ${controller.coinCount.value}',
                  style: baseText(30.0, FontWeight.w800),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

// 모달창
// class FurnitureDialog extends StatefulWidget {
//   const FurnitureDialog({super.key});
//
//   @override
//   State<FurnitureDialog> createState() => _FurnitureDialogState();
// }
//
// class _FurnitureDialogState extends State<FurnitureDialog> {
//   Widget showPurchaseDialog2(BuildContext context, int index, int count, int furnitureId) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width * 0.6;
//     double height = screenSize.height * 0.7;
//     return Dialog(
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/images/home/purchase_modal.png"),
//                 fit: BoxFit.fill)),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 5,
//               child: Container(
//                 color: Colors.transparent,
//               ),
//             ),
//             Expanded(
//               flex: 3,
//               child: Row(
//                 children: [
//                   Flexible(flex: 8, child: Container()),
//                   Flexible(
//                       flex: 2,
//                       child: Container(
//                         padding: EdgeInsets.only(top: 20),
//                         child: Container(
//                           child: Text(
//                             "${count}개",
//                             style: TextStyle(
//                                 fontSize: 40,
//                                 fontFamily: 'Maplestory',
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                       )),
//                   Flexible(flex: 4, child: Container()),
//                 ],
//               ),
//             ),
//             Expanded(
//               flex: 4,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 100),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       child: ElevatedButton(
//                         onPressed: () async{
//                           await Provider.of<FurnitureProvider>(context, listen: false).buyFurniture(index);
//                           Navigator.of(context).pop(); // 구매 다이얼로그 닫기
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 10),
//                           child: Text(
//                             "네",
//                             style: TextStyle(
//                                 fontSize: 35,
//                                 fontFamily: 'Maplestory',
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFFCFE4D1),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                                 side: BorderSide(
//                                     color: Colors.black, width: 4.0))),
//                       ),
//                     ),
//                     Container(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 10),
//                           child: Text(
//                             "아니오",
//                             style: TextStyle(
//                                 fontSize: 35,
//                                 fontFamily: 'Maplestory',
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black),
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                             backgroundColor: Color(0xFFFFD2D2),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(40),
//                                 side: BorderSide(
//                                     color: Colors.black, width: 4.0))),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(flex: 1, child: Container())
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double width = screenSize.width * 0.8;
//     double height = screenSize.height * 0.8;
//
//     var furnitureProvider = Provider.of<FurnitureProvider>(context);
//
//     return Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           width: width,
//           height: height,
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage("assets/images/home/room_modal.png"),
//                 fit: BoxFit.fill,
//               )),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Flexible(
//                       flex: 1,
//                       child: Container(
//                           margin: EdgeInsets.only(top: 20, right: 20),
//                           decoration: BoxDecoration(
//                               color: Color(0xFF39855E), shape: BoxShape.circle),
//                           child: Container(
//                               child: IconButton(
//                                 iconSize: height * 0.1,
//                                 icon: Icon(Icons.close, color: Colors.white),
//                                 onPressed: () {
//                                   Navigator.of(context).pop();
//                                 },
//                               )))),
//                 ],
//               ),
//               Flexible(
//                 flex: 6,
//                 child: Consumer<FurnitureProvider>(
//                   builder: (context, furnitureState, child) {
//                     return Container(
//                       margin: EdgeInsets.only(
//                           top: 10, left: 60, right: 60, bottom: 20),
//                       child: GridView.count(
//                         crossAxisCount: 3,
//                         // childAspectRatio: 1.0 / 0.7,
//                         childAspectRatio: 1 / 0.7, // 1:1 비율로 조정
//                         mainAxisSpacing: 10, // 세로 간격 추가
//                         crossAxisSpacing: 10, // 가로 간격 추가
//                         children:
//                         List.generate(furnitureState.items.length, (index) {
//                           var item = furnitureState.items[index];
//                           // if (!item['isVisible']) return Container();
//                           return InkWell(
//                             onTap: () {
//                               showDialog(
//                                   context: context,
//                                   builder: (builder) {
//                                     return showPurchaseDialog2(
//                                         context, index, item['count'], item['furnitureId']);
//                                   });
//                             },
//                             child: Container(
//                               // padding: EdgeInsets.all(10),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       child: Text(item['name'],
//                                           style: TextStyle(
//                                               fontFamily: 'Maplestory',
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 40)),
//                                     ),
//                                     item['isVisible'] ? Image.asset(
//                                       item['asset'],
//                                       fit: BoxFit.contain,
//                                       width: item['size'] / 1.0,
//                                     ) : Image.asset(
//                                       item['asset2'],
//                                       fit: BoxFit.contain,
//                                       width: item['size'] / 1.0,
//                                     ),
//                                   ],
//                                 )),
//                           );
//                         }),
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }


