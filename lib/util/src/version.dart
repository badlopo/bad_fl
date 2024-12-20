enum VersionType { alpha, beta, rc, release }

/// Convert string to [VersionType], return null if not in predefined list
VersionType? _versionTypeFromString(String raw) {
  switch (raw.toLowerCase()) {
    case 'alpha':
      return VersionType.alpha;
    case 'beta':
      return VersionType.beta;
    case 'rc':
      return VersionType.rc;
    case 'release':
      return VersionType.release;
    default:
      return null;
  }
}

/// A version in format of `[<prefix>]<major>.<minor>.<patch>[-<type>][.<description>]`
class Version {
  /// Prefix section in version string (optional, usually 'v')
  final String? prefix;

  /// Major version
  final int major;

  /// Minor version
  final int minor;

  /// Patch version
  final int patch;

  /// Version type (optional)
  final VersionType? type;

  /// Description section in version string (optional)
  final String? description;

  /// Display string
  final String display;

  const Version._({
    this.prefix,
    required this.major,
    required this.minor,
    required this.patch,
    this.type,
    this.description,
  }) : display =
            '$prefix$major.$minor.$patch${type != null ? '-$type' : ''}${description != null ? '.$description' : ''}';

  /// Parse version string to [Version]
  ///
  /// Throw:
  /// - [ArgumentError] if version string is invalid
  ///
  /// Example:
  /// ```dart
  /// const versionString = 'v1.2.3-beta.ab-test';
  /// final version = Version.parse(versionString);
  /// print('prefix: ${version.prefix}\n'
  ///     'major: ${version.major}\n'
  ///     'minor: ${version.minor}\n'
  ///     'patch: ${version.patch}\n'
  ///     'type: ${version.type}\n'
  ///     'description: ${version.description}\n'
  ///     'display: ${version.display}');
  ///
  /// // Output:
  /// // prefix: v
  /// // major: 1
  /// // minor: 2
  /// // patch: 3
  /// // type: VersionType.beta
  /// // description: ab-test
  /// // display: v1.2.3-beta.ab-test
  /// ```
  factory Version.parse(String raw) {
    final reg = RegExp(
        r'^(?<prefix>[^0-9]+)(?<major>[0-9]+)\.(?<minor>[0-9]+)\.(?<patch>[0-9]+)(-(?<type>[^.]+))?(\.(?<description>.+))?$');

    // parse
    final result = reg.firstMatch(raw);
    if (result == null) throw ArgumentError('Invalid version string: $raw');

    // prefix
    final prefix = result.namedGroup('prefix');

    // major
    final majorRaw = result.namedGroup('major');
    if (majorRaw == null) throw ArgumentError('Invalid version string: $raw');
    final major = int.tryParse(majorRaw, radix: 10);
    if (major == null) throw ArgumentError('Invalid version string: $raw');

    // minor
    final minorRaw = result.namedGroup('minor');
    if (minorRaw == null) throw ArgumentError('Invalid version string: $raw');
    final minor = int.tryParse(minorRaw, radix: 10);
    if (minor == null) throw ArgumentError('Invalid version string: $raw');

    // patch
    final patchRaw = result.namedGroup('patch');
    if (patchRaw == null) throw ArgumentError('Invalid version string: $raw');
    final patch = int.tryParse(patchRaw, radix: 10);
    if (patch == null) throw ArgumentError('Invalid version string: $raw');

    // type
    final typeRaw = result.namedGroup('type');
    VersionType? type;
    if (typeRaw != null) {
      type = _versionTypeFromString(typeRaw);
      if (type == null) throw ArgumentError('Invalid version string: $raw');
    }

    return Version._(
      prefix: prefix,
      major: major,
      minor: minor,
      patch: patch,
      type: type,
      description: result.namedGroup('description'),
    );
  }

  @override
  String toString() => display;
}
