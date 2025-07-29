import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 120,
                  width: 120,
                  child: CustomPaint(painter: _ArcPainter()),
                ),
                // Product image
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(product.imageUrl),
                  onBackgroundImageError: (_, __) {},
                ),
                // Logo badge
                Positioned(
                  top: 5,
                  left: 10,
                  child: Image.asset(
                    'assets/images/burger_king.png',
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Product name
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 20, 104, 194),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price and Quantity control in one row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _QuantityControl(product: product),
                      Text(
                        product.price.toStringAsFixed(2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 56, 142, 235),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 207, 180, 41)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2 - 2,
    );
    canvas.drawArc(rect, 0, 2 * 3.141592653589793, false, paint); // Full circle
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _QuantityControl extends StatelessWidget {
  final Product product;
  const _QuantityControl({required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Container(
      width: 96,
      height: 40,
      constraints: const BoxConstraints(maxWidth: 100, minWidth: 50),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.add, size: 14, color: Color(0xFF007AFF)),
            splashRadius: 16,
            padding: EdgeInsets.zero,
            onPressed: () {
              provider.updateProduct(
                Product(
                  id: product.id,
                  name: product.name,
                  price: product.price,
                  imageUrl: product.imageUrl,
                  quantity: product.quantity + 1,
                ),
              );
            },
          ),
          Expanded(
            child: Center(
              child: Text(
                '${product.quantity}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF222B45),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove, size: 14, color: Color(0xFF007AFF)),
            splashRadius: 16,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (product.quantity > 0) {
                provider.updateProduct(
                  Product(
                    id: product.id,
                    name: product.name,
                    price: product.price,
                    imageUrl: product.imageUrl,
                    quantity: product.quantity - 1,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
