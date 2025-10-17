// Mock AuthService for demo purposes - no backend required
class AuthService {
  // Mock user data
  static const _mockUser = {
    'id': 'mock-user-123',
    'email': 'demo@vista.com',
    'full_name': 'Demo User',
  };

  // Sign up with email (mock)
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return {'user': _mockUser, 'session': 'mock-session'};
  }

  // Sign in with email (mock)
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return {'user': _mockUser, 'session': 'mock-session'};
  }

  // Sign out (mock)
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Get current user (mock)
  Map<String, dynamic>? get currentUser => _mockUser;

  // Check if user is authenticated (mock)
  bool get isAuthenticated => true;

  // Create or update user profile (mock)
  Future<Map<String, dynamic>?> createUserProfile({
    required String fullName,
    required String businessName,
    required String role,
    String? city,
    String? phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return {
      'id': _mockUser['id'],
      'email': _mockUser['email'],
      'full_name': fullName,
      'business_name': businessName,
      'role': role,
      'city': city,
      'phone_number': phoneNumber,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Get user profile (mock)
  Future<Map<String, dynamic>?> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'id': _mockUser['id'],
      'email': _mockUser['email'],
      'full_name': 'Demo User',
      'business_name': 'Demo Business',
      'role': 'vendor',
      'city': 'Demo City',
      'phone_number': '+1234567890',
    };
  }

  // Send password reset email (mock)
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
