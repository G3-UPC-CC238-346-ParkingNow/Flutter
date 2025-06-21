import '../datasources/auth_api_service.dart';

class AuthRepositoryImpl {
  final AuthApiService apiService;
  AuthRepositoryImpl(this.apiService);

  Future<Map<String, dynamic>> registerOwner(Map<String, dynamic> ownerData) {
    return apiService.registerOwner(ownerData);
  }

  Future<Map<String, dynamic>> registerLocal(Map<String, dynamic> localData) {
    return apiService.registerLocal(localData);
  }

  Future<void> registerOwnerAndLocal(Map<String, dynamic> ownerData, Map<String, dynamic> localData) async {
    final owner = await registerOwner(ownerData);
    final localBody = {
      ...localData,
      'usuario': {'id': owner['id']},
    };
    await registerLocal(localBody);
  }
}