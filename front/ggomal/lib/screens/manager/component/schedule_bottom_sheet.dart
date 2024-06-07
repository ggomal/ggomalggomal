import 'package:flutter/material.dart';

import '../../../services/dio.dart';
import '../const/color.dart';
import '../model/Schedule.dart';
import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDay;
  final Function fetchSchedules;

  const ScheduleBottomSheet({Key? key, required this.selectedDay, required this.fetchSchedules}) : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> fomrmKey = GlobalKey();

  int? startTime;
  int? endTime;
  String? content;
  String? category;

  String selectedColor = categoryColors.first;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // double width = screenSize.width * 0.6;
    // double height = screenSize.height * 0.7;
    return Container(
      width: screenSize.width * 0.5,
      height: screenSize.height * 0.7,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12)
        ),
      child: Form(
        key: fomrmKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,  // 최소 크기 조정
          children: [
            _Time(
              onEndSaved: onEndTimeSave,
              onEndValidate: onEndTimeValidate,
              onStartSaved: onStartTimeSaved,
              onStartValidate: onStartTimeValidate,
            ),
            SizedBox(height: 8.0,),
            _Content(
              onSaved: onContentSaved,
              onValidate: onContentValidate,
            ),
            SizedBox(height: 8.0,),
            _Categories(
              selectedColor: selectedColor,
              onTap: (String color){
                setState(() {
                  selectedColor = color;
                });
              },
            ),
            SizedBox(height: 8.0,),
            _SaveButton(onPressed: onSavePressed,)
          ],
        ),
      ),
    );
  }

  void onStartTimeSaved(String? val){
    if(val == null) return;
    startTime = int.parse(val);
  }

  String? onStartTimeValidate(String? val){

  }

  void onEndTimeSave(String? val){
    if(val == null) return;
    endTime = int.parse(val);
  }

  String? onEndTimeValidate(String? val){

  }

  void onContentSaved(String? val){
    if(val == null) return;
    content = val;
  }

  String? onContentValidate(String? val){

  }

  DateTime combineDateWithTime(DateTime date, int time) {
    int hours = time ~/ 100; // 시간 부분을 추출
    int minutes = time % 100; // 분 부분을 추출
    return DateTime(date.year, date.month, date.day, minutes, hours);
  }



  void onSavePressed() async{
    fomrmKey.currentState!.save();

    DateTime startDateTime = combineDateWithTime(widget.selectedDay, startTime!);
    DateTime endDateTime = combineDateWithTime(widget.selectedDay, endTime!);

    // ISO 8601 형식의 문자열로 변환
    String startTimeString = startDateTime.toIso8601String().substring(0, 16);
    String endTimeString = endDateTime.toIso8601String().substring(0, 16);

    // print(startTimeString);
    // print(endTimeString);

    var dio = await useDio();
    final response = await dio.post('/schedule', data: {
      "kidId" : 4, // 사실 없어두 됨
      "startTime" : startTimeString,
      "endTime" : endTimeString,
      "content" : content
    });

    print("============================");
    print(response.data);
    print("============================");

    print(startTime);
    print(endTime);
    print(content);
    print(category);

    // 저장 로직 후에 스케줄을 갱신
    widget.fetchSchedules();
    Navigator.of(context).pop(); // 다이얼로그 닫기
  }

}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;

  _Time({
    required this.onStartSaved,
    required this.onEndSaved,
    required this.onStartValidate,
    required this.onEndValidate,
    super.key});

  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: CustomTextField(
                  label: '시작 시간',
                  onSaved: onStartSaved,
                  validator: onStartValidate,
                )),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
                child: CustomTextField(
                  label: '마감 시간',
                  onSaved: onEndSaved,
                  validator: onEndValidate,
                )),
          ],
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> onValidate;
  // final String? initialValue;

  const _Content({
    required this.onSaved,
    required this.onValidate,
    // this.initialValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
          label: '내용',
          expand: true,
          onSaved: onSaved,
          validator: onValidate,
        ));
  }
}

typedef onColorSelected = void Function(String color);

class _Categories extends StatelessWidget {
  final String selectedColor;
  final onColorSelected onTap;

  const _Categories({
    required this.selectedColor,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        children: categoryColors
            .map((e) =>
            Padding(
              padding:
              const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: (){
                  onTap(e);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse('FF$e', radix: 16),
                    ),
                    border: e == selectedColor ? Border.all(
                        color: Colors.black,
                        width: 4.0
                    ) : null,
                    shape: BoxShape.circle,
                  ),
                  width: 32.0,
                  height: 32.0,
                ),
              ),
            ))
            .toList()
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white
              ),
              child: Text('저장')
          ),
        ),
      ],
    );
  }
}



