library apk_parser.processors;

import 'package:xmlstream/xmlstream.dart';
import 'package:apk_parser/apk_parser.dart';

class ActionProcessor extends XmlProcessor<Action> {
  ActionProcessor() {
    tagName = "action";
  }

  void onOpenTag(String tag) {
    element = new Action();
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "name":
        element.name = value;
        break;
    }
  }
}
class CategoryProcessor extends XmlProcessor<Category> {
  CategoryProcessor() {
    tagName = "category";
  }

  void onOpenTag(String tag) {
    element = new Category();
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "name":
        element.name = value;
        break;
    }
  }
}
class DataProcessor extends XmlProcessor<Data> {
  DataProcessor() {
    tagName = "data";
  }

  void onOpenTag(String tag) {
    element = new Data();
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "scheme":
        element.scheme = value;
        break;
      case "mimeType":
        element.mimeType = value;
        break;
      case "host":
        element.host = value;
        break;
      case "pathPrefix":
        element.pathPrefix = value;
        break;
      case "type":
        element.type = value;
        break;
    }
  }
}
class IntentFilterProcessor extends XmlParentProcessor<IntentFilter> {
  ActionProcessor actionProcessor;
  CategoryProcessor categoryProcessor;
  DataProcessor dataProcessor;

  IntentFilterProcessor() {
    tagName = "intent-filter";
  }

  void onOpenTag(String tag) {
    element = new IntentFilter();
  }

  void registerProcessors() {
    actionProcessor = new ActionProcessor();
    categoryProcessor = new CategoryProcessor();
    dataProcessor = new DataProcessor();

    actionProcessor.onProcess().listen((value) {
      if (isScope()) element.actions.add(value);
    });
    categoryProcessor.onProcess().listen((value) {
      if (isScope()) element.categories.add(value);
    });
    dataProcessor.onProcess().listen((value) {
      if (isScope()) element.dataList.add(value);
    });

    add(actionProcessor);
    add(categoryProcessor);
    add(dataProcessor);
  }
  void onAttribute(String key, String value) {}
  void onCharacters(String text) {}
}
class ActivityProcessor extends XmlProcessor<Activity> {
  ActivityProcessor() {
    tagName = "activity";
  }

  void onOpenTag(String tag) {
    element = new Activity();
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "name":
        element.name = value;
        break;
      case "exported":
        element.exported = new bool.fromEnvironment(value);
        break;
      case "process":
        element.process = value;
        break;
    }
  }
}
class ApplicationProcessor extends XmlParentProcessor<Application> {
  ActivityProcessor activityProcessor;

  ApplicationProcessor() {
    tagName = "application";
  }

  void onOpenTag(String tag) {
    element = new Application();
  }

  void registerProcessors() {
    activityProcessor = new ActivityProcessor();

    activityProcessor.onProcess().listen((value) {
      if (isScope()) element.activities.add(value);
    });

    add(activityProcessor);
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "allowTaskReparenting":
        element.allowTaskReparenting =
            new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "allowBackup":
        element.allowBackup =
            new bool.fromEnvironment(value, defaultValue: true);
        break;
      case "backupAgent":
        element.backupAgent = value;
        break;
      case "banner":
        element.banner = value;
        break;
      case "debuggable":
        element.debuggable =
            new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "description":
        element.description = value;
        break;
      case "enabled":
        element.enabled = new bool.fromEnvironment(value, defaultValue: true);
        break;
      case "hasCode":
        element.hasCode = new bool.fromEnvironment(value, defaultValue: true);
        break;
      case "hardwareAccelerated":
        element.hardwareAccelerated =
            new bool.fromEnvironment(value, defaultValue: true);
        break;
      case "icon":
        element.icon = value;
        break;
      case "isGame":
        element.isGame = new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "killAfterRestore":
        element.killAfterRestore =
            new bool.fromEnvironment(value, defaultValue: true);
        break;
      case "largeHeap":
        element.largeHeap =
            new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "label":
        element.label = value;
        break;
      case "logo":
        element.logo = value;
        break;
      case "manageSpaceActivity":
        element.manageSpaceActivity = value;
        break;
      case "name":
        element.name = value;
        break;
      case "permission":
        element.permission = value;
        break;
      case "persistent":
        element.persistent =
            new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "process":
        element.process = value;
        break;
      case "restoreAnyVersion":
        element.restoreAnyVersion =
            new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "requiredAccountType":
        element.requiredAccountType = value;
        break;
      case "restrictedAccountType":
        element.restrictedAccountType = value;
        break;
      case "supportsRtl":
        element.supportsRtl =
            new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "taskAffinity":
        element.taskAffinity = value;
        break;
      case "testOnly":
        element.testOnly = new bool.fromEnvironment(value, defaultValue: false);
        break;
      case "theme":
        element.theme = value;
        break;
      case "uiOptions":
        element.uiOptions = value;
        break;
      case "vmSafeMode":
        element.vmSafeMode =
            new bool.fromEnvironment(value, defaultValue: false);
        break;
    }
  }
  void onCharacters(String text) {}
}
class UsesSdkProcessor extends XmlProcessor<UsesSdk> {
  UsesSdkProcessor() {
    tagName = "uses-sdk";
  }

