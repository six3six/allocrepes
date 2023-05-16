import 'package:allocrepes/allo/oder_new/cubit/order_new_cubit.dart';
import 'package:allocrepes/allo/oder_new/cubit/order_new_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/models/category.dart';
import 'package:order_repository/models/place.dart';
import 'package:order_repository/models/product.dart';

class OrderNewView extends StatelessWidget {
  const OrderNewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle commandes'),
      ),
      body: ListView(
        children: [
          _OrderNewAddressInfo(),
          const SizedBox(height: 10),
          _OrderNewCategories(),
          const SizedBox(height: 10),
          _AdditionalInformation(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<OrderNewCubit>(context)
                      .checkout(context)
                      .then((ok) {
                    if (ok) {
                      Navigator.pop(context);
                    }
                  });
                },
                child: const Text('Commander'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderNewCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<OrderNewCubit, OrderNewState>(
          buildWhen: (prev, next) =>
              !const IterableEquality().equals(
                prev.categories.keys,
                next.categories.keys,
              ) ||
              !const IterableEquality().equals(
                prev.categories.values,
                next.categories.values,
              ) ||
              prev.place != next.place,
          builder: (context, state) {
            var categories = <_OrderNewCategory>[];
            state.categories.forEach(
              (Category cat, List<Product> products) => categories.add(
                _OrderNewCategory(
                  category: cat,
                  products: state.place == Place.ESIEE
                      ? BlocProvider.of<OrderNewCubit>(context)
                          .getAvailableESIEEProduct(cat)
                      : BlocProvider.of<OrderNewCubit>(context)
                          .getAvailableProduct(cat),
                ),
              ),
            );

            return Column(
              children: categories,
            );
          },
        ),
      ],
    );
  }
}

class _OrderNewCategory extends StatelessWidget {
  final Category category;
  final List<Product> products;

  const _OrderNewCategory({
    Key? key,
    required this.category,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (products.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20)
              .add(const EdgeInsets.only(top: 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: textTheme.headlineSmall,
              ),
              Column(
                children: products
                    .map<_OrderNewItem>(
                      (product) => _OrderNewItem(
                        category: category,
                        product: product,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _OrderNewItem extends StatelessWidget {
  final Category category;
  final Product product;

  const _OrderNewItem({Key? key, required this.category, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<OrderNewCubit, OrderNewState>(
            buildWhen: (prev, next) =>
                prev.isAlreadyOrdered(category, product) !=
                next.isAlreadyOrdered(category, product),
            builder: (context, state) => Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    product.name,
                    style: state.isAlreadyOrdered(category, product)
                        ? textTheme.titleLarge?.merge(const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ))
                        : textTheme.titleLarge,
                  ),
                ),
                if (!state.isAlreadyOrdered(category, product)) nbSelector(),
              ],
            ),
          ),
          if (!product.availableESIEE)
            Text(
              "Ce produit n'est pas disponible à l'ESIEE",
              style: textTheme.bodySmall,
            ),
          if (!product.available)
            Text(
              "Ce produit n'est pas disponible en résidence",
              style: textTheme.bodySmall,
            ),
          if (product.oneOrder)
            Text(
              "Ce produit n'est commandable qu'une fois",
              style: textTheme.bodySmall,
            ),
        ],
      ),
    );
  }

  Widget nbSelector() => BlocBuilder<OrderNewCubit, OrderNewState>(
        buildWhen: (prev, next) =>
            prev.getQuantity(category, product) !=
            next.getQuantity(category, product),
        builder: (context, state) => DropdownButton<int>(
          value: BlocProvider.of<OrderNewCubit>(context)
              .getQuantity(category, product),
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          iconSize: 24,
          elevation: 16,
          onChanged: (int? val) => BlocProvider.of<OrderNewCubit>(context)
              .updateQuantity(category, product, val ?? 0),
          items: List<int>.generate(
            product.maxAmount + 1,
            (index) => index,
          ).map<DropdownMenuItem<int>>((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text(' $value '),
            );
          }).toList(),
        ),
      );
}

class _OrderNewAddressInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<OrderNewCubit, OrderNewState>(
            buildWhen: (prev, next) => prev.placeError != next.placeError,
            builder: (context, state) => Text(
              state.placeError,
              style: theme.textTheme.bodyMedium!
                  .merge(const TextStyle(color: Colors.red)),
            ),
          ),
          BlocBuilder<OrderNewCubit, OrderNewState>(
            buildWhen: (prev, next) => prev.roomError != next.roomError,
            builder: (context, state) => Text(
              state.roomError,
              style: theme.textTheme.bodyMedium!
                  .merge(const TextStyle(color: Colors.red)),
            ),
          ),
          _OrderNewBatimentSelector(),
          BlocBuilder<OrderNewCubit, OrderNewState>(
            builder: (context, state) {
              return state.place == Place.ESIEE
                  ? const Text('Rendez-vous au stand extérieur')
                  : _OrderNewAppartSelector();
            },
          ),
        ],
      ),
    );
  }
}

class _OrderNewBatimentSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Batiment : ',
          style: theme.textTheme.bodySmall,
        ),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: BlocBuilder<OrderNewCubit, OrderNewState>(
            buildWhen: (prev, next) => prev.place != next.place,
            builder: (context, state) => DropdownButton<Place>(
              value: state.place ?? Place.values[1],
              onChanged: (Place? place) =>
                  BlocProvider.of<OrderNewCubit>(context).updatePlace(place),
              items: Place.values
                  .sublist(1)
                  .map<DropdownMenuItem<Place>>((Place place) {
                return DropdownMenuItem<Place>(
                  value: place,
                  child: Text(PlaceUtils.placeToString(place)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdditionalInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AdditionalInformationState();
}

class _AdditionalInformationState extends State<_AdditionalInformation> {
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    _phoneController.text = BlocProvider.of<OrderNewCubit>(context).state.phone;
    _messageController.text =
        BlocProvider.of<OrderNewCubit>(context).state.message;

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Numéro de tél (facultatif) :'),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            onChanged: (phone) =>
                BlocProvider.of<OrderNewCubit>(context).updatePhone(phone),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text('Commentaire :'),
          Text(
            '(un anniversaire, un message à nous passer...)',
            style: theme.textTheme.bodySmall,
          ),
          TextField(
            controller: _messageController,
            maxLines: 5,
            onChanged: (message) =>
                BlocProvider.of<OrderNewCubit>(context).updateMessage(message),
          ),
        ],
      ),
    );
  }
}

class _OrderNewAppartSelector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderNewAppartSelectorState();
}

class _OrderNewAppartSelectorState extends State<_OrderNewAppartSelector> {
  final TextEditingController _roomController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roomController.text =
        BlocProvider.of<OrderNewCubit>(context).state.room ?? '';
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _roomController,
      onChanged: (val) =>
          BlocProvider.of<OrderNewCubit>(context).updateRoom(val),
      autocorrect: false,
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      maxLength: 4,
      decoration: const InputDecoration(
        labelText: 'Appart/Salle n°',
        helperText: '',
      ),
    );
  }
}
