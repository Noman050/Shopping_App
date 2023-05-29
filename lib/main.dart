import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/splash_screen.dart';
import 'package:shopit/screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/auth.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen..dart';
import './screens/auth_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(null, [], null),
            update: (ctx, auth, previusProducts) => Products(
              auth.token,
              previusProducts == null ? [] : previusProducts.items,
              auth.userId,
            ),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(null, [], null),
            update: (ctx, auth, previusOrder) => Orders(auth.token,
                previusOrder == null ? [] : previusOrder.orders, auth.userId),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ShopIt!',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTrasitionBuilder(),
                TargetPlatform.iOS: CustomPageTrasitionBuilder(),
              }),
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
