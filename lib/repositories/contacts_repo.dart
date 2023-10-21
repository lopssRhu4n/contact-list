import 'package:contact_list/http/dio_http_adapter.dart';
import 'package:contact_list/models/contact_model.dart';
import 'package:contact_list/repositories/respository.dart';
import 'package:dio/dio.dart';

class ContactRepository implements Repository<ContactModel> {
  late final Dio http;

  ContactRepository() {
    http = DioHttpAdapter().dio;
  }

  @override
  Future<ContactModel?> save(Map<String, dynamic> json) async {
    try {
      var res = await http.post('Contact', data: json);
      if (res.statusCode == 200) {
        var model = ContactModel();
        model.fromJson(json);
        return model;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> delete(String objId) async {
    try {
      await http.delete('Contact/$objId');
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<ContactModel?> get(String objId) async {
    try {
      var res = await http.get('Classes?where={"objectId": "$objId"}');

      var model = ContactModel();

      if ((res.data['results'] as List<dynamic>).isNotEmpty) {
        model.fromJson(res.data['results'][0]);
        return model;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ContactModel>?> list() async {
    try {
      var res = await http.get('Contact');
      if (res.statusCode == 200) {
        if ((res.data['results'] as List<dynamic>).isNotEmpty) {
          var result = res.data['results'] as List<dynamic>;

          List<ContactModel> modelsList = result.map((element) {
            var model = ContactModel();
            model.fromJson(element);
            return model;
          }).toList();

          return modelsList;
        }
      }
      return [];
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> update(String objId, Map<String, dynamic> data) async {
    try {
      var res = await http.put('Contact/$objId', data: data);
      return true;
    } catch (e) {
      return false;
    }
  }
}
