class Helpers {
  static Future sleep(int secs) {
    Duration dur = Duration(seconds: secs);
    return Future.delayed(dur, () => "Delayed for $secs seconds");
  }

  static bool isNullOrEmpty(String inStr) {
    if (inStr == null) return true;
    if (inStr.isEmpty) return true;
    return false;
  }

  static bool listIsNullOrEmpty<T extends Object>(List<T> inList) {
    if (inList == null) return true;
    if (inList.length < 1) return true;
    return false;
  }
}