# drupal_menu

A Flutter package that parses application/linkset+json mimetype and generates a Menu Object. (Primarily intended to be used for Drupal Decoupled Menus Module)

## Using

The easiest way to use this library is via the provided functions

With an ApiUrl
```dart
import 'package:drupal_linkset_menu/drupal_linkset_menu.dart';
String menu = "main";
String apiURL = 'http://localhost:50915/system/menu/${menu}/linkset';
Menu menu = await getDrupalMenuFromURL(apiURL, menu);
```

With a JSON string
```dart
import 'package:drupal_linkset_menu/drupal_linkset_menu.dart';
String menu = "footer";
String json = '{"linkset":[{"anchor":"\/system\/menu\/footer\/linkset","item":[{"href":"\/contact","title":"Contact","drupal-menu-hierarchy":[".000"],"drupal-menu-machine-name":["footer"]}]}]}';
Menu menu = await getDrupalMenuFromJSON(menu, json);
```
