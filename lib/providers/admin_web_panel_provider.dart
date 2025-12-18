import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ovchiadmin/view_model/category_view_model.dart';
import 'package:ovchiadmin/view_model/order_view_model.dart';
import 'package:ovchiadmin/view_model/product_view_model.dart';
import 'package:flutter/cupertino.dart';

class AdminWebPanelProvider extends ChangeNotifier {
  List<QueryDocumentSnapshot> categoriesList = [];
  StreamSubscription<QuerySnapshot>? categoryStreamSubscription;
  CategoryViewModel categoryViewModel = CategoryViewModel();

  List<QueryDocumentSnapshot> productsList = [];
  StreamSubscription<QuerySnapshot>? productsStreamSubscription;
  ProductViewModel productViewModel = ProductViewModel();

  List<QueryDocumentSnapshot> ordersList = [];
  StreamSubscription<QuerySnapshot>? ordersStreamSubscription;
  OrderViewModel orderViewModel = OrderViewModel();

  int totalCategoriesNum = 0;
  int totalProductsNum = 0;
  int totalOrdersNum = 0;
  int ordersDeliveredNum = 0;
  int ordersCancelledNum = 0;
  int ordersOnTheWayNum = 0;
  int orderPendingProcessNum = 0;

  AdminWebPanelProvider() {
    getCategories();
    getProducts();
    getOrders();
  }

  getOrders() {
    ordersStreamSubscription?.cancel();

    ordersStreamSubscription = orderViewModel.fetchOrders().listen((snapshot) {
      ordersList = snapshot.docs;
      totalOrdersNum = snapshot.docs.length;

      getOrderStatusNum();

      notifyListeners();
    });
  }

  getOrderStatusNum() {
    ordersOnTheWayNum = 0;
    orderPendingProcessNum = 0;
    ordersDeliveredNum = 0;
    ordersCancelledNum = 0;

    for (int i = 0; i < ordersList.length; i++) {
      if (ordersList[i]["status"] == "DELIVERED") {
        ordersDeliveredNum++;
      } else if (ordersList[i]["status"] == "CANCELLED") {
        ordersCancelledNum++;
      } else if (ordersList[i]["status"] == "ON_THE_WAY") {
        ordersOnTheWayNum++;
      } else {
        orderPendingProcessNum++;
      }
    }

    notifyListeners();
  }

  getProducts() {
    productsStreamSubscription?.cancel();
    productsStreamSubscription = productViewModel.fetchProducts().listen((
      snapshot,
    ) {
      productsList = snapshot.docs;
      totalProductsNum = snapshot.docs.length;
      notifyListeners();
    });
  }

  getCategories() {
    categoryStreamSubscription?.cancel();

    categoryStreamSubscription = categoryViewModel.fetchCategories().listen((
      snapshot,
    ) {
      categoriesList = snapshot.docs;
      totalCategoriesNum = snapshot.docs.length;
      notifyListeners();
    });
  }
}
