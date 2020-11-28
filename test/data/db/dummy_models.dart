import 'package:moor_flutter/moor_flutter.dart';
import 'package:perminda/data/db/app_database/app_database.dart';

class DummyModels {
  static final brand1 = BrandTableCompanion(
    id: Value('1'),
    logo: Value('ex.com'),
    name: Value('Samsung'),
  );
  static final brand2 = BrandTableCompanion(
    id: Value('2'),
    logo: Value('ex.com'),
    name: Value('IOS'),
  );
  static final user1 = UserTableCompanion(
    id: Value('1'),
    firstName: Value('Hasan'),
    lastName: Value('AlQaisi'),
    username: Value('hasan'),
    email: Value('hasan@gmail.com'),
    phoneNumber: Value('+964-hasan'),
    address: Value('Baghdad - Iraq'),
    image: Value('example.com'),
    dateJoined: Value(DateTime.parse('2020-10-10')),
    lastLogin: Value(DateTime.parse('2020-10-10')),
  );
  static final user2 = UserTableCompanion(
    id: Value('2'),
    firstName: Value('rami'),
    lastName: Value('rami'),
    username: Value('rami'),
    email: Value('rami@gmail.com'),
    phoneNumber: Value('+964-rami'),
    address: Value('Baghdad - Iraq'),
    image: Value('example.com'),
    dateJoined: Value(DateTime.parse('2020-10-10')),
    lastLogin: Value(DateTime.parse('2020-10-10')),
  );
  static final user1Notification1 = UserNotificationTableCompanion(
    id: Value('1'),
    user: Value('1'),
    message: Value('notifcation one for user one'),
    read: Value(true),
    dateSent: Value(DateTime.parse('2020-10-10')),
  );
  static final user1Notification2 = UserNotificationTableCompanion(
    id: Value('2'),
    user: Value('1'),
    message: Value('notifcation two for user one'),
    read: Value(false),
    dateSent: Value(DateTime.parse('2020-10-10')),
  );
  static final user2Notification1 = UserNotificationTableCompanion(
    id: Value('3'),
    user: Value('2'),
    message: Value('notifcation one for user two'),
    read: Value(false),
    dateSent: Value(DateTime.parse('2020-10-10')),
  );
  static final user2Notification2 = UserNotificationTableCompanion(
    id: Value('4'),
    user: Value('2'),
    message: Value('notifcation two for user two'),
    read: Value(true),
    dateSent: Value(DateTime.parse('2020-10-10')),
  );
  static final shop1 = ShopTableCompanion(
    id: Value('1'),
    user: Value('1'),
    name: Value('hasanShop'),
    dateCreated: Value(DateTime.parse('2020-10-10')),
  );
  static final shop2 = ShopTableCompanion(
    id: Value('2'),
    user: Value('1'),
    name: Value('ramiShop'),
    dateCreated: Value(DateTime.parse('2020-10-10')),
  );
  static final category1 = CategoryTableCompanion(
    id: Value('1'),
    name: Value('electronics'),
  );
  static final category2 = CategoryTableCompanion(
    id: Value('2'),
    parent: Value('1'),
    name: Value('Mobile'),
  );
  static final category3 = CategoryTableCompanion(
    id: Value('3'),
    name: Value('Mobile'),
  );
  static final product1 = ProductTableCompanion(
    id: Value('1'),
    shop: Value('1'),
    category: Value('1'),
    brand: Value('1'),
    name: Value('galaxy S10'),
    price: Value(100),
    sale: Value(0),
    overview: Value('this is a mobile'),
    deliveryTime: Value(DateTime.parse('2020-10-10')),
    rate: Value(4.3),
    buyers: Value(0),
    numReviews: Value(0),
    active: Value(true),
    quantity: Value(500),
    dateAdded: Value(DateTime.parse('2020-10-10')),
    dateFirstActive: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
  static final product2 = ProductTableCompanion(
    id: Value('2'),
    shop: Value('1'),
    category: Value('2'),
    name: Value('ihpone'),
    price: Value(100),
    sale: Value(0),
    overview: Value('this is an ihpone'),
    deliveryTime: Value(DateTime.parse('2020-10-10')),
    rate: Value(4.3),
    buyers: Value(0),
    numReviews: Value(0),
    active: Value(true),
    quantity: Value(500),
    dateAdded: Value(DateTime.parse('2020-10-10')),
    dateFirstActive: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
  static final product3 = ProductTableCompanion(
    id: Value('3'),
    shop: Value('2'),
    category: Value('1'),
    brand: Value('1'),
    name: Value('ihpone'),
    price: Value(100),
    sale: Value(0),
    overview: Value('this is an ihpone'),
    deliveryTime: Value(DateTime.parse('2020-10-10')),
    rate: Value(4.3),
    buyers: Value(0),
    numReviews: Value(0),
    active: Value(true),
    quantity: Value(500),
    dateAdded: Value(DateTime.parse('2020-10-10')),
    dateFirstActive: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
  static final order1 = OrderTableCompanion(
    id: Value('1'),
    user: Value('1'),
    address: Value('Baghdad'),
    productCosts: Value(201.1),
    shippingFee: Value(3),
    stage: Value(0),
    dateSent: Value(DateTime.parse('2020-10-10')),
    datePrepared: Value(DateTime.parse('2020-10-10')),
    lastShipped: Value(DateTime.parse('2020-10-10')),
    lastRecieved: Value(DateTime.parse('2020-10-10')),
  );
  static final order2 = OrderTableCompanion(
    id: Value('2'),
    user: Value('1'),
    address: Value('Baghdad'),
    productCosts: Value(201.1),
    shippingFee: Value(3),
    stage: Value(0),
    dateSent: Value(DateTime.parse('2020-10-10')),
    datePrepared: Value(DateTime.parse('2020-10-10')),
    lastShipped: Value(DateTime.parse('2020-10-10')),
    lastRecieved: Value(DateTime.parse('2020-10-10')),
  );
  static final order3 = OrderTableCompanion(
    id: Value('3'),
    user: Value('2'),
    address: Value('Baghdad'),
    productCosts: Value(201.1),
    shippingFee: Value(3),
    stage: Value(0),
    dateSent: Value(DateTime.parse('2020-10-10')),
    datePrepared: Value(DateTime.parse('2020-10-10')),
    lastShipped: Value(DateTime.parse('2020-10-10')),
    lastRecieved: Value(DateTime.parse('2020-10-10')),
  );
  static final package1 = PackageTableCompanion(
    id: Value('1'),
    title: Value('A package'),
    image: Value('oisjdio.com'),
    active: Value(true),
    dateCreated: Value(DateTime.parse('2020-10-10')),
  );
  static final package2 = PackageTableCompanion(
    id: Value('2'),
    title: Value('A package'),
    image: Value('oisjdio.com'),
    active: Value(true),
    dateCreated: Value(DateTime.parse('2020-10-10')),
  );
  static final package3 = PackageTableCompanion(
    id: Value('3'),
    title: Value('A package'),
    image: Value('oisjdio.com'),
    active: Value(true),
    dateCreated: Value(DateTime.parse('2020-10-10')),
  );
  static final product1Images = [
    ProductImageTableCompanion(
      id: Value('1'),
      image: Value('url.com'),
      product: Value('1'),
      type: Value(0),
    ),
    ProductImageTableCompanion(
      id: Value('2'),
      image: Value('url.com'),
      product: Value('1'),
      type: Value(0),
    ),
  ];
  static final product2Images = [
    ProductImageTableCompanion(
      id: Value('3'),
      image: Value('url.com'),
      product: Value('2'),
      type: Value(0),
    ),
    ProductImageTableCompanion(
      id: Value('4'),
      image: Value('url.com'),
      product: Value('2'),
      type: Value(0),
    ),
  ];
  static final review1Product1User1 = ReviewTableCompanion(
    id: Value('1'),
    user: Value('1'),
    product: Value('1'),
    rate: Value(4),
    message: Value('good'),
    dateWrote: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
  static final review2Product1User2 = ReviewTableCompanion(
    id: Value('2'),
    user: Value('2'),
    product: Value('1'),
    rate: Value(5),
    message: Value('Perfect'),
    dateWrote: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
  static final review3Product2User1 = ReviewTableCompanion(
    id: Value('3'),
    user: Value('1'),
    product: Value('2'),
    rate: Value(1),
    message: Value('Bad'),
    dateWrote: Value(DateTime.parse('2020-10-10')),
    lastUpdate: Value(DateTime.parse('2020-10-10')),
  );
}
