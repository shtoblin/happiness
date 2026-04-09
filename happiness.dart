import 'dart:io';
import 'dart:math';
import 'package:characters/characters.dart';

enum Mood {
  excited('\u{1F60E}', 'взволнованный', 9),
  happy('\u{1F600}', 'счастливый', 8),
  sad('\u{1F61E}', 'грустный', 3),
  angry('\u{1F621}', 'злой', 2),
  inLove('\u{1F60D}', 'влюблённый', 10),
  tired('\u{1F634}', 'сонный', 4),
  cool('\u{1F60E}', 'крутой', 7);

  final String emoji;
  final String description;
  final int energy;

  const Mood(this.emoji, this.description, this.energy);
}

void main() {
  stdout.write('Введите ваше имя: ');
  String name = stdin.readLineSync()?.trim() ?? 'Гость';

  print('\nГенерируем случайное настроение...');

  final random = Random();
  final moods = Mood.values;
  final randomMood = moods[random.nextInt(moods.length)];

  print('Привет, $name! Твое настроение: ${randomMood.emoji} ${randomMood.description} (энергия: ${randomMood.energy}/10)');

  final unicodeCodePoint = getUnicodeCodePoint(randomMood.emoji);
  print('\nЮникод вашего эмодзи: $unicodeCodePoint');

  stdout.write('\nХотите просмотреть сложные эмодзи? (/нет): ');
  String answer = stdin.readLineSync()?.trim().toLowerCase() ?? '';

  if (answer == 'да' || answer == 'yes' || answer == 'y') {
    stdout.write('Введите комбинацию эмодзи: ');
    String complexEmoji = stdin.readLineSync() ?? '';

    if (complexEmoji.isNotEmpty) {
      analyzeComplexEmoji(complexEmoji);
    } else {
      print('Строка пуста, анализ невозможен.');
    }
  }

  print('\nСпасибо, приходите снова!');
}

String getUnicodeCodePoint(String emoji) {
  final runes = emoji.runes.toList();
  if (runes.isEmpty) return 'U+0000';
  return 'U+${runes[0].toRadixString(16).toUpperCase().padLeft(4, '0')}';
}

void analyzeComplexEmoji(String input) {
  print('\nАнализ строки "$input":');

  final utf16Length = input.length;
  print('- 16-битных единиц: $utf16Length');

  final codePoints = input.runes.toList();
  print('- Кодовых точек: ${codePoints.length}');

  final realCharacters = input.characters.toList();
  print('- Реальных символов: ${realCharacters.length}');

  print('\nПодробный вывод юникода:');
  
  int charIndex = 1;
  for (var grapheme in realCharacters) {
    final runesInGrapheme = grapheme.runes.toList();
    
    if (runesInGrapheme.length == 1) {
      print('Символ $charIndex: $grapheme → ${formatUnicode(runesInGrapheme[0])}');
    } else {
      print('Символ $charIndex: $grapheme');
      for (var i = 0; i < runesInGrapheme.length; i++) {
        final codePoint = runesInGrapheme[i];
        final codePointStr = formatUnicode(codePoint);
        
        if (codePoint == 0x200D) {
          print('  → U+200D (Zero Width Joiner)');
        } else {
          print('  → $codePointStr');
        }
      }
    }
    charIndex++;
  }

  print('\n--- Разница в подсчете символов ---');
  print('Обычная длина: $utf16Length');
  print('Длина по рунам: ${codePoints.length}');
  print('Длина по реальным символам: ${realCharacters.length}');
}

String formatUnicode(int codePoint) {
  final hex = codePoint.toRadixString(16).toUpperCase();
  return 'U+${hex.padLeft(hex.length > 4 ? hex.length : 4, '0')}';
}