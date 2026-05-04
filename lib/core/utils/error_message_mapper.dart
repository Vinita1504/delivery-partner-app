import '../errors/failures.dart';
import 'package:dio/dio.dart';

abstract final class ErrorMessageMapper {
  /// Maps a [Failure] sealed subclass -> UX-friendly string.
  static String fromFailure(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is AuthFailure) {
      return _mapAuthMessage(failure.message);
    } else if (failure is ServerFailure) {
      return _mapServerMessage(failure.message, failure.statusCode);
    } else if (failure is CacheFailure) {
      return 'Could not load saved data.';
    }
    return 'An unexpected error occurred.';
  }

  /// Maps a raw caught exception -> UX-friendly string.
  static String fromRaw(Object? error) {
    if (error == null) return 'An unexpected error occurred.';
    
    String raw = '';
    
    if (error is DioException) {
      raw = error.message ?? error.error?.toString() ?? error.toString();
    } else {
      raw = error.toString();
    }
    
    // Strip common exception class prefixes that look ugly in UI
    raw = raw.replaceAll(RegExp(r'^DioException \[[^\]]*\]:\s*'), '');
    raw = raw.replaceAll(RegExp(r'^Exception:\s*'), '');
    raw = raw.replaceAll(RegExp(r'^AppException:\s*'), '');
    
    // Check for status code prefix from microservices e.g. "[409] error message"
    final statusCodeRegex = RegExp(r'^\[(\d+)\]\s*(.*)');
    final match = statusCodeRegex.firstMatch(raw);
    
    if (match != null) {
      final statusCode = int.tryParse(match.group(1) ?? '');
      final message = match.group(2) ?? '';
      return _mapServerMessage(message, statusCode);
    }

    final lowerRaw = raw.toLowerCase();
    if (_has(lowerRaw, ['network', 'socket', 'connection', 'unreachable', 'timeout', 'internet'])) {
      return 'No internet connection. Please check your network.';
    }
    if (_has(lowerRaw, ['unauthenticated', 'unauthorized', 'token', 'jwt', 'session'])) {
      return 'Your session has expired. Please sign in again.';
    }
    if (_has(lowerRaw, ['not found', '404'])) {
      return 'The requested information could not be found.';
    }
    if (_has(lowerRaw, ['forbidden', '403'])) {
      return 'You do not have permission to perform this action.';
    }
    
    if (raw.isNotEmpty && raw.length < 80 && !raw.contains('Exception') && !raw.contains('Error:')) {
      return raw;
    }
    
    return 'An unexpected error occurred.';
  }

  static String _mapAuthMessage(String raw) {
    final lower = raw.toLowerCase();
    if (_has(lower, ['wrong password', 'invalid credential', 'incorrect'])) {
      return 'Incorrect email or password. Please try again.';
    }
    return 'Authentication failed. Please check your credentials.';
  }

  static String _mapServerMessage(String raw, int? statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      return 'You do not have permission to perform this action.';
    }
    if (statusCode == 404) {
      return 'The requested information could not be found.';
    }
    if (statusCode != null && statusCode >= 500) {
      return 'The server is currently unavailable.';
    }
    // Return the specific message sent by the backend for conflicts, validations, etc.
    if (raw.isNotEmpty && raw.length < 150) return raw;
    return 'The server encountered an error.';
  }

  static bool _has(String source, List<String> keywords) =>
      keywords.any((k) => source.contains(k));
}
