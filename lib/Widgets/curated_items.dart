import 'package:flutter/material.dart';
import '../../../model/product_model.dart';

class CuratedItems extends StatelessWidget {
  final ProductModel productModel;
  const CuratedItems({super.key required this.productModel});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Product.image),
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
              "H&M",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black26,
              ),
            ),
            SizedBox(width: 5),
            Icon(Icons.star, color: Colors.amber, size: 17),
            Text(Product.rating.toString()),
            Text(
              '(${Product.reviews})',
              style: TextStyle(color: Colors.black26),
            ),
            SizedBox(
              width: size.width * 0.5,
              child: Text(
                Product.name,
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
              "\$${Product.price.toString()}.00",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.pink,
                height: 1.5,
              ),
            ),
            SizedBox(width: 5),
            if (Product.isCheck == true)
              Text(
                "\$${Product.price + 255}.00",
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
