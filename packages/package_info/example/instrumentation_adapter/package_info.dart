// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:instrumentation_adapter/instrumentation_adapter.dart';
import 'package:package_info/package_info.dart';

void main() {
  InstrumentationAdapterFlutterBinding.ensureInitialized();
  group('package_info test', () {
    testWidgets('test package info result', (_) async {
      final PackageInfo info = await PackageInfo.fromPlatform();
      // These tests are based on the example app. The tests should be updated if any related info changes.
      if (Platform.isAndroid) {
        expect(info.appName, 'package_info_example');
        expect(info.buildNumber, '1');
        expect(info.packageName, 'io.flutter.plugins.packageinfoexample');
        expect(info.version, '1.0');
      } else if (Platform.isIOS) {
        expect(info.appName, 'Package Info Example');
        expect(info.buildNumber, '1');
        expect(info.packageName, 'io.flutter.plugins.packageInfoExample');
        expect(info.version, '1.0');
      } else {
        throw (UnsupportedError('platform not supported'));
      }
    });
  });
}