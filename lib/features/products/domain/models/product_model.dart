const defaultImageUrl = "https://lh3.googleusercontent.com/8uLsW5MRqfvFIpoVhchpQN6CuMdj0hXZV7dOplezAJ6j6RSdymfMCNstJMhs_G8QNZaNwh60gAhFrjYfZr2wG4JmnKfwGDw=rw-w500";
class Product {

    String name;
    double price;
    String imageSrc;

    Product({
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
        "imageSrc": imageSrc.isEmpty ? defaultImageUrl : imageSrc,
    };

    factory Product.empty() => Product(
        name: "",
        price: 0,
        imageSrc: "",
    );
}