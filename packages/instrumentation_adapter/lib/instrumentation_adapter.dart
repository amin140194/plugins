import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A subclass of [LiveTestWidgetsFlutterBinding] that reports tests results
/// on a channel to adapt them to native instrumentation test format.
class InstrumentationAdapterFlutterBinding extends LiveTestWidgetsFlutterBinding {
  InstrumentationAdapterFlutterBinding() {
    tearDownAll(() {
      _channel.invokeMethod<void>('testFinished', <String, dynamic>{'results': _results});
    });
  }
  static const MethodChannel _channel =
      MethodChannel('dev.flutter/InstrumentationAdapterFlutterBinding');

  static Map<String, String> _results = <String, String>{};

  @override
  Future<void> runTest(Future<void> testBody(), VoidCallback invariantTester,
      {String description = '', Duration timeout}) async {
    // TODO(jackson): Report the results individually instead of all at once
    // See https://github.com/flutter/flutter/issues/38985
    reportTestException =
        (FlutterErrorDetails details, String testDescription) {
      _results[description] = 'failed';
    };
    await super.runTest(testBody, invariantTester,
        description: description, timeout: timeout);
    _results[description] ??= 'success';
  }
}
