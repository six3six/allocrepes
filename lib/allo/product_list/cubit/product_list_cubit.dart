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
      Map<Category, List<Product>> categories = {};

      cats.forEach((cat) {
        categories[cat] = [];
        emit(state.copyWith(categories: categories));

        orderRepository.productsFromCategory(cat).forEach((prods) {
          Map<Category, List<Product>> categories = {}
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
    orderRepository.updateProductAvailability(category, product, availability);
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
    TextEditingController controller = TextEditingController();

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
                  decoration: InputDecoration(hintText: "Nom"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                orderRepository.addCategory(Category(name: controller.text));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addProductDialog(BuildContext context, Category category) {
    TextEditingController controller = TextEditingController();

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
                  decoration: InputDecoration(hintText: "Nom"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                orderRepository.addProduct(
                  category,
                  Product(
                    name: controller.text,
                    available: false,
                    maxAmount: 0,
                    initialStock: 0,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> editCategoryDialog(BuildContext context, Category category) {
    TextEditingController controller =
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
                  decoration: InputDecoration(hintText: "Nom"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                orderRepository.updateCategory(category.copyWith(
                  name: controller.text,
                ));
                Navigator.of(context).pop();
              },
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
              child: Text(
                'Annuler',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                orderRepository.deleteCategory(category);
                Navigator.of(context).pop();
              },
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
                  child: Text(
                    'Annuler',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Confirmer'),
                  onPressed: () {
                    orderRepository.removeProduct(category, productId);
                    Navigator.of(context).pop(true);
                  },
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
