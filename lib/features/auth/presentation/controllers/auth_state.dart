import '../../domain/entities/delivery_agent_entity.dart';

/// Auth state for managing authentication
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final DeliveryAgentEntity? agent;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.agent,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    DeliveryAgentEntity? agent,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      agent: agent ?? this.agent,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
