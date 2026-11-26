import 'package:shared_preferences/shared_preferences.dart';

abstract class OrganizationStorage {
  Future<void> saveOrganizationId(String organizationId);
  Future<String?> getOrganizationId();
  Future<void> clear();
}

class SharedPreferencesOrganizationStorage implements OrganizationStorage {
  static const String _orgIdKey = 'selected_organization_id';

  final SharedPreferences? prefs;

  SharedPreferencesOrganizationStorage({this.prefs});

  Future<SharedPreferences> get _instance async =>
      prefs ?? await SharedPreferences.getInstance();

  @override
  Future<void> saveOrganizationId(String organizationId) async {
    final prefs = await _instance;
    await prefs.setString(_orgIdKey, organizationId);
  }

  @override
  Future<String?> getOrganizationId() async {
    final prefs = await _instance;
    return prefs.getString(_orgIdKey);
  }

  @override
  Future<void> clear() async {
    final prefs = await _instance;
    await prefs.remove(_orgIdKey);
  }
}
