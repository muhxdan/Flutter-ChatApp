import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> isStoragePermissionOk() async {
    return Permission.storage.status;
  }

  Future<PermissionStatus> isCameraPermissionOk() async {
    return Permission.camera.status;
  }
}
