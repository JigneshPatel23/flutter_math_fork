import 'dart:ui';

import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_math/src/ast/nodes/style.dart';
import 'package:flutter_math/src/ast/nodes/symbol.dart';
import 'package:flutter_math/src/ast/size.dart';
import 'package:flutter_math/src/ast/types.dart';
import 'package:flutter_math/src/parser/tex/font.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_math/src/encoder/tex/encoder.dart';

void main() {
  group('style encoding test', () {
    test('math style handling', () {
      expect(
        StyleNode(
          optionsDiff: OptionsDiff(style: MathStyle.display),
          children: [SymbolNode(symbol: 'a')],
        ).encodeTeX(),
        '{\\displaystyle a}',
      );
    });

    test('size handling', () {
      expect(
        StyleNode(
          optionsDiff: OptionsDiff(size: SizeMode.scriptsize),
          children: [SymbolNode(symbol: 'a')],
        ).encodeTeX(),
        '{\\scriptsize a}',
      );
    });

    test('font handling', () {
      expect(
        StyleNode(
          optionsDiff:
              OptionsDiff(mathFontOptions: texMathFontOptions['\\mathbf']),
          children: [SymbolNode(symbol: 'a')],
        ).encodeTeX(),
        '\\mathbf{a}',
      );
      expect(
        StyleNode(
          optionsDiff:
              OptionsDiff(textFontOptions: texTextFontOptions['\\textbf']),
          children: [SymbolNode(symbol: 'a', mode: Mode.text)],
        ).encodeTeX(),
        '\\textbf{a}',
      );
    });

    test('color handling', () {
      expect(
        StyleNode(
          optionsDiff: OptionsDiff(color: Color.fromARGB(0, 1, 2, 3)),
          children: [SymbolNode(symbol: 'a')],
        ).encodeTeX(),
        '\\textcolor{#010203}{a}',
      );
    });

    test('avoid extra brackets', () {
      expect(
        StyleNode(
          optionsDiff: OptionsDiff(
            style: MathStyle.display,
            size: SizeMode.scriptsize,
            color: Color.fromARGB(0, 1, 2, 3),
          ),
          children: [SymbolNode(symbol: 'a')],
        ).encodeTeX(),
        '\\textcolor{#010203}{\\displaystyle \\scriptsize a}',
      );

      expect(
        EquationRowNode(children: [
          SymbolNode(symbol: 'z'),
          StyleNode(
            optionsDiff: OptionsDiff(
              style: MathStyle.display,
              size: SizeMode.scriptsize,
            ),
            children: [SymbolNode(symbol: 'a')],
          ),
        ]).encodeTeX(),
        '{z\\displaystyle \\scriptsize a}',
      );
    });
  });
}