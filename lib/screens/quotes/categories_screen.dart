import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/quotes_provider.dart';
import '../../widgets/category_card.dart';
import '../../constants/app_colors.dart';
import 'quotes_category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _tappedCategory;

  void _onCategoryTap(String category) async {
    final quotesProvider = Provider.of<QuotesProvider>(context, listen: false);

    setState(() {
      _tappedCategory = category;
    });

    // Load quotes first
    await quotesProvider.loadQuotesByCategory(category);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuotesCategoryScreen(category: category),
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _tappedCategory = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quotesProvider = Provider.of<QuotesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Categories'),
        backgroundColor: AppColors.primary,
        elevation: 2,
        centerTitle: true,
      ),
      body: quotesProvider.categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: quotesProvider.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final category = quotesProvider.categories[index];
                  return GestureDetector(
                    onTap: () => _onCategoryTap(category),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: _tappedCategory == category
                            ? LinearGradient(
                                colors: [Colors.orange.shade300, Colors.orange.shade600],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : LinearGradient(
                                colors: [Colors.blue.shade200, Colors.blue.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
