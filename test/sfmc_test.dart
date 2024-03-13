import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/sfmc.dart';
import 'package:sfmc/sfmc_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSfmcPlatform with MockPlatformInterfaceMixin implements SfmcPlatform {
  String recentCalledMethod = '';
  final Map<String, String> mockAttributes = {};
  final List<String> mockTags = [];
  String? mockContactKey;
  Map<String, dynamic>? lastTrackedEvent;
  bool mockAnalyticsEnabled = false;
  bool mockPiAnalyticsEnabled = false;

  void _logCall(String methodName) {
    recentCalledMethod = methodName;
  }

  @override
  Future<String?> getSystemToken() {
    _logCall('getSystemToken');
    return Future.value('mock_token');
  }

  @override
  Future<bool?> isPushEnabled() {
    _logCall('isPushEnabled');
    return Future.value(true);
  }

  @override
  Future<void> enablePush() async {
    _logCall('enablePush');
  }

  @override
  Future<void> disablePush() async {
    _logCall('disablePush');
  }

  @override
  Future<void> enableLogging() async {
    _logCall('enableLogging');
  }

  @override
  Future<void> disableLogging() async {
    _logCall('disableLogging');
  }

  @override
  Future<void> logSdkState() async {
    _logCall('logSdkState');
  }

  @override
  Future<String?> getDeviceId() {
    _logCall('getDeviceId');
    return Future.value('mock_device_id');
  }

  @override
  Future<Map<String, String>> getAttributes() {
    _logCall('getAttributes');
    return Future.value(mockAttributes);
  }

  @override
  Future<void> setAttribute(String key, String value) async {
    _logCall('setAttribute');
    mockAttributes[key] = value;
  }

  @override
  Future<void> clearAttribute(String key) async {
    _logCall('clearAttribute');
    mockAttributes[key] = "";
  }

  @override
  Future<void> addTag(String tag) async {
    _logCall('addTag');
    mockTags.add(tag);
  }

  @override
  Future<void> removeTag(String tag) async {
    _logCall('removeTag');
    mockTags.remove(tag);
  }

  @override
  Future<List<String>> getTags() {
    _logCall('getTags');
    return Future.value(mockTags);
  }

  @override
  Future<void> setContactKey(String contactKey) async {
    _logCall('setContactKey');
    mockContactKey = contactKey;
  }

  @override
  Future<String?> getContactKey() {
    _logCall('getContactKey');
    return Future.value(mockContactKey);
  }

  @override
  Future<void> trackEvent(Map<String, dynamic> event) async {
    lastTrackedEvent = event;
  }

  @override
  Future<void> setAnalyticsEnabled(bool analyticsEnabled) async {
    _logCall('setAnalyticsEnabled');
    mockAnalyticsEnabled = analyticsEnabled;
  }

  @override
  Future<bool> isAnalyticsEnabled() {
    _logCall('isAnalyticsEnabled');
    return Future.value(mockAnalyticsEnabled);
  }

  @override
  Future<void> setPiAnalyticsEnabled(bool analyticsEnabled) async {
    _logCall('setPiAnalyticsEnabled');
    mockPiAnalyticsEnabled = analyticsEnabled;
  }

  @override
  Future<bool> isPiAnalyticsEnabled() {
    _logCall('isPiAnalyticsEnabled');
    return Future.value(mockPiAnalyticsEnabled);
  }
}

