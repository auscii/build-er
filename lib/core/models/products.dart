// import 'package:equatable/equatable.dart';
// import 'package:food_cart/food_cart.dart';
import '../providers/item_models.dart';

class ProductModel extends ItemModel { //with EquatableMixin {
    // Create all the fields of the class 
    // that you need for your specific case.
  final String name;
  final String urlPhoto;
  String specialInstruction;

  ProductModel({
    required this.name,
    required this.urlPhoto,
    this.specialInstruction = '',

    // this field come from ItemModel class
    required super.id, 

    // This field come from ItemModel class
    required super.price,

    // This field come from ItemModel class
    super.quantity = 1,
  });
  

  // This line of code comes from equatable package, 
  // and it is required! In square brackets pass all fields
  // from your model, but don't pass 'id', 'price' and 'quantity'!!!
  @override
  List<Object?> get props => [ name, urlPhoto, specialInstruction]; 
}