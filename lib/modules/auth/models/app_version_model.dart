class AppVersionModel {
  final String versionName;
  final int versionCode;
  final int minRequiredVersionCode;
  final bool isForceUpdate;
  final String? updateMessage;
  final String? storeUrlAndroid;
  final String? storeUrlIos;

  AppVersionModel({
    required this.versionName,
    required this.versionCode,
    required this.minRequiredVersionCode,
    required this.isForceUpdate,
    this.updateMessage,
    this.storeUrlAndroid,
    this.storeUrlIos,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) {
    return AppVersionModel(
      versionName: json['version_name'] as String,
      versionCode: json['version_code'] as int,
      minRequiredVersionCode: json['min_required_version_code'] as int,
      isForceUpdate: json['is_force_update'] as bool? ?? false,
      updateMessage: json['update_message'] as String?,
      storeUrlAndroid: json['store_url_android'] as String?,
      storeUrlIos: json['store_url_ios'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version_name': versionName,
      'version_code': versionCode,
      'min_required_version_code': minRequiredVersionCode,
      'is_force_update': isForceUpdate,
      'update_message': updateMessage,
      'store_url_android': storeUrlAndroid,
      'store_url_ios': storeUrlIos,
    };
  }

  @override
  String toString() {
    return 'AppVersionModel(versionName: $versionName, versionCode: $versionCode, minRequired: $minRequiredVersionCode, forceUpdate: $isForceUpdate)';
  }
}