void main() {
  final SfmcPlatform initialPlatform = SfmcPlatform.instance;
  late MockSfmcPlatform mockPlatform;
  const String testKey = 'testKey';
  const String testValue = 'testValue';
  const String testTag = 'testTag';
  const String testContactKey = 'testContactKey';

  setUp(() {
    mockPlatform = MockSfmcPlatform();
    SfmcPlatform.instance = mockPlatform;
  });

  tearDown(() {
    SfmcPlatform.instance = initialPlatform;
  });

  test('getSystemToken', () async {
    expect(await SFMCSdk.getSystemToken(), 'mock_token');
    expect(mockPlatform.recentCalledMethod, 'getSystemToken');
  });

  test('isPushEnabled', () async {
    expect(await SFMCSdk.isPushEnabled(), true);
    expect(mockPlatform.recentCalledMethod, 'isPushEnabled');
  });

  test('enablePush', () async {
    await SFMCSdk.enablePush();
    expect(mockPlatform.recentCalledMethod, 'enablePush');
  });

  test('disablePush', () async {
    await SFMCSdk.disablePush();
    expect(mockPlatform.recentCalledMethod, 'disablePush');
  });

  test('enableLogging', () async {
    await SFMCSdk.enableLogging();
    expect(mockPlatform.recentCalledMethod, 'enableLogging');
  });

  test('disableLogging', () async {
    await SFMCSdk.disableLogging();
    expect(mockPlatform.recentCalledMethod, 'disableLogging');
  });

  test('logSdkState', () async {
    await SFMCSdk.logSdkState();
    expect(mockPlatform.recentCalledMethod, 'logSdkState');
  });

  test('getDeviceId', () async {
    expect(await SFMCSdk.getDeviceId(), 'mock_device_id');
    expect(mockPlatform.recentCalledMethod, 'getDeviceId');
  });

  test('getAttributes', () async {
    mockPlatform.mockAttributes[testKey] = testValue;
    expect(await SFMCSdk.getAttributes(), equals(mockPlatform.mockAttributes));
    expect(mockPlatform.recentCalledMethod, 'getAttributes');
  });

  test('setAttribute', () async {
    await SFMCSdk.setAttribute(testKey, testValue);
    expect(mockPlatform.mockAttributes[testKey], equals(testValue));
    expect(mockPlatform.recentCalledMethod, 'setAttribute');
  });

  test('clearAttribute', () async {
    mockPlatform.mockAttributes[testKey] = testValue;
    await SFMCSdk.clearAttribute(testKey);
    expect(mockPlatform.mockAttributes[testKey], "");
    expect(mockPlatform.recentCalledMethod, 'clearAttribute');
  });

  test('addTag', () async {
    await SFMCSdk.addTag(testTag);
    expect(mockPlatform.mockTags.contains(testTag), isTrue);
    expect(mockPlatform.recentCalledMethod, 'addTag');
  });

  test('removeTag', () async {
    mockPlatform.mockTags.add(testTag);
    await SFMCSdk.removeTag(testTag);
    expect(mockPlatform.mockTags.contains(testTag), isFalse);
    expect(mockPlatform.recentCalledMethod, 'removeTag');
  });

  test('getTags', () async {
    mockPlatform.mockTags.add(testTag);
    expect(await SFMCSdk.getTags(), equals(mockPlatform.mockTags));
    expect(mockPlatform.recentCalledMethod, 'getTags');
  });

  test('setContactKey', () async {
    await SFMCSdk.setContactKey(testContactKey);
    expect(mockPlatform.mockContactKey, equals(testContactKey));
    expect(mockPlatform.recentCalledMethod, 'setContactKey');
  });

  test('getContactKey', () async {
    mockPlatform.mockContactKey = testContactKey;
    expect(await SFMCSdk.getContactKey(), equals(testContactKey));
    expect(mockPlatform.recentCalledMethod, 'getContactKey');
  });

  group('SFMCSdk trackEvent Tests', () {
    late MockSfmcPlatform mockPlatform;

    setUp(() {
      mockPlatform = MockSfmcPlatform();
      SfmcPlatform.instance = mockPlatform;
    });

    test('trackEvent sends correct data', () async {
      var customEvent = CustomEvent('TestEvent',
          attributes: {'key': 'value'}, category: EventCategory.engagement);
      await SFMCSdk.trackEvent(customEvent);

      expect(mockPlatform.lastTrackedEvent, isNotNull);
      expect(mockPlatform.lastTrackedEvent!['category'], 'engagement');
      expect(mockPlatform.lastTrackedEvent!['name'], 'TestEvent');
      expect(mockPlatform.lastTrackedEvent!['attributes'], {'key': 'value'});
    });
  });

  group('CustomEvent Tests', () {
    test('CustomEvent Initialization and JSON Conversion', () async {
      var event = CustomEvent('TestEvent',
          attributes: {'key1': 'value1'}, category: EventCategory.system);
      await SFMCSdk.trackEvent(event);

      expect(mockPlatform.lastTrackedEvent, isNotNull);
      expect(mockPlatform.lastTrackedEvent!['name'], 'TestEvent');
      expect(mockPlatform.lastTrackedEvent!['attributes'], {'key1': 'value1'});
      expect(mockPlatform.lastTrackedEvent!['category'], 'system');
      expect(mockPlatform.lastTrackedEvent!['objType'], 'CustomEvent');
    });
  });

  group('EngagementEvent Tests', () {
    test('EngagementEvent Initialization and JSON Conversion', () async {
      var event =
          EngagementEvent('EngageEvent', attributes: {'key2': 'value2'});
      await SFMCSdk.trackEvent(event);

      expect(mockPlatform.lastTrackedEvent, isNotNull);
      expect(mockPlatform.lastTrackedEvent!['name'], 'EngageEvent');
      expect(mockPlatform.lastTrackedEvent!['attributes'], {'key2': 'value2'});
      expect(mockPlatform.lastTrackedEvent!['objType'], 'EngagementEvent');
    });
  });

  group('SystemEvent Tests', () {
    test('SystemEvent Initialization and JSON Conversion', () async {
      var event = SystemEvent('SystemEvent', attributes: {'key3': 'value3'});
      await SFMCSdk.trackEvent(event);

      expect(mockPlatform.lastTrackedEvent, isNotNull);
      expect(mockPlatform.lastTrackedEvent!['name'], 'SystemEvent');
      expect(mockPlatform.lastTrackedEvent!['attributes'], {'key3': 'value3'});
      expect(mockPlatform.lastTrackedEvent!['objType'], 'SystemEvent');
    });
  });

  group('CartEvent Tests', () {
    void testCartEvent(CartEvent event, String expectedEventName,
        List<LineItem> lineItems) async {
      await SFMCSdk.trackEvent(event);

      expect(mockPlatform.lastTrackedEvent, isNotNull);
      expect(mockPlatform.lastTrackedEvent!['name'], expectedEventName);
      expect(
          mockPlatform.lastTrackedEvent!['lineItems'].length, lineItems.length);
      expect(mockPlatform.lastTrackedEvent!['objType'], 'CartEvent');
    }

    test('CartEvent Add To Cart and JSON Conversion', () async {
      var lineItem = LineItem('type', 'id', 2, 10.0, 'USD');
      var event = CartEvent.addToCart(lineItem);
      testCartEvent(event, CartEventType.add.name, [lineItem]);
    });

    test('CartEvent Remove From Cart and JSON Conversion', () async {
      var lineItem = LineItem('type', 'id', 2, 10.0, 'USD');
      var event = CartEvent.removeFromCart(lineItem);
      testCartEvent(event, CartEventType.remove.name, [lineItem]);
    });

    test('CartEvent Replace Cart and JSON Conversion', () async {
      var lineItems = [
        LineItem('type1', 'id1', 3, 15.0, 'USD'),
        LineItem('type2', 'id2', 1, 20.0, 'USD')
      ];
      var event = CartEvent.replaceCart(lineItems);
      testCartEvent(event, CartEventType.replace.name, lineItems);
    });
  });

  group('CatalogObjectEvent Tests', () {
    var catalogObject = CatalogObject('type', 'id', {
      "key": "value"
    }, {
      "relatedKey": ["value1", "value2"]
    });

    testCatalogEvent(CatalogObjectEvent event, String expectedEventName,
        CatalogObject order) async {
      await SFMCSdk.trackEvent(event);

      expect(mockPlatform.lastTrackedEvent, isNotNull);
      expect(mockPlatform.lastTrackedEvent!['name'], expectedEventName);
      expect(mockPlatform.lastTrackedEvent!['catalogObject']['id'], 'id');
      expect(mockPlatform.lastTrackedEvent!['objType'], 'CatalogObjectEvent');
      var jsonCatalogObject = mockPlatform.lastTrackedEvent!['catalogObject'];
      expect(jsonCatalogObject['type'], 'type');
      expect(jsonCatalogObject['id'], 'id');
      expect(jsonCatalogObject['attributes'], {'key': 'value'});
      expect(jsonCatalogObject['relatedCatalogObjects'], {
        "relatedKey": ["value1", "value2"]
      });
    }

    test('CatalogObjectEvent Comment and JSON Conversion', () async {
      var event = CatalogObjectEvent.commentCatalog(catalogObject);
      testCatalogEvent(
          event, CatalogObjectEventName.comment.name, catalogObject);
    });

    test('CatalogObjectEvent Detail and JSON Conversion', () async {
      var event = CatalogObjectEvent.detailCatalog(catalogObject);
      testCatalogEvent(
          event, CatalogObjectEventName.detail.name, catalogObject);
    });

    test('CatalogObjectEvent Favorite and JSON Conversion', () async {
      var event = CatalogObjectEvent.favoriteCatalog(catalogObject);
      testCatalogEvent(
          event, CatalogObjectEventName.favorite.name, catalogObject);
    });

    test('CatalogObjectEvent Share and JSON Conversion', () async {
      var event = CatalogObjectEvent.shareCatalog(catalogObject);
      testCatalogEvent(event, CatalogObjectEventName.share.name, catalogObject);
    });

    test('CatalogObjectEvent Review and JSON Conversion', () async {
      var event = CatalogObjectEvent.reviewCatalog(catalogObject);
      testCatalogEvent(
          event, CatalogObjectEventName.review.name, catalogObject);
    });

    test('CatalogObjectEvent View and JSON Conversion', () async {
      var event = CatalogObjectEvent.viewCatalog(catalogObject);
      testCatalogEvent(event, CatalogObjectEventName.view.name, catalogObject);
    });

    test('CatalogObjectEvent QuickView and JSON Conversion', () async {
      var event = CatalogObjectEvent.quickViewCatalog(catalogObject);
      testCatalogEvent(
          event, CatalogObjectEventName.quickView.name, catalogObject);
    });
  });

  group('OrderEvent Tests', () {
    var lineItem = LineItem('type', 'id', 1, 20.0, 'USD');
    var order = Order('orderId', [lineItem], 20.0, 'USD');
    void testOrderEvent(
        OrderEvent event, String expectedEventName, Order order) async {
      await SFMCSdk.trackEvent(event);

      expect(mockPlatform.lastTrackedEvent, isNotNull);
      expect(mockPlatform.lastTrackedEvent!['name'], expectedEventName);
      expect(mockPlatform.lastTrackedEvent!['order']['id'], 'orderId');
      expect(mockPlatform.lastTrackedEvent!['objType'], 'OrderEvent');
      expect(mockPlatform.lastTrackedEvent!['order']['totalValue'], 20.0);
      expect(mockPlatform.lastTrackedEvent!['order']['currency'], 'USD');
      var jsonLineItem =
          mockPlatform.lastTrackedEvent!['order']['lineItems'][0];
      expect(jsonLineItem['catalogObjectType'], 'type');
      expect(jsonLineItem['catalogObjectId'], 'id');
      expect(jsonLineItem['quantity'], 1);
      expect(jsonLineItem['price'], 20.0);
      expect(jsonLineItem['currency'], 'USD');
    }

    test('OrderEvent Purchase and JSON Conversion', () async {
      var event = OrderEvent.purchase(order);
      testOrderEvent(event, OrderEventName.purchase.name, order);
    });

    test('OrderEvent Preorder and JSON Conversion', () async {
      var event = OrderEvent.preorder(order);
      testOrderEvent(event, OrderEventName.preorder.name, order);
    });

    test('OrderEvent Cancel and JSON Conversion', () async {
      var event = OrderEvent.cancel(order);
      testOrderEvent(event, OrderEventName.cancel.name, order);
    });

    test('OrderEvent Ship and JSON Conversion', () async {
      var event = OrderEvent.ship(order);
      testOrderEvent(event, OrderEventName.ship.name, order);
    });

    test('OrderEvent Deliver and JSON Conversion', () async {
      var event = OrderEvent.deliver(order);
      testOrderEvent(event, OrderEventName.deliver.name, order);
    });

    test('OrderEvent ReturnOrder and JSON Conversion', () async {
      var event = OrderEvent.returnOrder(order);
      testOrderEvent(event, OrderEventName.returnOrder.name, order);
    });

    test('OrderEvent Exchange and JSON Conversion', () async {
      var event = OrderEvent.exchange(order);
      testOrderEvent(event, OrderEventName.exchange.name, order);
    });
  });

  group('LineItem Tests', () {
    test('LineItem Initialization and JSON Conversion', () {
      var lineItem = LineItem(
          'type', 'id', 3, 15.0, 'USD', {'attributeKey': 'attributeValue'});
      var json = lineItem.toJson();

      expect(json['catalogObjectType'], 'type');
      expect(json['catalogObjectId'], 'id');
      expect(json['quantity'], 3);
      expect(json['price'], 15.0);
      expect(json['currency'], 'USD');
      expect(json['attributes'], {'attributeKey': 'attributeValue'});
    });
  });

  group('Order Tests', () {
    test('Order Initialization and JSON Conversion', () {
      var lineItems = [LineItem('type', 'id', 3, 15.0, 'USD')];
      var order = Order('orderId', lineItems, 45.0, 'USD',
          {'attributeKey': 'attributeValue'});
      var json = order.toJson();

      expect(json['id'], 'orderId');
      expect(json['lineItems'].length, 1);
      expect(json['totalValue'], 45.0);
      expect(json['currency'], 'USD');
      expect(json['attributes'], {'attributeKey': 'attributeValue'});
    });
  });

  group('CatalogObject Tests', () {
    test('CatalogObject Initialization and JSON Conversion', () {
      var catalogObject = CatalogObject('type', 'id', {
        'attributeKey': 'attributeValue'
      }, {
        "key": ["value1", "value2"]
      });
      var json = catalogObject.toJson();

      expect(json['type'], 'type');
      expect(json['id'], 'id');
      expect(json['attributes'], {'attributeKey': 'attributeValue'});
      expect(json['relatedCatalogObjects'], {
        "key": ["value1", "value2"]
      });
    });
  });

  group('Runtime Toggle Tests', () {
    test('setAnalyticsEnabled', () async {
      await SFMCSdk.setAnalyticsEnabled(true);
      expect(mockPlatform.mockAnalyticsEnabled, isTrue);
      expect(mockPlatform.recentCalledMethod, 'setAnalyticsEnabled');
    });

    test('isAnalyticsEnabled', () async {
      mockPlatform.mockAnalyticsEnabled = true;
      expect(await SFMCSdk.isAnalyticsEnabled(), isTrue);
      expect(mockPlatform.recentCalledMethod, 'isAnalyticsEnabled');
    });

    test('setPiAnalyticsEnabled', () async {
      await SFMCSdk.setPiAnalyticsEnabled(true);
      expect(mockPlatform.mockPiAnalyticsEnabled, isTrue);
      expect(mockPlatform.recentCalledMethod, 'setPiAnalyticsEnabled');
    });

    test('isPiAnalyticsEnabled', () async {
      mockPlatform.mockPiAnalyticsEnabled = true;
      expect(await SFMCSdk.isPiAnalyticsEnabled(), isTrue);
      expect(mockPlatform.recentCalledMethod, 'isPiAnalyticsEnabled');
    });
  });
}
