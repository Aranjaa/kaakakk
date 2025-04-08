import '../../../model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ItemsDefailScreen extends StatelessWidget {
  final ProductModel productModel;
  const ItemsDefailScreen({super.key, required this.productModel});
  @override
  State<ItemsDefailScreen> createState() => _ItemsDefailScreenState();
}

class _ItemsDefailScreenState extends State<ItemsDefailScreen> {
  int currentIndex = 0;
  int selectedColorIndex = 1;
  int selectedSizeIndex = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black26,
        title: Text("Defaul Product"),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Iconsax.shopping_bag, size: 28),
              Positioned(
                right: -3,
                top: -5,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
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
                    Image.asset(
                      widget.productModel.image,
                      height: size.height * 0.4,
                      width: size.width * 0.85,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: Duration(microseconds: 300),
                          margin: EdgeInsets.only(right: 7),
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
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "H&M",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black26,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.star, color: Colors.amber, size: 17),
                    Text(widget.productModel.rating.toString()),
                    Text(
                      '(${widget.productModel.reviews})',
                      style: TextStyle(color: Colors.black26),
                    ),
                    Text(
                      widget.productModel.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.favorite_border, color: Colors.black26),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "\$${widget.productModel.price.toString()}.00",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.pink,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(width: 5),
                    if (widget.productModel.isCheck == true)
                      Text(
                        "\$${widget.productModel.price + 255}.00",
                        style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black26,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 15),
                Text(
                  "$description ${widget.productModel.description}$description2 ",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black38,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width / 2.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Color",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: widget.productModel.color.asMap().entries.map((entry){
                              final int index = entry.key;
                              final color = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(top: 10,right: 10),
                                Child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: color,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedColorIndex = index;
                                      });
                                    },
                                    child: Icon(Icons.check, color: selectedColorIndex == index ? Colors.white : Colors.transparent,),
                                  ),
                                )
                              )
                            }).toList(),
                            ),)
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width / 2.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Size",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(children: widget.productModel.size.asMap().entries.map((entry){
                              final int index = entry.key;
                              final String size = entry.value;
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(top:10, right: 10),
                                  height: 35, width: 35,  decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: selectedSizeIndex == index ? color : Colors.black12, color: Colors.white, 
                                    border: Border.all(
                                      color: selectedSizeIndex == index ? color: Colors.black, color : Colors.black12
                                      ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: selectedSizeIndex == index ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            }).toList(),
                            ),)
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
      floatingActionButtonlocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        elevation: 0,
        label: Text(
          width:size.width * 0.9,
        )
      );    
    );
  }
}
