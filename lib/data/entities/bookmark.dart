
import 'package:floor/floor.dart';

@entity
class Bookmark {
  @primaryKey
  int catalogueId;
  int pageNumber;

  Bookmark({required this.catalogueId, required this.pageNumber});
}