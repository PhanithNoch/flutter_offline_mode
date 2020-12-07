enum Flavor {
  DEV,
  PROD,
}

class AppFlavor {
  static Flavor appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.DEV:
        return 'Development';
      case Flavor.PROD:
        return 'Production';
      default:
        return 'Development';
    }
  }
}
