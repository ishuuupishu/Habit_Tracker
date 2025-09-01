import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/habit_model.dart';
import '../models/quote_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== Users ====================
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  // ==================== Habits ====================
  Stream<List<HabitModel>> getHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .orderBy('createdAt', descending: true) // ✅ newest first
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => HabitModel.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> saveHabit(String userId, HabitModel habit) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habit.id)
        .set(habit.toMap(), SetOptions(merge: true)); // ✅ merge prevents overwrite
  }

  Future<void> deleteHabit(String userId, String habitId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .doc(habitId)
        .delete();
  }

  // ==================== Favorite Quotes ====================
  Future<List<QuoteModel>> getFavoriteQuotes(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('quotes')
        .collection('items')
        .get();

    return snapshot.docs
        .map((doc) => QuoteModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addFavoriteQuote(String userId, QuoteModel quote) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('quotes')
        .collection('items')
        .doc(quote.id)
        .set(quote.toMap());
  }

  Future<void> removeFavoriteQuote(String userId, QuoteModel quote) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc('quotes')
        .collection('items')
        .doc(quote.id)
        .delete();
  }
}