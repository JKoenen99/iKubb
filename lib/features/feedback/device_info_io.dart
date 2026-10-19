import 'dart:io';

String operatingSystemVersion() {
  try {
    return Platform.operatingSystemVersion;
  } on Object {
    return '';
  }
}
