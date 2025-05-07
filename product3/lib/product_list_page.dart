import 'package:flutter/material.dart';
import 'package:product3/product_detail_page.dart';
import 'package:product3/product_model.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];
  int currentPage = 0;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    fetchProducts().then((data) {
      setState(() {
        products = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalPages = (products.length / itemsPerPage).ceil();
    final List<Product> currentProducts = products.skip(currentPage * itemsPerPage).take(itemsPerPage).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Danh sách sản phẩm')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentProducts.length,
              itemBuilder: (context, index) {
                final product = currentProducts[index];
                return ListTile(
                  leading: Image.network(product.image, width: 50, height: 50),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentPage > 0
                    ? () {
                  setState(() {
                    currentPage--;
                  });
                }
                    : null,
                child: Text('Trang trước'),
              ),
              ElevatedButton(
                onPressed: currentPage < totalPages - 1
                    ? () {
                  setState(() {
                    currentPage++;
                  });
                }
                    : null,
                child: Text('Trang sau'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}