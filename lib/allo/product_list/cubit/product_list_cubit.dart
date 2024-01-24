import 'package:allocrepes/allo/product_list/cubit/product_list_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';
import 'package:setting_repository/setting_repository.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit(
    this._orderRepository,
    this._settingRepository,
  ) : super(const ProductListState()) {
    getProducts();
    _settingRepository.showOrderPages().forEach(
          (showOrderPages) => emit(
            state.copyWith(showOrderPages: showOrderPages),
          ),
        );
  }

  final OrderRepository _orderRepository;
  final SettingRepository _settingRepository;

  void getProducts() {
    _orderRepository.categories().forEach((cats) {
      var categories = <Category, List<Product>>{};

      for (var cat in cats) {
        categories[cat] = [];
        emit(state.copyWith(categories: categories));

        _orderRepository.productsFromCategory(cat).forEach((prods) {
          var categories = <Category, List<Product>>{}
            ..addAll(state.categories);
          categories[cat] = prods;
          emit(state.copyWith(categories: categories));
        });
      }

      emit(state.copyWith(categories: categories));
    });
  }

  void updateProductAvailability(
    Category category,
    Product product,
    bool availability,
  ) {
    _orderRepository.updateProductAvailability(
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
    _orderRepository.updateProductAvailabilityESIEE(
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
    _orderRepository.updateProductOneOrder(
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
    _orderRepository.updateProductMaxAmount(category, productId, maxAmount);
  }

  void removeProduct(Category category, String productId) {
    _orderRepository.removeProduct(category, productId);
  }

  void updateProductName(Category category, String productId, String name) {
    _orderRepository.updateProductName(category, productId, name);
  }

  Future<void> addCategoryDialog(BuildContext context) {
    var controller = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter une catégorie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Quel nom voulez vous donner à votre catégorie ?'),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Nom'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _orderRepository.addCategory(Category(name: controller.text));
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
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
          title: const Text('Ajouter une un produit'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Vous vous apprêtez à ajouter un produit dans la catégorie ${category.name}',
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Quel nom voulez-vous donner à votre produit ?'),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Nom'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _orderRepository.addProduct(
                  category,
                  Product.empty.copyWith(name: controller.text),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> editCategoryDialog(BuildContext context, Category category) {
    var controller = TextEditingController(text: category.name);

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier une catégorie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Quel nom voulez vous donner à votre catégorie ?'),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Nom'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _orderRepository.updateCategory(category.copyWith(
                  name: controller.text,
                ));
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
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
          title: const Text('Supprimer une catégorie'),
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
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                _orderRepository.deleteCategory(category);
                Navigator.of(context).pop();
              },
              child: const Text('Confirmer'),
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
              title: const Text('Supprimer un produit'),
              content: const SingleChildScrollView(
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
                  child: const Text(
                    'Annuler',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _orderRepository.removeProduct(category, productId);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Confirmer'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void changeOrderPagesView(bool view) {
    _settingRepository.changeOrderPagesView(view);
  }
}
