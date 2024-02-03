import 'package:hive_flutter/hive_flutter.dart';
part 'db_cards.g.dart';

@HiveType(typeId: 3)
class CardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cardNumber;

  @HiveField(2)
  final String cardValid;

  @HiveField(3)
  final String cardHolder;
  CardModel(
      {required this.id,
      required this.cardNumber,
      required this.cardValid,
      required this.cardHolder});
}
