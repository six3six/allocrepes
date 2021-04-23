import 'package:allocrepes/allo/product_list/cubit/product_list_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit(this.orderRepository) : super(const ProductListState()) {
    getProducts();
    orderRepository.showOrderPages().forEach(
          (showOrderPages) => emit(
            state.copyWith(showOrderPages: showOrderPages),
          ),
        );
  }

  final OrderRepository orderRepository;

  void getProducts() {
    orderRepository.categories().forEach((cats) {
      var categories = <Category, List<Product>>{};

      cats.forEach((cat) {
        categories[cat] = [];
        emit(state.copyWith(categories: categories));

        orderRepository.productsFromCategory(cat).forEach((prods) {
          var categories = <Category, List<Product>>{}
            ..addAll(state.categories);
          categories[cat] = prods;
          emit(state.copyWith(categories: categories));
        });
      });

      emit(state.copyWith(categories: categories));
    });
  }

  void updateProductAvailability(
    Category category,
    Product product,
    bool availability,
  ) {
    orderRepository.updateProductAvailability(
      category,
      product,
      availability,
    );
  }

  void updateProductAvailabilityESIEE(
    Category category,
    Product product,
    bool availability,
  ) {
    orderRepository.updateProductAvailabilityESIEE(
      category,
      product,
      availability,
    );
  }

  void updateProductOneOrder(
    Category category,
    Product product,
    bool oneOrder,
  ) {
    orderRepository.updateProductOneOrder(
      category,
      product,
      oneOrder,
    );
  }

  void updateProductMaxAmount(
    Category category,
    String productId,
    int maxAmount,
  ) {
    orderRepository.updateProductMaxAmount(category, productId, maxAmount);
  }

  void removeProduct(Category category, String productId) {
    orderRepository.removeProduct(category, productId);
  }

  void updateProductName(Category category, String productId, String name) {
    orderRepository.updateProductName(category, productId, name);
  }

  Future<void> addCategoryDialog(BuildContext context) {
    var controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une catégorie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Quel nom voulez vous donner à votre catégorie ?'),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Nom'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                orderRepository.addCategory(Category(name: controller.text));
                Navigator.of(context).pop();
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addProductDialog(BuildContext context, Category category) {
    var controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une un produit'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Vous vous apprêtez à ajouter un produit dans la catégorie ${category.name}',
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Quel nom voulez-vous donner à votre produit ?'),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Nom'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                orderRepository.addProduct(
                  category,
                  Product.empty.copyWith(name: controller.text),
                );
                Navigator.of(context).pop();
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editCategoryDialog(BuildContext context, Category category) {
    var controller =
        TextEditingController(text: category.name);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier une catégorie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Quel nom voulez vous donner à votre catégorie ?'),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Nom'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                orderRepository.updateCategory(category.copyWith(
                  name: controller.text,
                ));
                Navigator.of(context).pop();
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCategoryDialog(BuildContext context, Category category) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer une catégorie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous supprimer ${category.name} ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Annuler',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                orderRepository.deleteCategory(category);
                Navigator.of(context).pop();
              },
              child: Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> deleteProductDialog(
    BuildContext context,
    Category category,
    String productId,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Supprimer un produit'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Voulez-vous supprimer cet article ?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    orderRepository.removeProduct(category, productId);
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Confirmer'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void changeOrderPagesView(bool view) {
    orderRepository.changeOrderPagesView(view);
  }
}
