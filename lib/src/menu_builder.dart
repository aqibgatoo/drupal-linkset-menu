import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'linkset.dart';

const HTTP_ACCEPTED = 200;

class Menu {
  String? id;
  List<MenuElement>? tree;

  get title => id;

  @override
  String toString() {
    return 'Menu{id: $id, tree: $tree}';
  }

  Menu.fromLinkset(String id, ContextObject linkset) {
    this.id = id;
    this.tree = buildElementTree(linkset.item);
  }
}

class MenuElement {
  String? title;
  String? href;
  List<MenuElement>? children;

  MenuElement.fromLinks(TargetObject link, List<TargetObject> childLinks) {
    title = link.title;
    href = link.href;
    children = buildElementTree(childLinks);
  }

  MenuElement(this.title, this.href, this.children);

  @override
  String toString() {
    return 'MenuElement{title: $title, href: $href, children: $children}';
  }
}

List<MenuElement> buildElementTree(List<TargetObject> links) {
  if (links.length < 2) {
    if (links.length == 1) {
      TargetObject link = links.removeAt(0);
      return [MenuElement(link.title, link.href, [])];
    } else {
      return [];
    }
  }
  var menuElements = <MenuElement>[];
  TargetObject? lastLink;
  var childLinks = <TargetObject>[];
  do {
    var currentLink = links.removeAt(0);
    if (lastLink != null) {
      if (currentLink.drupalMenuHierarchy!.length >
          lastLink.drupalMenuHierarchy!.length) {
        childLinks.add(currentLink);
      } else {
        menuElements.add(MenuElement.fromLinks(lastLink, childLinks));
        lastLink = currentLink;
        childLinks = [];
      }
    } else {
      lastLink = currentLink;
    }
  } while (links.length != 0);
  menuElements.add(MenuElement.fromLinks(lastLink, childLinks));
  return menuElements;
}

/// Returns [Menu] with [id] & optional [targetObjectJsonPropertyName] from given [decodedJson]
/// The default [targetObjectJsonPropertyName] is 'item' in drupal menu linkset json
Future<Menu> getDrupalMenuFromJSON(String id, String json,
    [String targetObjectJsonPropertyName = 'item']) {
  var linksetInterface =
      LinksetInterface.fromJson(jsonDecode(json), targetObjectJsonPropertyName);
  return Future<Menu>.value(Menu.fromLinkset(
      id, linksetInterface.linkset.firstWhere((co) => co.anchor.contains(id))));
}

/// Returns [Menu] with [id] & optional [targetObjectJsonPropertyName] by fetching the linkset json from given  [apiUrl]
/// The default [targetObjectJsonPropertyName] is 'item' in drupal menu linkset json
Future<Menu> getDrupalMenuFromURL(String apiUrl, String id,
    [String targetObjectJsonPropertyName = 'item']) {
  var completer = Completer<Menu>();
  var url = Uri.parse(apiUrl);
  http.get(url).then((value) => completer.complete(getDrupalMenuFromJSON(
      id, value.body, targetObjectJsonPropertyName)));
  return completer.future;
}
