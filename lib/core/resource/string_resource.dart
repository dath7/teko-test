class StringResources{
  StringResources._internal();
  
  static final StringResources _instance = StringResources._internal();
  factory StringResources() => _instance;

  final String productManagement  = "Quản lý sản phẩm";
  final String productName  = "Tên sản phẩm";
  final String productPrice  = "Giá sản phẩm";
  final String productImage  = "Ảnh sản phẩm";
  final String selectFile = "Chọn tập tin (tối đa 5MB)";
  final String createProduct = "Tạo sản phẩm";
  final String addProduct  = "Thêm sản phẩm";
  final String addedProductSuccessfully  = "Thêm sản phẩm thành công";
  final String loadingError = "Lỗi khi tải dữ liệu";
  final String fieldNotValidError = "Các trường nhập vào chưa đúng định dạng";
  final String pleaseEnterName = "Vui lòng nhập tên sản phẩm";
  final String productNameNotValid = "Tên sản phẩm có tối đa 20 ký tự";
  final String pleaseEnterPrice = "Vui lòng nhập giá sản phẩm";
  final String priceNotValid = "Giá sản phẩm phải trong khoảng 10.000 - 100.000.000";
}