  void onOpenTag(String tag) {
    element = new UsesSdk();
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "minSdkVersion":
        element.minSdkVersion = int.parse(value);
        break;
      case "targetSdkVersion":
        element.targetSdkVersion = int.parse(value);
        break;
      case "maxSdkVersion":
        element.maxSdkVersion = int.parse(value);
        break;
    }
  }
  void onCharacters(String text) {}
}

class UsesFeatureProcessor extends XmlProcessor<UsesFeature> {
  UsesFeatureProcessor() {
    tagName = "uses-feature";
  }

  void onOpenTag(String tag) {
    element = new UsesFeature();
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "name":
        element.name = value;
        break;
      case "required":
        element.required = new bool.fromEnvironment(value, defaultValue: true);
        break;
      case "glEsVersion":
        int v = int.parse(value);
        element.glEsVersion = num.parse("${v >> 16}.${v & 0xffff}");
        break;
    }
  }
  void onCharacters(String text) {}
}

class UsesPermissionProcessor extends XmlProcessor<UsesPermission> {
  UsesPermissionProcessor() {
    tagName = "uses-permission";
  }

  void onOpenTag(String tag) {
    element = new UsesPermission();
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "name":
        element.name = value;
        break;
      case "maxSdkVersion":
        element.maxSdkVersion = int.parse(value);
        break;
    }
  }
  void onCharacters(String text) {}
}

class ManifestProcessor extends XmlParentProcessor<Manifest> {
  UsesPermissionProcessor usesPermissionProcessor;
  UsesFeatureProcessor usesFeatureProcessor;
  UsesSdkProcessor usesSdkProcessor;
  ApplicationProcessor applicationProcessor;
  IntentFilterProcessor intentFilterProcessor;

  ManifestProcessor() {
    tagName = "manifest";
  }

  @override
  void onOpenTag(String tag) {
    element = new Manifest();
  }

  void registerProcessors() {
    usesPermissionProcessor = new UsesPermissionProcessor();
    usesFeatureProcessor = new UsesFeatureProcessor();
    usesSdkProcessor = new UsesSdkProcessor();
    applicationProcessor = new ApplicationProcessor();
    intentFilterProcessor = new IntentFilterProcessor();

    usesPermissionProcessor.onProcess().listen((value) {
      if (isScope()) element.usesPermissions.add(value);
    });
    usesFeatureProcessor.onProcess().listen((value) {
      if (isScope()) element.usesFeatures.add(value);
    });
    usesSdkProcessor.onProcess().listen((value) {
      if (isScope()) element.usesSdk = value;
    });
    applicationProcessor.onProcess().listen((value) {
      if (isScope()) element.application = value;
    });
    intentFilterProcessor.onProcess().listen((value) {
      if (isScope()) element.intentFilters.add(value);
    });

    add(usesPermissionProcessor);
    add(usesFeatureProcessor);
    add(usesSdkProcessor);
    add(applicationProcessor);
    add(intentFilterProcessor);
  }

  void onAttribute(String key, String value) {
    switch (key) {
      case "versionCode":
        element.versionCode = int.parse(value);
        break;
      case "versionName":
        element.versionName = value;
        break;
      case "package":
        element.package = value;
        break;
      case "installLocation":
        element.installLocation = value;
        break;
    }
  }
  void onCharacters(String text) {}
}
