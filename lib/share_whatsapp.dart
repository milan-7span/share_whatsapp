import 'share_whatsapp_platform_interface.dart';
import 'src/enums.dart';

export 'share_whatsapp_url.dart';
export 'src/enums.dart' show WhatsApp;

/// Global singleton [ShareWhatsapp] instance
final shareWhatsapp = ShareWhatsapp();

/// Share your text message or file directly into Whatsapp
class ShareWhatsapp {
  /// Checks whether whatsapp is installed in device platform
  ///
  /// [type] is optional enum parameter which is default to [WhatsApp.standard]
  /// for business whatsapp set it to [WhatsApp.business]
  ///
  /// return true if installed otherwise false.
  Future<bool> installed({WhatsApp type = WhatsApp.standard}) {
    return ShareWhatsappPlatform.instance.installed(type: type);
  }

  /// Share text message into whatsapp
  ///
  /// [phone] is optional for Android, mandatory for Web, MacOS, Linux and Windows.
  /// But it will be ignored on iOS.
  Future<bool> shareText(String text,
          {String? phone, WhatsApp type = WhatsApp.standard}) =>
      share(type: type, text: text, phone: phone);

  /// Share file into whatsapp
  ///
  /// [phone] is optional for Android, mandatory for Web, MacOS, Linux and Windows.
  /// But it will be ignored on iOS.
  Future<bool> shareFile(String filePath,
          {String? phone, WhatsApp type = WhatsApp.standard}) =>
      share(type: type, filePath: filePath, phone: phone);

  /// Share text message and or file into whatsapp
  ///
  /// [phone] is optional for Android, mandatory for Web, MacOS, Linux and Windows.
  /// But it will be ignored on iOS.
  ///
  /// You need to either set [text] and or [phone].
  Future<bool> share({
    WhatsApp type = WhatsApp.standard,
    String? phone,
    String? text,
    String? filePath,
    String? contentType,
  }) {
    assert(
        !(text == null && filePath == null), "Either set text and or filepath");

    return ShareWhatsappPlatform.instance
        .share(type: type, phone: phone, text: text, filePath: filePath);
  }
}
