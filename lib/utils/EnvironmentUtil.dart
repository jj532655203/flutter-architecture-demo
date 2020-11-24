class EnvironmentUtil {
  static bool isDebug() {
    return !bool.fromEnvironment("dart.vm.product");
  }
}
