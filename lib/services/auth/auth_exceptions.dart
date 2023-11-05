//loginview
class UserNotFoundAuthException implements Exception {}

class InvalidCredentialsAuthException implements Exception {}

//Registerview
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
