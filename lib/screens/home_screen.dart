import 'package:flutter/material.dart';
import 'package:kartngo/models/product.dart';
import 'package:kartngo/providers/product_provider.dart';
import 'package:kartngo/screens/demo_screen.dart';
import 'package:kartngo/widgets/filter_chip_row.dart';
import 'package:kartngo/widgets/product_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> filters = [
    'أفضل العروض',
    'مستورد',
    'أجبان قابلة للدهن',
    'أجبان',
  ];
  int selectedFilter = 0;
  List<Product> filteredProducts = [];
  String searchText = '';

  void filterProducts(List<Product> allProducts) {
    List<Product> temp = allProducts;
    // Apply filter chip logic
    if (selectedFilter == 1) {
      temp = temp.where((p) => p.name.contains('Steakhouse')).toList();
    } else if (selectedFilter == 2) {
      temp = temp.where((p) => p.name.contains('Cheese')).toList();
    } else if (selectedFilter == 3) {
      temp = temp.where((p) => p.name.contains('Whopper')).toList();
    }
    // Apply search
    if (searchText.isNotEmpty) {
      temp = temp
          .where((p) => p.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    filteredProducts = temp;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppBar(
              surfaceTintColor: const Color.fromARGB(255, 230, 237, 243),
              backgroundColor: const Color.fromARGB(255, 230, 237, 243),
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'التصنيفات',
                style: TextStyle(
                  color: Color(0xFF222B45),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFF222B45),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DemoScreen()),
                  );
                },
              ),
              iconTheme: const IconThemeData(color: Color(0xFF222B45)),
            ),
          ),
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            filterProducts(provider.products);
            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن منتج...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchText = value;
                        filterProducts(provider.products);
                      });
                    },
                  ),
                ),
                // Filter chips row
                FilterChipRow(
                  filters: filters,
                  selectedFilter: selectedFilter,
                  onFilterSelected: (index) {
                    setState(() {
                      selectedFilter = index;
                      filterProducts(provider.products);
                    });
                  },
                ),
                // Product grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Center(
                                child: Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: ProductCard(product: product),
                      );
                    },
                  ),
                ),
                // Bottom cart bar
                const _CartBar(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CartBar extends StatelessWidget {
  const _CartBar();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final total = provider.products.fold<double>(
      0,
      (sum, p) => sum + (p.price * p.quantity),
    );
    return Container(
      margin: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xff589fd8),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${total.toStringAsFixed(2)} SAR',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),

                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(child: Text('عرض السلة')),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          'عرض السلة',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
