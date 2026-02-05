import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/delivery_agent_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current user
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Execute get current user
  Future<Either<Failure, DeliveryAgentEntity>> call() async {
    return await _repository.getCurrentUser();
  }
}
