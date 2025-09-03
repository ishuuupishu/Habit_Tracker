import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../providers/quotes_provider.dart';
import '../../widgets/quote_card.dart';

class FavoriteQuotesScreen extends StatelessWidget {
  const FavoriteQuotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quotesProvider = Provider.of<QuotesProvider>(context);
    final favorites = quotesProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Favorite Quotes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        actions: [
          if (favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white.withOpacity(0.2),
                    child: Text(
                      favorites.length.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.05),
              Colors.white.withOpacity(0.8),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: favorites.isEmpty
            ? _buildEmptyState()
            : AnimationLimiter(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    await quotesProvider.loadFavorites();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final quote = favorites[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 450),
                        child: SlideAnimation(
                          verticalOffset: 60.0,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      AppColors.primary.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: QuoteCard(
                                  quote: quote,
                                  isFavorite: true,
                                  onFavoriteToggle: () {
                                    quotesProvider.toggleFavorite(quote);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      _buildRemovedSnackBar(quote.text),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }

  /// Empty state when no favorites
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.favorite,
                size: 80,
                color: AppColors.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No favorites yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap the heart icon on any quote to add it to your favorites.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom snackbar
  SnackBar _buildRemovedSnackBar(String quoteText) {
    return SnackBar(
      backgroundColor: AppColors.primary.withOpacity(0.9),
      content: Text(
        'Removed from favorites: "${_truncateQuote(quoteText)}"',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: Colors.yellowAccent,
        onPressed: () {
          
        },
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.all(14),
    );
  }

  String _truncateQuote(String quoteText) {
    const maxLength = 40;
    return quoteText.length > maxLength
        ? '${quoteText.substring(0, maxLength)}...'
        : quoteText;
  }
}
