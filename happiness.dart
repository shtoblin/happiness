import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:characters/characters.dart';

enum Mood {
  happy('\u{1F600}', 'счастливый', 8),
  excited('\u{1F60E}', 'взволнованный', 9),
  sad('\u{1F61E}', 'грустный', 3),
  angry('\u{1F621}', 'злой', 2),
  inLove('\u{1F60D}', 'влюбленный', 10),
  tired('\u{1F634}', 'сонный', 4);

  final String emoji;
  final String description;
  final int energy;

  const Mood(this.emoji, this.description, this.energy);
}

void main(){

  stdout.write('Как тебя зовут? ');
  String name = stdin.readLineSync(encoding: utf8) ?? '';
  
  Random random = Random();
  Mood currentMood = Mood.values[random.nextInt(Mood.values.length)];
  
  print('Привет, $name! Сегодня ты ${currentMood.emoji} ${currentMood.description} (энергия: ${currentMood.energy}/10)');
  
  print('\nКод твоего смайлика: ${getEmojiCode(currentMood.emoji)}');
  
  stdout.write('\nХочешь изучить сложные эмодзи? (да/нет): ');
  String choice = stdin.readLineSync(encoding: utf8) ?? '';
  
  if (choice == 'да') {
    stdout.write('Напиши любую комбинацию эмодзи: ');
    String emojiString = stdin.readLineSync(encoding: utf8) ?? '';
    
    if (emojiString.isNotEmpty) {
      analyzeEmoji(emojiString);
    } else {
      print('Ты ничего не ввел :(');
    }
  }
  
  print('\nДо новых встреч!');
}

String getEmojiCode(String emoji) {
  int codePoint = emoji.runes.first;
  return 'U+${codePoint.toRadixString(16).toUpperCase()}';
}

void analyzeEmoji(String text) {
  print('\nРазбор строки "$text":');
  print('Длина в UTF-16: ${text.length}');
  print('Количество кодовых точек: ${text.runes.length}');
  print('Количество настоящих символов: ${text.characters.length}');
  
  print('\nРазбор:');
  
  List<String> realSymbols = text.characters.toList();
  
  for (int i = 0; i < realSymbols.length; i++) {
    String symbol = realSymbols[i];
    List<int> symbolCodes = symbol.runes.toList();
    
    print('\nСимвол ${i + 1}: $symbol');
    
    for (int code in symbolCodes) {
      if (code == 0x200D) {
        print('  - U+200D (невидимый соединитель)');
      } else {
        String hexCode = code.toRadixString(16).toUpperCase();
        print('  - U+$hexCode');
      }
    }
  }
  // print('String.length = ${text.length};
  // print('runes.length = ${text.runes.length};
  // print('characters.length = ${text.characters.length};
}
