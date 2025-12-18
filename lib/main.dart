import 'package:ovchiadmin/providers/admin_web_panel_provider.dart';
import 'package:ovchiadmin/views/categories/categories_page.dart';
import 'package:ovchiadmin/views/dashboard_page.dart';
import 'package:ovchiadmin/views/orders/order_details_page.dart';
import 'package:ovchiadmin/views/orders/orders_page.dart';
import 'package:ovchiadmin/views/products/products_page.dart';
import 'package:ovchiadmin/views/products/update_products_page.dart';
import 'package:ovchiadmin/views/promoBanner/update_promo_banner_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/coupons/coupons_page.dart';
import 'views/promoBanner/promos_banners_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCQw7Y-lgFRpBMYMz7Wf96pDtAljY6gi_Q",
      authDomain: "sohibjonovchi.firebaseapp.com",
      projectId: "sohibjonovchi",
      storageBucket: "sohibjonovchi.firebasestorage.app",
      messagingSenderId: "392837445294",
      appId: "1:392837445294:web:67ba2b98740acc451f1f3f",
      measurementId: "G-282CY1SY5Q",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminWebPanelProvider(),
      child: MaterialApp(
        title: 'Admin WEB Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: {
          "/": (context) => DashboardPage(),
          "/promos_banners": (context) => PromosBannersPage(),
          "/update_promo_banner": (context) => const UpdatePromoBannerPage(),
          "/category": (context) => const CategoriesPage(),
          "/products": (context) => const ProductsPage(),
          "/update_product": (context) => const UpdateProductsPage(),
          "/coupons": (context) => const CouponsPage(),
          "/orders": (context) => const OrdersPage(),
          "/order_details": (context) => const OrderDetailsPage(),
        },
      ),
    );
  }
}
