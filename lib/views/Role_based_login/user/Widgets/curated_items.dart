import 'package:flutter/material.dart';
import '../model/product_model.dart';

class CuratedItems extends StatelessWidget {
  final Product productModel;
  const CuratedItems({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get the size of the screen

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                productModel.image, // Use productModel.image
              ),
            ),
          ),
          height: size.height * 0.25,
          width: size.width * 0.5,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black26,
                child: Icon(Icons.favorite_border),
              ),
            ),
          ),
        ),
        SizedBox(height: 7),
        Row(
          children: [
            Text(
              productModel.category.name, // Use productModel.category.name
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black26,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.star, color: Colors.amber, size: 17),
            Text(productModel.rating.toString()), // Use productModel.rating
            Text(
              '(${productModel.reviews})', // Use productModel.reviews
              style: TextStyle(color: Colors.black26),
            ),
            SizedBox(
              width: size.width * 0.5,
              child: Text(
                productModel.name, // Use productModel.name
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "\$${productModel.price.toString()}.00", // Use productModel.price
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.pink,
                height: 1.5,
              ),
            ),
            SizedBox(width: 5),
            if (productModel.isCheck == true) // Use productModel.isCheck
              Text(
                "\$${double.parse(productModel.price) + 255}.00", // Ensure price calculation is correct
                style: TextStyle(
                  color: Colors.black26,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black26,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
