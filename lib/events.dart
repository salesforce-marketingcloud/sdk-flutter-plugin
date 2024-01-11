// events.dart
//
// Copyright (c) 2024 Salesforce, Inc
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer. Redistributions in binary
// form must reproduce the above copyright notice, this list of conditions and
// the following disclaimer in the documentation and/or other materials
// provided with the distribution. Neither the name of the nor the names of
// its contributors may be used to endorse or promote products derived from
// this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

enum EventCategory { engagement, identity, system }

extension EventCategoryExtension on EventCategory {
  String get name {
    switch (this) {
      case EventCategory.engagement:
        return 'engagement';
      case EventCategory.identity:
        return 'identity';
      case EventCategory.system:
        return 'system';
      default:
        return '';
    }
  }
}

class CustomEvent {
  final String name;
  final Map<String, dynamic>? attributes;
  final EventCategory category;
  String _objType;

  CustomEvent(this.name,
      {this.attributes, this.category = EventCategory.engagement})
      : _objType = 'CustomEvent';

  Map<String, dynamic> toJson() {
    return {
      "category": category.name,
      "name": name,
      "attributes": attributes,
      "objType": _objType
    };
  }
}

class EngagementEvent extends CustomEvent {
  EngagementEvent(String name, {Map<String, dynamic>? attributes})
      : super(name,
            attributes: attributes, category: EventCategory.engagement) {
    _objType = 'EngagementEvent';
  }
}

class SystemEvent extends CustomEvent {
  SystemEvent(String name, {Map<String, dynamic>? attributes})
      : super(name, attributes: attributes, category: EventCategory.system) {
    _objType = 'SystemEvent';
  }
}

class IdentityEvent extends CustomEvent {
  Map<String, dynamic>? profileAttributes;
  String? profileId;

  IdentityEvent._(Map<String, dynamic>? attributes)
      : super('IdentityEvent',
            attributes: attributes, category: EventCategory.identity) {
    _objType = 'IdentityEvent';
  }

  IdentityEvent.attributes(Map<String, dynamic> attributes)
      : this._(attributes);

  IdentityEvent.profileAttributes(this.profileAttributes)
      : super('IdentityEvent', category: EventCategory.identity) {
    _objType = "IdentityEvent";
  }

  IdentityEvent.profileId(this.profileId)
      : super('IdentityEvent', category: EventCategory.identity) {
    _objType = "IdentityEvent";
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "category": category.name,
      "name": name,
      "attributes": attributes,
      "profileAttributes": profileAttributes,
      "profileId": profileId,
      "objType": _objType
    };
  }
}

enum CartEventType { add, remove, replace }

extension CartEventTypeExtension on CartEventType {
  String get name {
    switch (this) {
      case CartEventType.add:
        return "Add To Cart";
      case CartEventType.remove:
        return "Remove From Cart";
      case CartEventType.replace:
        return "Replace Cart";
      default:
        return "";
    }
  }
}

class CartEvent extends EngagementEvent {
  final List<LineItem> lineItems;

  CartEvent._(String name, this.lineItems) : super(name) {
    _objType = "CartEvent";
  }

  factory CartEvent.addToCart(LineItem lineItem) {
    return CartEvent._(CartEventType.add.name, [lineItem]);
  }

  factory CartEvent.removeFromCart(LineItem lineItem) {
    return CartEvent._(CartEventType.remove.name, [lineItem]);
  }

  factory CartEvent.replaceCart(List<LineItem> lineItems) {
    return CartEvent._(CartEventType.replace.name, lineItems);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "lineItems": lineItems.map((item) => item.toJson()).toList(),
      "attributes": attributes,
      "objType": _objType
    };
  }
}

enum CatalogObjectEventName {
  comment,
  detail,
  favorite,
  share,
  review,
  view,
  quickView
}

extension CatalogObjectEventNameExtension on CatalogObjectEventName {
  String get name {
    switch (this) {
      case CatalogObjectEventName.comment:
        return "Comment Catalog Object";
      case CatalogObjectEventName.detail:
        return "View Catalog Object Detail";
      case CatalogObjectEventName.favorite:
        return "Favorite Catalog Object";
      case CatalogObjectEventName.share:
        return "Share Catalog Object";
      case CatalogObjectEventName.review:
        return "Review Catalog Object";
      case CatalogObjectEventName.view:
        return "View Catalog Object";
      case CatalogObjectEventName.quickView:
        return "Quick View Catalog Object";
      default:
        return "";
    }
  }
}

class CatalogObjectEvent extends EngagementEvent {
  final CatalogObject catalogObject;

  CatalogObjectEvent._(String name, this.catalogObject) : super(name) {
    _objType = "CatalogObjectEvent";
  }

