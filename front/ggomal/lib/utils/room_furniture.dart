import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../states/furniture_state.dart';

class FurnitureDialog extends StatefulWidget {
  const FurnitureDialog({super.key});

  @override
  State<FurnitureDialog> createState() => _FurnitureDialogState();
}

class _FurnitureDialogState extends State<FurnitureDialog> {
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
                        onPressed: () {
                          Provider.of<FurnitureState>(context, listen: false)
                              .unlockItem(index, furnitureId);
                          Navigator.pop(context);
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
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width * 0.8;
    double height = screenSize.height * 0.8;
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
                child: Consumer<FurnitureState>(
                  builder: (context, furnitureState, child) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 60, right: 60, bottom: 20),
                      child: GridView.count(
                        crossAxisCount: 3,
                        // childAspectRatio: 1.0 / 0.7,
                        childAspectRatio: 1 / 0.7, // 1:1 비율로 조정
                        mainAxisSpacing: 10, // 세로 간격 추가
                        crossAxisSpacing: 10, // 가로 간격 추가
                        children:
                            List.generate(furnitureState.items.length, (index) {
                          var item = furnitureState.items[index];
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
                                Image.asset(
                                  item['asset2'],
                                  fit: BoxFit.contain,
                                  width: item['size'] / 1.0,
                                ),
                              ],
                            )),
                          );
                        }),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
