import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff775a0b),
      surfaceTint: Color(0xff775a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdf9e),
      onPrimaryContainer: Color(0xff5b4300),
      secondary: Color(0xff6b5d3f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xfff5e0bb),
      onSecondaryContainer: Color(0xff52452a),
      tertiary: Color(0xff4a6547),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffccebc4),
      onTertiaryContainer: Color(0xff334d30),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff1f1b13),
      onSurfaceVariant: Color(0xff4d4639),
      outline: Color(0xff7f7667),
      outlineVariant: Color(0xffd0c5b4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe9c16c),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xffe9c16c),
      onPrimaryFixedVariant: Color(0xff5b4300),
      secondaryFixed: Color(0xfff5e0bb),
      onSecondaryFixed: Color(0xff241a04),
      secondaryFixedDim: Color(0xffd8c4a0),
      onSecondaryFixedVariant: Color(0xff52452a),
      tertiaryFixed: Color(0xffccebc4),
      onTertiaryFixed: Color(0xff072008),
      tertiaryFixedDim: Color(0xffb0cfa9),
      onTertiaryFixedVariant: Color(0xff334d30),
      surfaceDim: Color(0xffe2d9cc),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff7ecdf),
      surfaceContainerHigh: Color(0xfff1e7d9),
      surfaceContainerHighest: Color(0xffebe1d4),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff473300),
      surfaceTint: Color(0xff775a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff88681c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff41351b),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff7b6b4d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff233c21),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff597454),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff141109),
      onSurfaceVariant: Color(0xff3c3529),
      outline: Color(0xff595144),
      outlineVariant: Color(0xff756c5d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe9c16c),
      primaryFixed: Color(0xff88681c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6d5000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff7b6b4d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff615336),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff597454),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff415b3e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcec5b8),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffcf2e5),
      surfaceContainer: Color(0xfff1e7d9),
      surfaceContainerHigh: Color(0xffe5dbce),
      surfaceContainerHighest: Color(0xffdad0c3),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3a2900),
      surfaceTint: Color(0xff775a0b),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5e4500),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff362b11),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff55472c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff193218),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff355033),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f2),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff322b1f),
      outlineVariant: Color(0xff50483b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff353027),
      inversePrimary: Color(0xffe9c16c),
      primaryFixed: Color(0xff5e4500),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff423000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff55472c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff3d3117),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff355033),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1f381e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc0b8ab),
      surfaceBright: Color(0xfffff8f2),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff9efe2),
      surfaceContainer: Color(0xffebe1d4),
      surfaceContainerHigh: Color(0xffddd3c6),
      surfaceContainerHighest: Color(0xffcec5b8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe9c16c),
      surfaceTint: Color(0xffe9c16c),
      onPrimary: Color(0xff402d00),
      primaryContainer: Color(0xff5b4300),
      onPrimaryContainer: Color(0xffffdf9e),
      secondary: Color(0xffd8c4a0),
      onSecondary: Color(0xff3b2f15),
      secondaryContainer: Color(0xff52452a),
      onSecondaryContainer: Color(0xfff5e0bb),
      tertiary: Color(0xffb0cfa9),
      onTertiary: Color(0xff1d361c),
      tertiaryContainer: Color(0xff334d30),
      onTertiaryContainer: Color(0xffccebc4),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff17130b),
      onSurface: Color(0xffebe1d4),
      onSurfaceVariant: Color(0xffd0c5b4),
      outline: Color(0xff998f80),
      outlineVariant: Color(0xff4d4639),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff775a0b),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xffe9c16c),
      onPrimaryFixedVariant: Color(0xff5b4300),
      secondaryFixed: Color(0xfff5e0bb),
      onSecondaryFixed: Color(0xff241a04),
      secondaryFixedDim: Color(0xffd8c4a0),
      onSecondaryFixedVariant: Color(0xff52452a),
      tertiaryFixed: Color(0xffccebc4),
      onTertiaryFixed: Color(0xff072008),
      tertiaryFixedDim: Color(0xffb0cfa9),
      onTertiaryFixedVariant: Color(0xff334d30),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff3e382f),
      surfaceContainerLowest: Color(0xff110e07),
      surfaceContainerLow: Color(0xff1f1b13),
      surfaceContainer: Color(0xff231f17),
      surfaceContainerHigh: Color(0xff2e2921),
      surfaceContainerHighest: Color(0xff39342b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd784),
      surfaceTint: Color(0xffe9c16c),
      onPrimary: Color(0xff322300),
      primaryContainer: Color(0xffaf8c3d),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffeedab5),
      onSecondary: Color(0xff2f240c),
      secondaryContainer: Color(0xffa08f6e),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffc6e5be),
      onTertiary: Color(0xff122b12),
      tertiaryContainer: Color(0xff7b9876),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff17130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe7dbc9),
      outline: Color(0xffbbb1a0),
      outlineVariant: Color(0xff998f7f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff191000),
      primaryFixedDim: Color(0xffe9c16c),
      onPrimaryFixedVariant: Color(0xff473300),
      secondaryFixed: Color(0xfff5e0bb),
      onSecondaryFixed: Color(0xff191000),
      secondaryFixedDim: Color(0xffd8c4a0),
      onSecondaryFixedVariant: Color(0xff41351b),
      tertiaryFixed: Color(0xffccebc4),
      onTertiaryFixed: Color(0xff001602),
      tertiaryFixedDim: Color(0xffb0cfa9),
      onTertiaryFixedVariant: Color(0xff233c21),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff49443a),
      surfaceContainerLowest: Color(0xff0a0703),
      surfaceContainerLow: Color(0xff211d15),
      surfaceContainer: Color(0xff2c271f),
      surfaceContainerHigh: Color(0xff373229),
      surfaceContainerHighest: Color(0xff423d34),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeed1),
      surfaceTint: Color(0xffe9c16c),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffe5bd69),
      onPrimaryContainer: Color(0xff110a00),
      secondary: Color(0xffffeed1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffd4c09d),
      onSecondaryContainer: Color(0xff110a00),
      tertiary: Color(0xffd9f9d1),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffaccba6),
      onTertiaryContainer: Color(0xff000f01),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff17130b),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfffbeedc),
      outlineVariant: Color(0xffccc1b0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffebe1d4),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffe9c16c),
      onPrimaryFixedVariant: Color(0xff191000),
      secondaryFixed: Color(0xfff5e0bb),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffd8c4a0),
      onSecondaryFixedVariant: Color(0xff191000),
      tertiaryFixed: Color(0xffccebc4),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb0cfa9),
      onTertiaryFixedVariant: Color(0xff001602),
      surfaceDim: Color(0xff17130b),
      surfaceBright: Color(0xff554f45),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff231f17),
      surfaceContainer: Color(0xff353027),
      surfaceContainerHigh: Color(0xff403b31),
      surfaceContainerHighest: Color(0xff4c463c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
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
