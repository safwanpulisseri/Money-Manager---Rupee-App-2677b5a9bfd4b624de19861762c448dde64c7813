import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/category_controller.dart';
import 'package:rupee_app/model/db_cards.dart';

final ValueNotifier<List<CardModel>> cardModelNotifier =
    ValueNotifier<List<CardModel>>([]);

class CardModelFunctions {
  static const String cardBoxName = 'cardBox';

  Future<Box<CardModel>> _openCardBox() async {
    return await Hive.openBox<CardModel>('cardBox');
  }

  Future<void> addCard(CardModel card) async {
    final box = await _openCardBox();
    await box.put(card.id, card);
    cardModelNotifier.value.add(card);
    categoryModelNotifier.notifyListeners();
  }

  Future<void> getAllCards() async {
    final box = await _openCardBox();
    final cards = box.values.toList();
    cardModelNotifier.value = cards;
    cardModelNotifier.notifyListeners();
  }

  Future<void> deleteCard(String cardId) async {
    final box = await _openCardBox();
    await box.delete(cardId);
    cardModelNotifier.value = box.values.toList();
    cardModelNotifier.notifyListeners();
  }

  Future<void> updateCard(String cardId, CardModel updatedCard) async {
    final box = await _openCardBox();
    await box.put(cardId, updatedCard);
    cardModelNotifier.value = box.values.toList();
    cardModelNotifier.notifyListeners();
  }
}
