enum PlayerPage { library, favorite, playlist, recently, settings }

enum SettingsPageKeys { settings, storage }

enum PlayMode { single, singleLoop, sequence, loop, shuffle }

class SortState {
  String? field;
  String? direction;

  SortState({this.field, this.direction});

  Map<String, dynamic> toJson() => {'field': field, 'direction': direction};

  factory SortState.fromJson(Map<String, dynamic> json) {
    return SortState(
      field: json['field'] as String?,
      direction: json['direction'] as String?,
    );
  }
}

// lib/app_constants.dart

class AppConstants {
  static const String themeKey = 'theme_mode';
  static const String seedColorKey = 'theme_seed_color';
  static const String seedAlphaKey = 'theme_seed_alpha';
  static const String opacityTargetKey = 'theme_opacity_target';
  static const String sidebarIsExtendedKey = 'theme_sidebar_is_extended';
}
