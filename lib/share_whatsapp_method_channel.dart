import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:share_whatsapp/src/extensions.dart';

import 'share_whatsapp_platform_interface.dart';
import 'share_whatsapp_url.dart';
import 'src/enums.dart';

/// An implementation of [ShareWhatsappPlatform] that uses method channels.
class MethodChannelShareWhatsapp extends ShareWhatsappUrl {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('share_whatsapp');

  @override
  Future<bool> installed({WhatsApp type = WhatsApp.standard}) async {
    // Desktop platforms
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return await super.installed(type: type);
    }

    // Mobile platforms
    if (Platform.isAndroid || Platform.isIOS) {
      final installed = await methodChannel.invokeMethod<int>(
        'installed',
        type.packageName,
      );

      return installed == 1;
    }

    throw UnimplementedError('Unknown platform ${Platform.operatingSystem}');
  }

  @override
  Future<bool> share({
    WhatsApp type = WhatsApp.standard,
    String? phone,
    String? text,
    String? filePath,
    String? contentType,
  }) async {
    // Desktop platforms
    if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      return await super.share(
        type: type,
        phone: phone,
        text: text,
        filePath: filePath,
      );
    }

    // Mobile platforms
    if (Platform.isAndroid || Platform.isIOS) {
      final shared = await methodChannel.invokeMethod<int>('share', {
        'packageName': type.packageName,
        'phone': phone?.removeNonNumber(),
        'text': text,
        'file': filePath,
        'contentType': contentType,
      });

      return shared == 1;
    }

    throw UnimplementedError('Unknown platform ${Platform.operatingSystem}');
  }
}
