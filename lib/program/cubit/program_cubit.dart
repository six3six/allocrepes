import 'package:bloc/bloc.dart';

import 'program_state.dart';

class ProgramCubit extends Cubit<ProgramState> {
  ProgramCubit() : super(const ProgramState());
}
