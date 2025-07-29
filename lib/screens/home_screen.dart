import 'package:flutter/material.dart';
import 'package:kartngo/providers/product_provider.dart';
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF222B45)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Center(child: Text('البحث'))),
                    );
                  },
                ),
              ],
              iconTheme: const IconThemeData(color: Color(0xFF222B45)),
            ),
          ),
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                // Filter chips row
                FilterChipRow(
                  filters: filters,
                  selectedFilter: selectedFilter,
                  onFilterSelected: (index) {
                    setState(() {
                      selectedFilter = index;
                      // TODO: Optionally filter products based on selection
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
                    itemCount: provider.products.length,
                    itemBuilder: (context, index) {
                      final product = provider.products[index];
                      return ProductCard(product: product);
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
      // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
