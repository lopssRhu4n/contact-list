import 'package:contact_list/models/model.dart';

abstract class Repository<M extends Model> {
  Future<M?> save(Map<String, dynamic> json);
  Future<bool> delete(String objId);
  Future<bool> update(String objId, Map<String, dynamic> data);
  Future<M?> get(String objId);
  Future<List<M>?> list();
}
