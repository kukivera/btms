


import 'program_model.dart';

class FetchPrograms {
  final ProgramRepository repository;

  FetchPrograms(this.repository);

  Stream<List<Program>> execute() {
    return repository.getProgramsStream();
  }
}