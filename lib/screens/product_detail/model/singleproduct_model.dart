// ignore_for_file: prefer_typing_uninitialized_variables

class SingleProductModel {
  int? status;
  Data? data;

  SingleProductModel({this.status, this.data});

  SingleProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? id;
  String? titleEn;
  String? titleAr;
  String? descriptionEn;
  String? descriptionAr;
  int? appearance;
  int? featured;
  int? newarrive;
  var price;
  int? hasOffer;
  var beforePrice;
  String? img;
  int? bestSelling;
  int? basicCategoryId;
  int? categoryId;
  Category? category;
  List<Images>? images;
  List<Sizes>? sizes;

  Data(
      {this.id,
      this.titleEn,
      this.titleAr,
      this.descriptionEn,
      this.descriptionAr,
      this.appearance,
      this.featured,
      this.newarrive,
      this.price,
      this.hasOffer,
      this.beforePrice,
      this.img,
      this.bestSelling,
      this.basicCategoryId,
      this.categoryId,
      this.category,
      this.images,
      this.sizes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titleEn = json['title_en'];
    titleAr = json['title_ar'];
    descriptionEn = json['description_en'];
    descriptionAr = json['description_ar'];
    appearance = json['appearance'];
    featured = json['featured'];
    newarrive = json['new'];
    price = json['price'];
    hasOffer = json['has_offer'];
    beforePrice = json['before_price'];
    img = json['img'];
    bestSelling = json['best_selling'];
    basicCategoryId = json['basic_category_id'];
    categoryId = json['category_id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    if (json['sizes'] != null) {
      sizes = <Sizes>[];
      json['sizes'].forEach((v) {
        sizes!.add(Sizes.fromJson(v));
      });
    }
  }
}

class Category {
  int? id;
  String? nameAr;
  String? nameEn;
  int? basicCategoryId;

  Category({
    this.id,
    this.nameAr,
    this.nameEn,
    this.basicCategoryId,
  });

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAr = json['name_ar'];
    nameEn = json['name_en'];
    basicCategoryId = json['basic_category_id'];
  }
}

class Images {
  int? id;
  String? img;
  int? productId;

  Images({this.id, this.img, this.productId});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    img = json['img'];
    productId = json['product_id'];
  }
}

class Sizes {
  int? id;
  String? name;
  Pivot? pivot;

  Sizes({this.id, this.name, this.pivot});

  Sizes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }
}

class Pivot {
  int? productId;
  int? sizeId;
  int? id;

  Pivot({this.productId, this.sizeId, this.id});

  Pivot.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    sizeId = json['size_id'];
    id = json['id'];
  }
}
