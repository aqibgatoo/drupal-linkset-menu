/// The [LinksetInterface] [ContextObject] and [TargetObject]
/// are defined under the spec here
/// https://tools.ietf.org/html/draft-ietf-httpapi-linkset-00#section-1
///
/// Internationalized Target Attribute
class InternationalizedValue {
  String? value;
  String? language;

  InternationalizedValue({this.value, this.language});

  InternationalizedValue.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    language = json['language'];
  }

  @override
  String toString() {
    return 'InternationalizedValue{value: $value, language: $language}';
  }
}

/// Web linking Target Attributes
abstract class TargetAttributes {
  late String href;
  String? title;
  String? media;
  String? type;
  List<String>? hreflang;
  List<InternationalizedValue>? titleStar;
}

/// Drupal Extension Target Attributes
abstract class DrupalAttributes {
  String? drupalMenuHierarchy;
  String? drupalMenuMachineName;
}

/// [TargetObject] represents a link target
class TargetObject implements TargetAttributes, DrupalAttributes {
  @override
  String? drupalMenuHierarchy;
  @override
  String? drupalMenuMachineName;
  @override
  late String href;
  @override
  List<String>? hreflang;
  @override
  String? media;
  @override
  String? title;
  @override
  List<InternationalizedValue>? titleStar;
  @override
  String? type;

  TargetObject.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    title = json['title'];
    media = json['media'];
    type = json['type'];
    hreflang =
        List<String>.from(json['hreflang']?.map((s) => s.toString()) ?? []);
    drupalMenuHierarchy =
        json['drupal-menu-hierarchy']?.map((s) => s)?.toList()?.join('');
    drupalMenuMachineName =
        json['drupal-menu-machine-name']?.map((s) => s)?.toList()?.join('');
    if (json['title*'] != null) {
      titleStar = <InternationalizedValue>[];
      json['title*'].forEach((v) {
        titleStar!.add(InternationalizedValue.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'TargetObject{drupalMenuHierarchy: $drupalMenuHierarchy, drupalMenuMachineName: $drupalMenuMachineName, href: $href, hreflang: $hreflang, media: $media, title: $title, titleStar: $titleStar, type: $type}';
  }
}

/// [ContextObject] represents links that have the same link context
class ContextObject {
  late String anchor;
  late List<TargetObject> item;

  ContextObject.fromJson(Map<String, dynamic> json,String targetObjectJsonPropertyName) {
    anchor = json['anchor'];
    if (json[targetObjectJsonPropertyName] != null) {
      item = <TargetObject>[];
      json[targetObjectJsonPropertyName].forEach((v) {
        item.add(TargetObject.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'ContextObject{anchor: $anchor, item: $item}';
  }
}

/// [LinksetInterface] represents a set of links
class LinksetInterface {
  late List<ContextObject> linkset;

  LinksetInterface.fromJson(Map<String, dynamic> json,String targetObjectJsonPropertyName) {
    if (json['linkset'] != null) {
      linkset = <ContextObject>[];
      json['linkset'].forEach((v) {
        linkset.add(ContextObject.fromJson(v,targetObjectJsonPropertyName));
      });
    }
  }

  @override
  String toString() {
    return 'LinksetInterface{linkset: $linkset}';
  }
}
