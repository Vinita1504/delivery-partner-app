import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/delivery_agent_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for delivery agent login
/// Single Responsibility: handles only the login logic
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Execute login with email and password
  Future<Either<Failure, DeliveryAgentEntity>> call(
    String email,
    String password,
  ) async {
    return await _repository.login(email, password);
  }
}
