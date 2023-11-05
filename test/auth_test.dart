import 'package:beebnotes/services/auth/auth_exceptions.dart';
import 'package:beebnotes/services/auth/auth_provider.dart';
import 'package:beebnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized',
        () => expect(provider._isInitialized, false));
    test(
        'Cannot log out if not initialized',
        () => expect(provider.logout(),
            throwsA(const TypeMatcher<NotInitializedException>())));
    test('should be able to be Initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should be null afterbinitialization',
        () => expect(provider.currentUser, null));
    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));
    test('create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'beeb@gee.vom',
        password: 'whatever',
      );
      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final invalidCredential = provider.createUser(
        email: 'anything.com',
        password: 'foobarbaz',
      );
      expect(invalidCredential,
          throwsA(const TypeMatcher<InvalidCredentialsAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to logout and login in again', () async {
      await provider.logout();
      await provider.login(email: 'email', password: 'password');
    });
    final user = provider.currentUser;
    expect(user, isNotNull);
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'beeb@gee.vom') throw UserNotFoundAuthException();
    if (password == 'foobarbaz') throw InvalidCredentialsAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'beeb@gee.vom',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logout() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      email: 'beeb@gee.vom',
    );
    _user = newUser;
  }
}
