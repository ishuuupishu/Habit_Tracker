import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../models/quote_model.dart';
import '../../providers/quotes_provider.dart';
import '../../widgets/quote_card.dart';
import '../../constants/app_colors.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({Key? key}) : super(key: key);

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  String selectedCategory = "Motivation";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quotesProvider = Provider.of<QuotesProvider>(context, listen: false);
      quotesProvider.loadQuotesByCategory(selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          selectedCategory,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Consumer<QuotesProvider>(
            builder: (_, provider, __) => IconButton(
              icon: Badge(
                isLabelVisible: provider.favorites.isNotEmpty,
                label: Text(provider.favorites.length.toString()),
                child: const Icon(Icons.favorite, color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FavoriteQuotesScreen(
                      quotes: provider.favorites,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  "Quote Categories",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<QuotesProvider>(
                builder: (context, quotesProvider, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: quotesProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = quotesProvider.categories[index];
                      final isSelected = selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: ChoiceChip(
                          label: Text(category),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.black87,
                          ),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.grey[200],
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                            quotesProvider.loadQuotesByCategory(category);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.8),
              Colors.deepPurple.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Consumer<QuotesProvider>(
          builder: (context, quotesProvider, child) {
            if (quotesProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final quotes = quotesProvider.categoryQuotes;

            if (quotes.isEmpty) {
              return const Center(
                child: Text(
                  "No quotes available for this category",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
              itemCount: quotes.length,
              itemBuilder: (context, index) {
                final quote = quotes[index];
                final isCurrentlyFavorite = quotesProvider.favorites
                    .any((favQuote) => favQuote.id == quote.id);

                return Padding(
                  key: ValueKey(quote.id),
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: QuoteCard(
                        quote: quote,
                        isFavorite: isCurrentlyFavorite,
                        onFavoriteToggle: () {
                          quotesProvider.toggleFavorite(quote);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FavoriteQuotesScreen extends StatelessWidget {
  final List<QuoteModel> quotes;

  const FavoriteQuotesScreen({Key? key, required this.quotes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favorite Quotes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, Colors.deepPurple.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: quotes.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border,
                        size: 72, color: Colors.white.withOpacity(0.4)),
                    const SizedBox(height: 16),
                    Text(
                      "No favorite quotes yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap the heart icon to save quotes",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  final quote = quotes[index];
                  return Padding(
                    key: ValueKey(quote.id),
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: QuoteCard(
                          quote: quote,
                          isFavorite: true,
                          onFavoriteToggle: () {
                            final provider = Provider.of<QuotesProvider>(
                                context,
                                listen: false);
                            provider.toggleFavorite(quote);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
