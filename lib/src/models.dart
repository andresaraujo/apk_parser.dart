library mmodels;

/**
 * http://developer.android.com/guide/topics/manifest/manifest-element.html
 */
class Manifest {
  int versionCode;
  String versionName;
  String package;
  String installLocation;

  UsesSdk usesSdk;
  Application application;

  List<UsesPermission> usesPermissions = [];
  List<UsesFeature> usesFeatures = [];

  List<IntentFilter> intentFilters = [];

  toString() => """
  {
    versionCode: $versionCode,
    versionName: $versionName,
    package: $package,
    installLocation: $installLocation,
    usesSdk: $usesSdk,
    application: $application,
    usesPermissions: $usesPermissions,
    usesFeatures: $usesFeatures,
    intentFilters: $intentFilters,
  }
  """;
}

/**
 * http://developer.android.com/guide/topics/manifest/uses-permission-element.html
 */
class UsesPermission {
  String name;
  int maxSdkVersion;
  toString() => "{name: $name, maxSdkVersion: $maxSdkVersion}";
}

/**
 * http://developer.android.com/guide/topics/manifest/uses-feature-element.html
 */
class UsesFeature {
  String name;
  bool required = true;
  num glEsVersion;

  toString() => "{name: $name, required: $required, glEsVersion: $glEsVersion}";
}

/**
 * http://developer.android.com/guide/topics/manifest/uses-sdk-element.html
 */
class UsesSdk {
  int minSdkVersion;
  int targetSdkVersion;
  int maxSdkVersion;

  toString() =>
      "{minSdkVersion: $minSdkVersion, targetSdkVersion: $targetSdkVersion, maxSdkVersion: $maxSdkVersion}";
}

/**
 * http://developer.android.com/guide/topics/manifest/application-element.html
 */
class Application {
  bool allowTaskReparenting;
  bool allowBackup;
  String backupAgent;
  String banner;
  bool debuggable;
  String description;
  bool enabled;
  bool hasCode;
  bool hardwareAccelerated;
  String icon;
  bool isGame;
  bool killAfterRestore;
  bool largeHeap;
  String label;
  String logo;
  String manageSpaceActivity;
  String name;
  String permission;
  bool persistent;
  String process;
  bool restoreAnyVersion;
  String requiredAccountType;
  String restrictedAccountType;
  bool supportsRtl;
  String taskAffinity;
  bool testOnly;
  String theme;
  String uiOptions;
  bool vmSafeMode;

  List<Activity> activities = [];

  toString() =>
      "{theme: $theme, label: $label, icon: $icon, activities: $activities}";
}

/**
 * http://developer.android.com/guide/topics/manifest/activity-element.html
 */
class Activity {
  String name;
  bool exported;
  String process;

  toString() => "{name: $name, exported: $exported, process: $process}";
}

/**
 * http://developer.android.com/guide/topics/manifest/intent-filter-element.html
 */
class IntentFilter {
  List<Action> actions = [];
  List<Category> categories = [];
  List<Data> dataList = [];
  toString() => "{actions: $actions, categories: $categories, data: $dataList}";
}
/**
 * http://developer.android.com/guide/topics/manifest/action-element.html
 */
class Action {
  String name;
  toString() => "{name: $name}";
}
/**
 * http://developer.android.com/guide/topics/manifest/category-element.html
 */
class Category {
  String name;
  toString() => "{name: $name}";
}
/**
 * http://developer.android.com/guide/topics/manifest/data-element.html
 */
class Data {
  String scheme;
  String mimeType;
  String host;
  String pathPrefix;
  String type;
  toString() => """"{scheme: $scheme, mimeType: $mimeType,
  host: $host, pathPrefix: $pathPrefix, type: $type}""";
}
