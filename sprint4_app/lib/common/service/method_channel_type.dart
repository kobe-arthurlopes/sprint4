import 'package:flutter/services.dart';

enum MethodChannelType {
  imageLabeling,
  platformIdentifier;

  final String baseName = 'com.sprint4';

  String get propertyName {
    switch (this) {
      case MethodChannelType.imageLabeling:
        return 'image_labeling';
      case MethodChannelType.platformIdentifier:
        return 'platform_identifier';
    }
  }

  String get methodName {
    switch (this) {
      case MethodChannelType.imageLabeling:
        return 'labelImage';
      case MethodChannelType.platformIdentifier:
        return 'identifyPlatform';
    }
  }

  MethodChannel get channel => MethodChannel('$baseName/$propertyName');

  Future<dynamic> getResult(Map<String, dynamic>? arguments) async {
    return await channel.invokeMethod(methodName, arguments);
  }
}
