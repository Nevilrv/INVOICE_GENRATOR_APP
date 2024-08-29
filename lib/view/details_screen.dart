import 'package:flutter/material.dart';
import 'package:invoice_generator/controller/add_product_controller.dart';

import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import 'bottom_nav_bar.dart';

class DetailScreen extends StatefulWidget {
  final name;
  final price;
  final variation;
  final qty;
  final image;

  const DetailScreen(
      {Key? key, this.name, this.price, this.variation, this.qty, this.image})
      : super(key: key);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final provider = Provider.of<AddProductController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        floatingActionButton: GestureDetector(
          onTap: () async {
            provider.addInfo(widget.name, widget.price, widget.variation,
                widget.qty, widget.image);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavScreen(index: 1),
              ),
            );
          },
          child: Container(
            height: 6.5.h,
            width: 20.5.h,
            decoration: BoxDecoration(
              color: const Color(0xff3881D8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'Add to Invoice',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: screenSize.height * 0.50,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("${widget.image}"), fit: BoxFit.cover),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Price: ${widget.price}",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Variation: ${widget.variation}",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Quantity: ${widget.qty}",
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
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
