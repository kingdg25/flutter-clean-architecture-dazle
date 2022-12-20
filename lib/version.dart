String versionNumber() {
  final defaultVersion = '#{VERSION}';
  String version = defaultVersion;
  if (version.substring(0, 2) == '#{') {
    version = '0.0.0.local';
  }
  return version;
}
