
import 'package:floor/floor.dart';

@entity
class Bookmark {
  @primaryKey
  int fileId;
  int pageNumber;

  Bookmark({required this.fileId, required this.pageNumber});
}