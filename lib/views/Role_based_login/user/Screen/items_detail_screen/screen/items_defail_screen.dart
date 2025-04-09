import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../core/model/product_model.dart';

class ItemsDefailScreen extends StatefulWidget {
  final Product productModel;
  const ItemsDefailScreen({super.key, required this.productModel});

  @override
  State<ItemsDefailScreen> createState() => _ItemsDefailScreenState();
}

class _ItemsDefailScreenState extends State<ItemsDefailScreen> {
  int currentIndex = 0;
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  Color selectedColor = Colors.blue;

  Color _hexToColor(String hex) {
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final product = widget.productModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black26,
        title: const Text("Бүтээгдэхүүн"),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Iconsax.shopping_bag, size: 28),
              Positioned(
                right: -3,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "3",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.black26,
            height: size.height * 0.46,
            width: size.width,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Image.network(
                      product.image,
                      height: size.height * 0.4,
                      width: size.width * 0.85,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 7),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                index == currentIndex
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "H&M",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black26,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.star, color: Colors.amber, size: 17),
                    Text(product.rating.toString()),
                    Text(
                      '(${product.reviews})',
                      style: const TextStyle(color: Colors.black26),
                    ),
                    const Spacer(),
                    const Icon(Icons.favorite_border, color: Colors.black26),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "\$${product.price}.00",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(width: 5),
                    if (product.isCheck == true)
                      Text(
                        "\$${product.price}.00",
                        style: const TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  product.description,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black38,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Color selection
                    SizedBox(
                      width: size.width / 2.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Өнгө",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  product.color.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final colorStr = entry.value;
                                    final color = _hexToColor(colorStr);
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: color,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedColorIndex = index;
                                              selectedColor = color;
                                            });
                                          },
                                          child: Icon(
                                            Icons.check,
                                            color:
                                                selectedColorIndex == index
                                                    ? Colors.white
                                                    : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Size selection
                    SizedBox(
                      width: size.width / 2.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Size",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children:
                                  product.size.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final sizeVal = entry.value;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedSizeIndex = index;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              selectedSizeIndex == index
                                                  ? selectedColor
                                                  : Colors.black12,
                                          border: Border.all(
                                            color:
                                                selectedSizeIndex == index
                                                    ? selectedColor
                                                    : Colors.black12,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            sizeVal,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  selectedSizeIndex == index
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.white,
        label: SizedBox(
          width: size.width * 0.9,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ), // Adjusted vertical padding
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Iconsax.shopping_bag, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Картанд нэмэх',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ), // Adjusted vertical padding
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      'Худалдаж авах',
                      style: TextStyle(color: Colors.white, letterSpacing: -1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
