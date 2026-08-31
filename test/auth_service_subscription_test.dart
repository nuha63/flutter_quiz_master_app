import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_master/services/auth_service.dart';

void main() {
  group('AuthService subscription helper', () {
    test('accepts registered and pending activation states for login access',
        () {
      expect(AuthService.isSubscriptionStatusActive('REGISTERED'), isTrue);
      expect(
        AuthService.isSubscriptionStatusActive('INITIAL CHARGING PENDING'),
        isTrue,
      );
      expect(AuthService.isSubscriptionStatusActive('PENDING'), isTrue);
      expect(AuthService.isSubscriptionStatusActive('UNREGISTERED'), isFalse);
    });
  });
}
