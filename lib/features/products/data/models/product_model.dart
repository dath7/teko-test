import 'package:equatable/equatable.dart';

const defaultImageUrl = "https://lh3.googleusercontent.com/8uLsW5MRqfvFIpoVhchpQN6CuMdj0hXZV7dOplezAJ6j6RSdymfMCNstJMhs_G8QNZaNwh60gAhFrjYfZr2wG4JmnKfwGDw=rw-w500";
class Product extends Equatable{
    final String name;
    final double price;
    final String imageSrc;

    const Product({
        required this.name,
        required this.price,
        required this.imageSrc,
    });

    factory Product.fromJson(Map json) => Product(
        name: json["name"],
        price: json["price"]?.toDouble(),
        imageSrc: json["imageSrc"],
    );

    Map toJson() => {
        "name": name,
        "price": price,
        "imageSrc": imageSrc,
    };

    static final empty = Product(
        name: "",
        price: 0,
        imageSrc: defaultImageUrl,
    );

    Product copyWith({
        String? name,
        double? price,
        String? imageSrc,
    }) {
        return Product(
            name: name ?? this.name,
            price: price ?? this.price,
            imageSrc: imageSrc ?? this.imageSrc,
        );
    }

    @override
    List<Object?> get props => [name, price, imageSrc];
}