import '../../../../core/enums/enums.dart';

/// Issue repository interface
abstract class IssueRepository {
  Future<void> reportIssue({
    required String orderId,
    required IssueType type,
    String? description,
  });
}
