import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../services/firestore_service.dart';

class QuotesProvider extends ChangeNotifier {
  final String userId;
  final FirestoreService _firestoreService = FirestoreService();

  List<QuoteModel> favorites = [];
  List<QuoteModel> categoryQuotes = [];
  List<String> categories = [];
  bool isLoading = false;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  // Local category-based quotes
  final Map<String, List<String>> localQuotes = {
    "Motivation": [
      "Do something today that your future self will thank you for.",
      "Little by little, one travels far.",
      "Your limitation—it's only your imagination.",
      "Push yourself, because no one else is going to do it for you.",
      "Great things never come from comfort zones.",
      "Dream it. Wish it. Do it.",
      "Success doesn't just find you. You have to go out and get it.",
      "The harder you work for something, the greater you'll feel when you achieve it.",
      "Don't stop when you're tired. Stop when you're done.",
      "Wake up with determination. Go to bed with satisfaction.",
    ],
    "Discipline": [
      "Discipline is the bridge between goals and accomplishment.",
      "Your habits will determine your future.",
      "Small daily improvements over time lead to stunning results.",
      "Motivation gets you started. Discipline keeps you going.",
      "The pain of discipline is nothing like the pain of regret.",
      "Discipline is choosing between what you want now and what you want most.",
      "Success is nothing more than a few simple disciplines practiced every day.",
      "Consistency is key.",
      "You don’t have to be extreme, just consistent.",
      "Self-control is strength.",
    ],
    "Success": [
      "Success is the sum of small efforts, repeated day in and day out.",
      "Don’t be afraid to give up the good to go for the great.",
      "Success usually comes to those who are too busy to be looking for it.",
      "Opportunities don't happen. You create them.",
      "Don't wait for opportunity. Create it.",
      "The road to success is always under construction.",
      "Success is walking from failure to failure with no loss of enthusiasm.",
      "The key to success is to focus on goals, not obstacles.",
      "Success is not in what you have, but who you become.",
      "Small wins lead to big successes.",
    ],
    "Habits": [
      "Small habits build big results.",
      "Your habits decide your tomorrow.",
      "Excellence is not an act, but a habit.",
      "Motivation is what gets you started. Habit is what keeps you going.",
      "We are what we repeatedly do. Excellence, then, is not an act, but a habit.",
      "Good habits formed at youth make all the difference.",
      "The chains of habit are too weak to be felt until they are too strong to be broken.",
      "Successful people are simply those with successful habits.",
      "Habits are the compound interest of self-improvement.",
      "Your life today is essentially the sum of your habits.",
    ],
    "Growth": [
      "Push yourself, because no one else is going to do it for you.",
      "Growth begins at the end of your comfort zone.",
      "What you do today can improve all your tomorrows.",
      "The only way to grow is to challenge yourself.",
      "Don’t limit your challenges. Challenge your limits.",
      "Change is painful, but nothing is as painful as staying stuck.",
      "Every next level of your life will demand a different you.",
      "Growth is never by mere chance; it is the result of forces working together.",
      "Strive for progress, not perfection.",
      "The biggest room in the world is the room for improvement.",
    ],
  };

  QuotesProvider({required this.userId}) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([
      loadFavorites(),
      loadCategories(),
    ]);
  }

  Future<void> loadCategories() async {
    categories = localQuotes.keys.toList();
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    isLoading = true;
    notifyListeners();

    favorites = await _firestoreService.getFavoriteQuotes(userId);

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadQuotesByCategory(String category) async {
    isLoading = true;
    _selectedCategory = category;
    notifyListeners();

    if (localQuotes.containsKey(category)) {
      categoryQuotes = localQuotes[category]!
          .asMap()
          .entries
          .map(
            (entry) => QuoteModel(
          id: '${category}_${entry.key}',
          text: entry.value,
          author: category,
          tags: [category],
          isFavorite:
          favorites.any((f) => f.id == '${category}_${entry.key}'),
        ),
      )
          .toList();
    } else {
      categoryQuotes = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(QuoteModel quote) async {
    final updatedQuote = quote.copyWith(isFavorite: !quote.isFavorite);

    if (updatedQuote.isFavorite) {
      await _firestoreService.addFavoriteQuote(userId, updatedQuote);
    } else {
      await _firestoreService.removeFavoriteQuote(userId, updatedQuote);
    }

    await loadFavorites();
  }
}