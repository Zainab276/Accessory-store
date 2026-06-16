// lib/main.dart
import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(BuyingFramesApp());

class BuyingFramesApp extends StatelessWidget {
  const BuyingFramesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buying Frames UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(size: Size(constraints.maxWidth, constraints.maxHeight)),
            child: SplashScreen(),
          );
        },
      ),
    );
  }
}

/// Splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 850),
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();

    Timer(Duration(milliseconds: 1600), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.pink.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: ScaleTransition(
          scale: _anim,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  size: 74,
                  color: Colors.pink,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Buying Frames',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'Smooth responsive shopping UI',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Product model
class Product {
  final String id, title, brand, description;
  final double price;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.price,
    required this.images,
  });
}

/// Demo products
final demoProducts = <Product>[
  Product(
    id: 'p1',
    title: 'Aeris Runner Sneakers',
    brand: 'Aeris',
    description:
        'Lightweight breathable running sneakers with cushioned sole and modern style. Perfect for daily wear.',
    price: 129.99,
    images: [
      'https://img.drz.lazcdn.com/static/pk/p/f87a62ce6598799e352b666c50ae6020.jpg_720x720q80.jpg',
      'https://www.shutterstock.com/image-photo/fashionable-black-sneaker-air-on-600nw-2632339409.jpg',
      'https://img.lazcdn.com/g/p/1ce90b929b113f8de473d13a2b5e8fd1.jpg_720x720q80.jpg',
    ],
  ),
  Product(
    id: 'p2',
    title: 'Nimbus Wireless Headphones',
    brand: 'Nimbus',
    description:
        'Over-ear noise cancelling wireless headphones with long battery life and immersive sound.',
    price: 199.00,
    images: [
      'https://ubonindia.com/cdn/shop/files/hp-740-black.jpg?v=1748938735&width=720',
    ],
  ),
  Product(
    id: 'p3',
    title: 'Classic Aviator Sunglasses',
    brand: 'RayTone',
    description:
        'Stylish aviator sunglasses with UV protection lenses. Perfect for sunny days.',
    price: 79.00,
    images: [
      'https://jokerandwitch.com/cdn/shop/files/JWSG168_2_c78e554e-a26c-419f-aa31-e09f77821c92_720x.jpg?v=1749470708',
    ],
  ),
  Product(
    id: 'p4',
    title: 'Urban Smartwatch',
    brand: 'TimeTech',
    description:
        'Smartwatch with fitness tracking, notifications, and sleek modern design.',
    price: 149.99,
    images: [
      'https://www.stf.tech/cdn/shop/files/KRONOSELEMENT1copy.jpg?v=1724786349&width=720',
    ],
  ),
];

/// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedCategory = 0;
  final categories = ['Featured', 'Sneakers', 'Headphones', 'Bags'];

  Product? selectedProduct = demoProducts.isNotEmpty ? demoProducts[0] : null;

  late AnimationController _bgController;
  late Animation<Color?> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 6),
    )..repeat(reverse: true);
    _bgAnimation = ColorTween(
      begin: Colors.pink.shade50,
      end: Colors.pink.shade100,
    ).animate(_bgController);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  /// Filter products based on category
  List<Product> get filteredProducts {
    if (categories[selectedCategory] == 'Featured') return demoProducts;
    return demoProducts
        .where(
          (p) => p.title.toLowerCase().contains(
            categories[selectedCategory].toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isWide = mq.size.width > 900;

    return AnimatedBuilder(
      animation: _bgAnimation,
      builder: (context, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_bgAnimation.value!, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: _catalogColumn(heroSuffix: '-desktop'),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: selectedProduct != null
                            ? ProductDetailContent(
                                product: selectedProduct!,
                                heroTagSuffix: '-desktop',
                              )
                            : Center(
                                child: Text(
                                  'Select a product to view details',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  );
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        _catalogColumn(heroSuffix: '-mobile'),
                        if (selectedProduct != null)
                          ProductDetailContent(
                            product: selectedProduct!,
                            heroTagSuffix: '-mobile',
                          ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _catalogColumn({required String heroSuffix}) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Buying Frames',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _categoryChips(),
          SizedBox(height: 12),
          _featuredList(heroSuffix),
          SizedBox(height: 16),
          Text(
            'Recommended',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...filteredProducts.map(
            (p) => _productListTile(p, heroSuffix: heroSuffix),
          ),
        ],
      ),
    );
  }

  Widget _categoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (_, i) => ChoiceChip(
          label: Text(categories[i]),
          selected: i == selectedCategory,
          onSelected: (_) => setState(() => selectedCategory = i),
          selectedColor: Colors.pink.shade100,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _featuredList(String heroSuffix) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProducts.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = filteredProducts[i];
          return GestureDetector(
            onTap: () => setState(() => selectedProduct = p),
            child: Stack(
              children: [
                Hero(
                  tag: '${p.id}-featured-$heroSuffix',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 180, // fixed width
                      height: 220, // fixed height
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.network(
                        p.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'FEATURED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _productListTile(Product p, {required String heroSuffix}) {
    final isSelected = selectedProduct?.id == p.id;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () => setState(() => selectedProduct = p),
        child: Hero(
          tag: '${p.id}-tile-$heroSuffix',
          child: Material(
            elevation: isSelected ? 6 : 2,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: isSelected ? Colors.pink.shade50 : Colors.white,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: Image.network(p.images.first, fit: BoxFit.cover),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.brand,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          p.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${p.price.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.add_shopping_cart_outlined, color: Colors.pink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Product Detail
class ProductDetailContent extends StatefulWidget {
  final Product product;
  final String heroTagSuffix;
  const ProductDetailContent({
    super.key,
    required this.product,
    this.heroTagSuffix = '',
  });

  @override
  _ProductDetailContentState createState() => _ProductDetailContentState();
}

class _ProductDetailContentState extends State<ProductDetailContent> {
  int qty = 1;
  int selectedTab = 0;
  int activeImageIndex = 0; // For dots
  final tabs = ['Description', 'Reviews', 'Specifications'];
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final heroTag = '${p.id}-detail-${widget.heroTagSuffix}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 5, child: _imageCarousel(p, heroTag)),
                      SizedBox(width: 24),
                      Expanded(flex: 5, child: _productInfoPanel(p)),
                    ],
                  )
                : Column(
                    children: [
                      _imageCarousel(p, heroTag),
                      SizedBox(height: 16),
                      _productInfoPanel(p),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _imageCarousel(Product p, String heroTag) {
    return Column(
      children: [
        Hero(
          tag: heroTag,
          child: Container(
            height: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: PageView.builder(
                controller: _pageController,
                itemCount: p.images.length,
                onPageChanged: (index) =>
                    setState(() => activeImageIndex = index),
                itemBuilder: (context, index) => Image.network(
                  p.images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey.shade200),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        // Pink dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            p.images.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: activeImageIndex == index ? 12 : 8,
              height: activeImageIndex == index ? 12 : 8,
              decoration: BoxDecoration(
                color: activeImageIndex == index
                    ? Colors.pink
                    : Colors.pink.shade100,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _productInfoPanel(Product p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(p.brand, style: TextStyle(color: Colors.grey[600])),
        SizedBox(height: 6),
        Text(
          p.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          '\$${p.price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        SizedBox(height: 16),

        // Tabs
        Row(
          children: tabs
              .asMap()
              .entries
              .map(
                (entry) => GestureDetector(
                  onTap: () => setState(() => selectedTab = entry.key),
                  child: Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    decoration: BoxDecoration(
                      color: selectedTab == entry.key
                          ? Colors.pink
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: selectedTab == entry.key
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 12),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            selectedTab == 0
                ? p.description
                : selectedTab == 1
                ? 'No reviews yet.'
                : 'Specifications not available.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 20),

        // Quantity selector
        Row(
          children: [
            Text('Quantity:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 12),
            _qtySelector(),
          ],
        ),
        SizedBox(height: 16),

        // Action buttons row
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added ${p.title} to cart')),
                ),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade400, Colors.pink.shade600],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade200.withOpacity(0.5),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_shopping_cart, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Add to Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Proceeding to buy ${p.title}')),
                ),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(color: Colors.pink.shade400, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withOpacity(0.5),
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flash_on, color: Colors.pink.shade400),
                      SizedBox(width: 8),
                      Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.pink.shade400,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _qtySelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: 20),
            onPressed: () => setState(() => qty = qty > 1 ? qty - 1 : 1),
          ),
          Text(qty.toString(), style: TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.add, size: 20),
            onPressed: () => setState(() => qty++),
          ),
        ],
      ),
    );
  }
}
