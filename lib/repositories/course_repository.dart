import 'package:isar/isar.dart';
import '../models/course.dart';
import '../core/services/isar_service.dart';

class CourseRepository {
  final IsarService _isarService;

  CourseRepository(this._isarService);

  Stream<List<Course>> watchCourses() {
    return _isarService.isar.courses.where().sortByName().watch(fireImmediately: true);
  }

  Future<void> saveCourse(Course course) async {
    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.courses.put(course);
    });
  }

  Future<void> deleteCourse(Id id) async {
    await _isarService.isar.writeTxn(() async {
      await _isarService.isar.courses.delete(id);
    });
  }

  Future<List<Course>> getAllCourses() async {
    return await _isarService.isar.courses.where().findAll();
  }
}