  factory CatalogObjectEvent.commentCatalog(CatalogObject catalogObject) {
    return CatalogObjectEvent._(
        CatalogObjectEventName.comment.name, catalogObject);
  }

  factory CatalogObjectEvent.detailCatalog(CatalogObject catalogObject) {
    return CatalogObjectEvent._(
        CatalogObjectEventName.detail.name, catalogObject);
  }

  factory CatalogObjectEvent.favoriteCatalog(CatalogObject catalogObject) {
    return CatalogObjectEvent._(
        CatalogObjectEventName.favorite.name, catalogObject);
  }

  factory CatalogObjectEvent.shareCatalog(CatalogObject catalogObject) {
    return CatalogObjectEvent._(
        CatalogObjectEventName.share.name, catalogObject);
  }

  factory CatalogObjectEvent.reviewCatalog(CatalogObject catalogObject) {
    return CatalogObjectEvent._(
        CatalogObjectEventName.review.name, catalogObject);
  }

  factory CatalogObjectEvent.viewCatalog(CatalogObject catalogObject) {
    return CatalogObjectEvent._(
        CatalogObjectEventName.view.name, catalogObject);
  }

  factory CatalogObjectEvent.quickViewCatalog(CatalogObject catalogObject) {
    return CatalogObjectEvent._(
        CatalogObjectEventName.quickView.name, catalogObject);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "catalogObject": catalogObject.toJson(),
      "attributes": attributes,
      "objType": _objType
    };
  }
}

enum OrderEventName {
  cancel,
  deliver,
  exchange,
  preorder,
  purchase,
  returnOrder,
  ship
}

extension OrderEventNameExtension on OrderEventName {
  String get name {
    switch (this) {
      case OrderEventName.cancel:
        return "Cancel";
      case OrderEventName.deliver:
        return "Deliver";
      case OrderEventName.exchange:
        return "Exchange";
      case OrderEventName.preorder:
        return "Preorder";
      case OrderEventName.purchase:
        return "Purchase";
      case OrderEventName.returnOrder:
        return "Return";
      case OrderEventName.ship:
        return "Ship";
    }
  }
}

class OrderEvent extends EngagementEvent {
  final Order order;

  OrderEvent._(String name, this.order) : super(name) {
    _objType = "OrderEvent";
  }

  factory OrderEvent.purchase(Order order) {
    return OrderEvent._(OrderEventName.purchase.name, order);
  }

  factory OrderEvent.preorder(Order order) {
    return OrderEvent._(OrderEventName.preorder.name, order);
  }

  factory OrderEvent.cancel(Order order) {
    return OrderEvent._(OrderEventName.cancel.name, order);
  }

  factory OrderEvent.ship(Order order) {
    return OrderEvent._(OrderEventName.ship.name, order);
  }

  factory OrderEvent.deliver(Order order) {
    return OrderEvent._(OrderEventName.deliver.name, order);
  }

  factory OrderEvent.returnOrder(Order order) {
    return OrderEvent._(OrderEventName.returnOrder.name, order);
  }

  factory OrderEvent.exchange(Order order) {
    return OrderEvent._(OrderEventName.exchange.name, order);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "order": order.toJson(),
      "attributes": attributes,
      "objType": _objType
    };
  }
}

class CatalogObject {
  String type;
  String id;
  Map<String, dynamic> attributes;
  Map<String, List<String>> relatedCatalogObjects;
  final String _objType = 'CatalogObject';

  CatalogObject(
      this.type, this.id, this.attributes, this.relatedCatalogObjects);

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "id": id,
      "attributes": attributes,
      "relatedCatalogObjects": relatedCatalogObjects,
      "objType": _objType
    };
  }
}

class LineItem {
  String catalogObjectType;
  String catalogObjectId;
  int quantity;
  double price;
  String currency;
  Map<String, dynamic> attributes;
  final String _objType = 'LineItem';

  LineItem(this.catalogObjectType, this.catalogObjectId, this.quantity,
      this.price, this.currency,
      [this.attributes = const {}]);

  Map<String, dynamic> toJson() {
    return {
      "catalogObjectType": catalogObjectType,
      "catalogObjectId": catalogObjectId,
      "quantity": quantity,
      "price": price,
      "currency": currency,
      "attributes": attributes,
      "objType": _objType
    };
  }
}

class Order {
  String id;
  List<LineItem> lineItems;
  double totalValue;
  String currency;
  Map<String, dynamic> attributes;
  final String _objType = 'Order';

  Order(this.id, this.lineItems, this.totalValue, this.currency,
      [this.attributes = const {}]);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "lineItems": lineItems.map((item) => item.toJson()).toList(),
      "totalValue": totalValue,
      "currency": currency,
      "attributes": attributes,
      "objType": _objType
    };
  }
}
