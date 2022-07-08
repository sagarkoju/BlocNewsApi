import 'package:dio/dio.dart';

class Failure extends Error {
  ///
  Failure(this.reason, this.type, [this.code]);

  /// Convert exception to [Failure]
  factory Failure.fromException() => Failure(
        'Something went wrong...',
        FailureType.exception,
      );

  final String reason;

  final FailureType type;

  final int? code;
}

/// Extension for [DioError]
/// Used to convert dioError into [Failure]
extension DioErrorExtension on DioError {
  ///
  Failure get toFailure {
    var msg = message;
    if (response == null) {
      msg = 'Please check your internet connections.';
    } else if ((response?.statusCode == 401 || response?.statusCode == 404) &&
        response?.data != null) {
      final data = response!.data as Map<String, dynamic>;
      final m = data['status_message'] as String?;
      if (m?.isNotEmpty ?? false) {
        msg = m!;
      }
    }

    switch (type) {
      case DioErrorType.cancel:
        return Failure(
          msg,
          FailureType.cancel,
        );
      case DioErrorType.connectTimeout:
        return Failure(
          msg,
          FailureType.requestTimeout,
        );
      case DioErrorType.receiveTimeout:
        return Failure(
          msg,
          FailureType.responseTimeout,
        );
      case DioErrorType.response:
        return Failure(
          msg,
          FailureType.response,
          response?.statusCode ?? FailureType.response.code,
        );
      case DioErrorType.sendTimeout:
        return Failure(
          'Connection timeout. Please try again.',
          FailureType.unknown,
          response?.statusCode ?? FailureType.unknown.code,
        );

      case DioErrorType.other:
        return Failure(
          msg,
          FailureType.unknown,
          response?.statusCode ?? FailureType.unknown.code,
        );
    }
  }
}

class FailureType {
  const FailureType._internal(this.code);

  /// Code associated with [FailureType]
  final int code;

  /// Authentication failure [code] : -4
  static const FailureType authentication = FailureType._internal(-4);

  /// Failure caused by exceptions [code] : -3
  static const FailureType exception = FailureType._internal(-3);

  /// Unknown failure [code] : -2
  static const FailureType unknown = FailureType._internal(-2);

  /// No internet connection [code] : -1
  static const FailureType internet = FailureType._internal(-1);

  static const FailureType cancel = FailureType._internal(0);

  /// Request time out [code] : 408
  static const FailureType requestTimeout = FailureType._internal(408);

  /// Response time out [code] : 598
  static const FailureType responseTimeout = FailureType._internal(598);

  static const FailureType response = FailureType._internal(400);

  /// List of [FailureType]
  static const List<FailureType> values = [
    FailureType.authentication,
    FailureType.exception,
    FailureType.unknown,
    FailureType.cancel,
    FailureType.requestTimeout,
    FailureType.responseTimeout,
    FailureType.response,
  ];
}
