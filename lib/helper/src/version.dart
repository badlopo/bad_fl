class BadVersion {
  final int major;
  final int minor;
  final int patch;

  factory BadVersion.parse(String version) {
    final parts = version.split('.');
    if (parts.length != 3) {
      throw ArgumentError('Invalid version string: $version');
    }
    return BadVersion(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  const BadVersion(this.major, this.minor, this.patch);

  @override
  String toString() {
    return '$major.$minor.$patch';
  }
}

class BadVersionCompare {
  /// if the latest version is greater than the current version,
  /// then an update is needed.
  final bool updatable;

  /// if two versions have the same major and minor,
  /// then it can be considered a negligible update.
  ///
  /// Note: this is only applicable when [updatable] is true.
  final bool ignoreable;

  /// compare two versions and return the result
  factory BadVersionCompare.compare(BadVersion base, BadVersion candidate) {
    late final bool updatable;
    if (candidate.major > base.major) {
      updatable = true;
    } else if (candidate.major == base.major) {
      if (candidate.minor > base.minor) {
        updatable = true;
      } else if (candidate.minor == base.minor) {
        updatable = candidate.patch > base.patch;
      } else {
        updatable = false;
      }
    } else {
      updatable = false;
    }

    return BadVersionCompare(
      updatable: updatable,
      ignoreable:
          candidate.major == base.major && candidate.minor == base.minor,
    );
  }

  const BadVersionCompare({required this.updatable, required this.ignoreable});
}

extension IntoVersion on String {
  BadVersion intoVersion() {
    return BadVersion.parse(this);
  }
}
