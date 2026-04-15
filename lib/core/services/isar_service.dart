import 'package:isar/isar.dart';

class IsarService {
  late final Isar isar;

  IsarService() {
    isar = Isar.getInstance()!;
  }
}