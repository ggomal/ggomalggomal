import 'package:flutter/material.dart';
import 'package:ggomal/widgets/kid_note.dart';
import 'package:ggomal/widgets/kid_report.dart';

class KidContent extends StatefulWidget {
  const KidContent({super.key});

  @override
  State<KidContent> createState() => _KidContentState();
}

class _KidContentState extends State<KidContent> with SingleTickerProviderStateMixin {

  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 800),
  );
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return

      Flexible(
        flex: 3,
        child: Container(

          child: Column(
              children: [TabBar(
                controller: tabController,

                tabs: const [
                  Tab(text: "학습 현황", height: 30,),
                  Tab(text: "알림장", height: 30,),
                ],
              ),Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        blurRadius: 5.0,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      KidReport(),
                      KidNote(),
                    ],
                  ),
                ),
              ),
              ]
          ),
        ),
      );
  }
}
