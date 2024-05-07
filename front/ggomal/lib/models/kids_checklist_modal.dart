enum CheckListState { SUCCESS, FAIL }

class ChecklistItem {
  String content; // 체크리스트 항목의 내용
  bool isChecked; // 체크박스의 현재 체크 상태
  CheckListState state; // 항목의 상태 (성공, 실패)

  ChecklistItem({required this.content, this.isChecked = false, this.state = CheckListState.FAIL});

  // 선택적: 객체의 현재 상태를 쉽게 출력할 수 있는 메서드
  @override
  String toString() {
    return 'Item: $content, Checked: $isChecked, State: $state';
  }
}
