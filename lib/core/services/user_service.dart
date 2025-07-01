class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();
  
  UserService._();
  
  // Datos del usuario logueado
  Map<String, dynamic>? _currentUser;
  
  // Guardar los datos del usuario después del login
  void setCurrentUser(Map<String, dynamic> userData) {
    _currentUser = userData;
  }
  
  // Obtener los datos del usuario actual
  Map<String, dynamic>? get currentUser => _currentUser;
  
  // Obtener el nombre del usuario
  String get userName => _currentUser?['user']?['name'] ?? 'Usuario';
  
  // Obtener el email del usuario
  String get userEmail => _currentUser?['user']?['email'] ?? '';
  
  // Obtener el ID del usuario
  int? get userId => _currentUser?['user']?['id'];
  
  // Obtener el tipo de usuario
  String get userType => _currentUser?['user']?['tipoUsuario'] ?? '';
  
  // Verificar si hay un usuario logueado
  bool get isLoggedIn => _currentUser != null;
  
  // Limpiar los datos del usuario (logout)
  void clearUser() {
    _currentUser = null;
  }
}
