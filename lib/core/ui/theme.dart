import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff415f91),
      surfaceTint: Color(0xff415f91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd7e3ff),
      onPrimaryContainer: Color(0xff284777),
      secondary: Color(0xff30628c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcee5ff),
      onSecondaryContainer: Color(0xff104a73),
      tertiary: Color(0xff1e6586),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc5e7ff),
      onTertiaryContainer: Color(0xff004c6a),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff44474f),
      outline: Color(0xff74777f),
      outlineVariant: Color(0xffc4c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff284777),
      secondaryFixed: Color(0xffcee5ff),
      onSecondaryFixed: Color(0xff001d33),
      secondaryFixedDim: Color(0xff9ccbfb),
      onSecondaryFixedVariant: Color(0xff104a73),
      tertiaryFixed: Color(0xffc5e7ff),
      onTertiaryFixed: Color(0xff001e2d),
      tertiaryFixedDim: Color(0xff90cef4),
      onTertiaryFixedVariant: Color(0xff004c6a),
      surfaceDim: Color(0xffd9d9e0),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffededf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData light() => theme(lightScheme());

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff133665),
      surfaceTint: Color(0xff415f91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff506da0),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff00395d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff40719c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003b52),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff317496),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0f1116),
      onSurfaceVariant: Color(0xff33363e),
      outline: Color(0xff50525a),
      outlineVariant: Color(0xff6a6d75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff506da0),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff375586),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff40719c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff245882),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff317496),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff0c5b7c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5c6cd),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffe7e8ee),
      surfaceContainerHigh: Color(0xffdcdce3),
      surfaceContainerHighest: Color(0xffd1d1d8),
    );
  }

  ThemeData lightMediumContrast() => theme(lightMediumContrastScheme());

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff042b5b),
      surfaceTint: Color(0xff415f91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2a497a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002e4d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff144c76),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003044),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff004f6d),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292c33),
      outlineVariant: Color(0xff464951),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff2a497a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0e3262),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff144c76),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003557),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff004f6d),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff00374d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb8b8bf),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f0f7),
      surfaceContainer: Color(0xffe2e2e9),
      surfaceContainerHigh: Color(0xffd3d4db),
      surfaceContainerHighest: Color(0xffc5c6cd),
    );
  }

  ThemeData lightHighContrast() => theme(lightHighContrastScheme());

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaac7ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff0b305f),
      primaryContainer: Color(0xff284777),
      onPrimaryContainer: Color(0xffd7e3ff),
      secondary: Color(0xff9ccbfb),
      onSecondary: Color(0xff003354),
      secondaryContainer: Color(0xff104a73),
      onSecondaryContainer: Color(0xffcee5ff),
      tertiary: Color(0xff90cef4),
      onTertiary: Color(0xff00344a),
      tertiaryContainer: Color(0xff004c6a),
      onTertiaryContainer: Color(0xffc5e7ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc4c6d0),
      outline: Color(0xff8e9099),
      outlineVariant: Color(0xff44474f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff415f91),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff001b3e),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff284777),
      secondaryFixed: Color(0xffcee5ff),
      onSecondaryFixed: Color(0xff001d33),
      secondaryFixedDim: Color(0xff9ccbfb),
      onSecondaryFixedVariant: Color(0xff104a73),
      tertiaryFixed: Color(0xffc5e7ff),
      onTertiaryFixed: Color(0xff001e2d),
      tertiaryFixedDim: Color(0xff90cef4),
      onTertiaryFixedVariant: Color(0xff004c6a),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1e2025),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  ThemeData dark() => theme(darkScheme());

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdddff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff002551),
      primaryContainer: Color(0xff7491c7),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc3dfff),
      onSecondary: Color(0xff002843),
      secondaryContainer: Color(0xff6695c2),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb7e2ff),
      onTertiary: Color(0xff00293b),
      tertiaryContainer: Color(0xff5998bb),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadce6),
      outline: Color(0xffb0b1bb),
      outlineVariant: Color(0xff8e9099),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff294878),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff00112b),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff133665),
      secondaryFixed: Color(0xffcee5ff),
      onSecondaryFixed: Color(0xff001223),
      secondaryFixedDim: Color(0xff9ccbfb),
      onSecondaryFixedVariant: Color(0xff00395d),
      tertiaryFixed: Color(0xffc5e7ff),
      onTertiaryFixed: Color(0xff00131e),
      tertiaryFixedDim: Color(0xff90cef4),
      onTertiaryFixedVariant: Color(0xff003b52),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff43444a),
      surfaceContainerLowest: Color(0xff06070c),
      surfaceContainerLow: Color(0xff1b1e22),
      surfaceContainer: Color(0xff26282d),
      surfaceContainerHigh: Color(0xff313238),
      surfaceContainerHighest: Color(0xff3c3e43),
    );
  }

  ThemeData darkMediumContrast() => theme(darkMediumContrastScheme());

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa6c3fc),
      onPrimaryContainer: Color(0xff000b20),
      secondary: Color(0xffe7f1ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff98c7f7),
      onSecondaryContainer: Color(0xff000c19),
      tertiary: Color(0xffe2f2ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff8ccaf0),
      onTertiaryContainer: Color(0xff000d16),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeeeff9),
      outlineVariant: Color(0xffc1c2cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff294878),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00112b),
      secondaryFixed: Color(0xffcee5ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff9ccbfb),
      onSecondaryFixedVariant: Color(0xff001223),
      tertiaryFixed: Color(0xffc5e7ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff90cef4),
      onTertiaryFixedVariant: Color(0xff00131e),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff4e5056),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e2025),
      surfaceContainer: Color(0xff2e3036),
      surfaceContainerHigh: Color(0xff393b41),
      surfaceContainerHighest: Color(0xff45474c),
    );
  }

  ThemeData darkHighContrast() => theme(darkHighContrastScheme());

  // ✅ CORREGIDO: CardThemeData + BottomAppBarThemeData
  ThemeData theme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    final base = ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    final bg = isDark ? colorScheme.surface : const Color(0xFFF6F7FB);

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      canvasColor: bg,

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),

      // ✅ CardThemeData (no CardTheme)
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: colorScheme.primary.withOpacity(isDark ? 0.18 : 0.10),
        surfaceTintColor: Colors.transparent,
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : Colors.white.withOpacity(0.86),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerHigh
            : Colors.white.withOpacity(0.78),
        hintStyle: TextStyle(
          color: isDark ? colorScheme.onSurfaceVariant : Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: colorScheme.primary.withOpacity(isDark ? 0.9 : 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.primary.withOpacity(0.35),
            width: 1.2,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ),

      chipTheme: base.chipTheme.copyWith(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        labelStyle: base.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHigh
            : Colors.white.withOpacity(0.70),
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHigh
            : Colors.white.withOpacity(0.92),
        elevation: 0,
        indicatorColor: colorScheme.primary.withOpacity(isDark ? 0.26 : 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return base.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          );
        }),
      ),

      // ✅ BottomAppBarThemeData (no BottomAppBarTheme)
      bottomAppBarTheme: BottomAppBarThemeData(
        color: isDark
            ? colorScheme.surfaceContainerHigh
            : Colors.white.withOpacity(0.92),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHigh
            : Colors.black.withOpacity(0.85),
        contentTextStyle: TextStyle(
          color: isDark ? colorScheme.onSurface : Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),

      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: colorScheme.outlineVariant.withOpacity(isDark ? 0.6 : 0.7),
      ),
    );
  }

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
