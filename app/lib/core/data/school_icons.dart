/// Maps school names to their mascot/logo icon URLs.
/// In production, these would come from a CDN or Firebase Storage.
/// For now, we use placeholder URLs based on school name initials.
class SchoolIcons {
  SchoolIcons._();

  // Known school logo URLs (placeholder pattern using UI Avatars for demo)
  // In production, replace with actual school logo CDN URLs.
  static String getSchoolLogoUrl(String schoolName) {
    final known = _knownLogos[schoolName];
    if (known != null) return known;

    // Generate a deterministic placeholder from school initials
    final initials = schoolName
        .split(' ')
        .where((w) => w.isNotEmpty && w[0] == w[0].toUpperCase())
        .take(2)
        .map((w) => w[0])
        .join();

    // Use a hash of the name to pick a color
    final hash = schoolName.hashCode.abs();
    final colors = [
      '1565C0', '283593', 'AD1457', '00695C', 'E65100',
      '4A148C', '1B5E20', 'BF360C', '0D47A1', '880E4F',
    ];
    final bgColor = colors[hash % colors.length];

    return 'https://ui-avatars.com/api/?name=$initials&background=$bgColor&color=fff&size=128&bold=true&format=png';
  }

  // Map of school names to actual known logo URLs
  // These would be real CDN URLs in production
  static final Map<String, String> _knownLogos = {
    'Centaurus High School':
        'https://ui-avatars.com/api/?name=CH&background=1565C0&color=fff&size=128&bold=true&format=png',
    'Fairview High School':
        'https://ui-avatars.com/api/?name=FH&background=00695C&color=fff&size=128&bold=true&format=png',
    'Boulder High School':
        'https://ui-avatars.com/api/?name=BH&background=AD1457&color=fff&size=128&bold=true&format=png',
    'Monarch High School':
        'https://ui-avatars.com/api/?name=MH&background=283593&color=fff&size=128&bold=true&format=png',
    'Broomfield High School':
        'https://ui-avatars.com/api/?name=BrH&background=E65100&color=fff&size=128&bold=true&format=png',
  };
}
