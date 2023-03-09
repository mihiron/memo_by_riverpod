import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditState extends StateNotifier<bool> {
  EditState() : super(false);

  void toggleEditMode() {
    state = !state;
  }
}

final editProvider =
    StateNotifierProvider<EditState, bool>((ref) => EditState());
