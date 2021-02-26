import 'package:allocrepes/products/cubit/products_state.dart';
import 'package:bloc/bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/product.dart';
import 'package:order_repository/order_repository.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._orderRepository) : super(const ProductsState()) {
    listProducts();
  }

  final OrderRepository _orderRepository;

  void listProducts() {
    _orderRepository
        .productByCategory()
        .listen((Map<Category, Stream<List<Product>>> productStreams) {
      Map<Category, List<Product>> prod =
          productStreams.map((key, value) => MapEntry(key, []));
      emit(ProductsState(products: prod));

      productStreams.map((key, value) {
        value.listen((event) {
          Map<Category, List<Product>> prod =
              new Map<Category, List<Product>>.from(state.products);
          prod[key] = event;
          emit(ProductsState(products: prod));
        });

        return MapEntry("", "");
      });
    });
  }

  void addCategory(String name) {
    _orderRepository.addCategory(Category(id: "", name: name));
  }

  void changeAvailability(Category category, Product product, bool available) {
    _orderRepository.updateProductAvailability(category, product, available);
  }

  void addProduct(Category category, String name) {
    _orderRepository.addProduct(
      category,
      Product(
        id: "",
        name: name,
        available: true,
      ),
    );
  }
}
