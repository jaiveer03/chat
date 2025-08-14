import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService apiService;
  AuthRepository(this.apiService);

  Future<UserModel> login(String email, String password, String role) async {
    try {
      final response = await apiService.post(
        '/user/login',
        {
          "email": email,
          "password": password,
          "role": role,
        },
      );
      final user = UserModel.fromJson(response.data['data']['user']);
      return user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
