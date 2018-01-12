// Copyright 2017, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of cloud_firestore;

class WriteBatch {
  WriteBatch():
    _handle = Firestore.channel.invokeMethod(
      'Batch#create',
    );

  Future<int> _handle;
  bool committed = false;
  final List<Future<Null>> _actions = <Future<Null>>[];

  Future<Null> commit() async {
    if (!committed){
      committed = true;
      await Future.wait(_actions);
      return await Firestore.channel.invokeMethod(
        'Batch#commit',
        <String, dynamic>{'handle': await _handle}
      );
    } else {
      throw new StateError("This batch has already been committed.");
    }
  }

  void delete(DocumentReference reference){
    if (!committed){
      _handle.then((int handle){
        _actions.add(
          Firestore.channel.invokeMethod(
            'Batch#delete',
            <String, dynamic>{
              'handle': handle,
              'path': reference.path
            },
          ),
        );
      });
    } else {
      throw new StateError("This batch has been committed and can no longer be changed.");
    }
  }

  void set(DocumentReference reference, Map<String, dynamic> data, [SetOptions options]){
    if (!committed){
      _handle.then((int handle){
        _actions.add(
          Firestore.channel.invokeMethod(
            'Batch#set',
            <String, dynamic>{
              'handle': handle,
              'path': reference.path,
              'data': data,
              'options': options?._data,
            },
          ),
        );
      });
    } else {
      throw new StateError("This batch has been committed and can no longer be changed.");
    }
  }

  void update(DocumentReference reference, Map<String, dynamic> data){
    if (!committed){
      _handle.then((int handle){
        _actions.add(
          Firestore.channel.invokeMethod(
            'Batch#update',
            <String, dynamic>{
              'handle': handle,
              'path': reference.path,
              'data': data,
            },
          ),
        );
      });
    } else {
      throw new StateError("This batch has been committed and can no longer be changed.");
    }
  }
}