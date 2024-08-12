import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sfmc/sfmc_method_channel.dart';
import 'package:sfmc/sfmc.dart';
import 'package:sfmc/inbox_message.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MethodChannelSfmc platform = MethodChannelSfmc();
  const MethodChannel channel = MethodChannel('sfmc');
  List<String> mockInboxMsgs = [
    jsonEncode(InboxMessage(
      id: "1",
      title: "Test1",
      alert: "New message 1",
      deleted: false,
      read: false,
      url: "https://example.com/1",
      sendDateUtc: DateTime.now(),
    ).toJson()),
    jsonEncode(InboxMessage(
      id: "2",
      title: "Test2",
      alert: "New message 2",
      deleted: false,
      read: true,
      url: "https://example.com/2",
      sendDateUtc: DateTime.now(),
    ).toJson()),
  ];

  List<String> mockInboxReadMsgs = [
    jsonEncode(InboxMessage(
      id: "2",
      title: "Test2",
      alert: "New message 2",
      deleted: false,
      read: true,
      url: "https://example.com/2",
      sendDateUtc: DateTime.now(),
    ).toJson()),
  ];

  List<String> mockInboxUnreadMsgs = [
    jsonEncode(InboxMessage(
      id: "1",
      title: "Test1",
      alert: "New message 1",
      deleted: false,
      read: false,
      url: "https://example.com/1",
      sendDateUtc: DateTime.now(),
    ).toJson()),
  ];

  List<String> mockInboxDeletedMsgs = [
    jsonEncode(InboxMessage(
      id: "3",
      title: "Test3",
      alert: "Deleted message",
      deleted: true,
      read: false,
      url: "https://example.com/3",
      sendDateUtc: DateTime.now().subtract(Duration(days: 2)),
    ).toJson()),
  ];

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getSystemToken':
            return 'token_123';
          case 'isPushEnabled':
            return true;
          case 'getDeviceId':
            return 'device_123';
          case 'isAnalyticsEnabled':
            return true;
          case 'isPiAnalyticsEnabled':
            return true;
          case 'getMessages':
            return mockInboxMsgs;
          case 'getReadMessages':
            return mockInboxReadMsgs;
          case 'getUnreadMessages':
            return mockInboxUnreadMsgs;
          case 'getDeletedMessages':
            return mockInboxDeletedMsgs;
          case 'getMessageCount':
            return 5;
          case 'getReadMessageCount':
            return 3;
          case 'getUnreadMessageCount':
            return 2;
          case 'getDeletedMessageCount':
            return 8;
          case 'refreshInbox':
            return true;
          default:
            return null;
        }
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getSystemToken', () async {
    expect(await platform.getSystemToken(), 'token_123');
  });

  test('isPushEnabled', () async {
    expect(await platform.isPushEnabled(), true);
  });

  test('getDeviceId', () async {
    expect(await platform.getDeviceId(), 'device_123');
  });

  test('enablePush', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'enablePush') {
        methodCalled = true;
      }
      return null;
    });

    await platform.enablePush();
    expect(methodCalled, true);
  });

  test('disablePush', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'disablePush') {
        methodCalled = true;
      }
      return null;
    });

    await platform.disablePush();
    expect(methodCalled, true);
  });

  test('enableLogging', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'enableLogging') {
        methodCalled = true;
      }
      return null;
    });

    await platform.enableLogging();
    expect(methodCalled, true);
  });

  test('disableLogging', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'disableLogging') {
        methodCalled = true;
      }
      return null;
    });

    await platform.disableLogging();
    expect(methodCalled, true);
  });

  test('logSdkState', () async {
    bool methodCalled = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'logSdkState') {
        methodCalled = true;
      }
      return null;
    });

    await platform.logSdkState();
    expect(methodCalled, true);
  });

  test('getAttributes', () async {
    const testAttributes = {"key1": "value1", "key2": "value2"};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getAttributes') {
        return testAttributes;
      }
      return null;
    });

    expect(await platform.getAttributes(), testAttributes);
  });

  test('setAttribute', () async {
    bool methodCalled = false;
    const String key = "testKey";
    const String value = "testValue";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'setAttribute' &&
          methodCall.arguments["key"] == key &&
          methodCall.arguments["value"] == value) {
        methodCalled = true;
      }
      return null;
    });

    await platform.setAttribute(key, value);
    expect(methodCalled, true);
  });

  test('clearAttribute', () async {
    bool methodCalled = false;
    const String key = "testKey";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'clearAttribute' &&
          methodCall.arguments["key"] == key) {
        methodCalled = true;
      }
      return null;
    });

    await platform.clearAttribute(key);
    expect(methodCalled, true);
  });

  test('addTag', () async {
    bool methodCalled = false;
    const String tag = "testTag";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'addTag' && methodCall.arguments["tag"] == tag) {
        methodCalled = true;
      }
      return null;
    });

    await platform.addTag(tag);
    expect(methodCalled, true);
  });

  test('removeTag', () async {
    bool methodCalled = false;
    const String tag = "testTag";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'removeTag' &&
          methodCall.arguments["tag"] == tag) {
        methodCalled = true;
      }
      return null;
    });

    await platform.removeTag(tag);
    expect(methodCalled, true);
  });

  test('getTags', () async {
    const testTags = ["tag1", "tag2"];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getTags') {
        return testTags;
      }
      return null;
    });

    expect(await platform.getTags(), testTags);
  });

  test('setContactKey', () async {
    bool methodCalled = false;
    const String contactKey = "testContactKey";

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'setContactKey' &&
          methodCall.arguments["contactKey"] == contactKey) {
        methodCalled = true;
      }
      return null;
    });

    await platform.setContactKey(contactKey);
    expect(methodCalled, true);
  });

  test('getContactKey', () async {
    const String testContactKey = "contactKey_123";
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getContactKey') {
        return testContactKey;
      }
      return null;
    });

    expect(await platform.getContactKey(), testContactKey);
  });

  group('CustomEvent Tests', () {
    test('CustomEvent trackEvent Method Call with Correct JSON', () async {
      var customEvent =
          CustomEvent('TestCustomEvent', attributes: {'key': 'value'});

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['category'], customEvent.category.name);
          expect(json['name'], customEvent.name);
          expect(json['attributes'], customEvent.attributes);
        }
        return null;
      });

      await platform.trackEvent(customEvent.toJson());
    });
  });

  group('EngagementEvent Tests', () {
    test('EngagementEvent trackEvent Method Call with Correct JSON', () async {
      var engagementEvent =
          EngagementEvent('TestEngagementEvent', attributes: {'key': 'value'});

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['category'], engagementEvent.category.name);
          expect(json['name'], engagementEvent.name);
          expect(json['attributes'], engagementEvent.attributes);
        }
        return null;
      });

      await platform.trackEvent(engagementEvent.toJson());
    });
  });

  group('SystemEvent Tests', () {
    test('SystemEvent trackEvent Method Call with Correct JSON', () async {
      var systemEvent = SystemEvent('TestSystemEvent',
          attributes: {'systemKey': 'systemValue'});

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['category'], systemEvent.category.name);
          expect(json['name'], systemEvent.name);
          expect(json['attributes'], systemEvent.attributes);
        }
        return null;
      });

      await platform.trackEvent(systemEvent.toJson());
    });
  });

  group('CartEvent Tests', () {
    test('CartEvent Add to Cart trackEvent Method Call with Correct JSON',
        () async {
      var lineItem = LineItem('type', 'id', 1, 10.0, 'USD');
      var cartEvent = CartEvent.addToCart(lineItem);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['name'], CartEventType.add.name);
          expect(json['lineItems'], isNotEmpty);
          expect(json['lineItems'][0]['catalogObjectId'],
              lineItem.catalogObjectId);
        }
        return null;
      });

      await platform.trackEvent(cartEvent.toJson());
    });

    test('CartEvent RemoveCart trackEvent Method Call with Correct JSON',
        () async {
      var lineItem = LineItem('type', 'id', 1, 10.0, 'USD');
      var cartEvent = CartEvent.removeFromCart(lineItem);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['name'], CartEventType.remove.name);
          expect(json['lineItems'], isNotEmpty);
          expect(json['lineItems'][0]['catalogObjectId'],
              lineItem.catalogObjectId);
        }
        return null;
      });

      await platform.trackEvent(cartEvent.toJson());
    });

    test('CartEvent ReplaceCart trackEvent Method Call with Correct JSON',
        () async {
      var lineItems = [
        LineItem('type', 'id1', 1, 10.0, 'USD'),
        LineItem('type', 'id2', 2, 20.0, 'EUR')
      ];
      var cartEvent = CartEvent.replaceCart(lineItems);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['name'], CartEventType.replace.name);
          expect(json['lineItems'], isNotEmpty);
          expect(json['lineItems'].length, lineItems.length);
          expect(json['lineItems'][0]['catalogObjectId'],
              lineItems[0].catalogObjectId);
          expect(json['lineItems'][1]['catalogObjectId'],
              lineItems[1].catalogObjectId);
        }
        return null;
      });

      await platform.trackEvent(cartEvent.toJson());
    });
  });

  group('CatalogObjectEvent Tests', () {
    CatalogObject createTestCatalogObject() {
      return CatalogObject('TestType', 'TestId', {
        'attrKey': 'attrValue'
      }, {
        'relatedKey': ['relatedValue1', 'relatedValue2']
      });
    }

    void testCatalogObjectEvent(
        CatalogObjectEvent event, String expectedEventName) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['name'], event.name);
          expect(json['catalogObject'], isNotNull);
          expect(json['catalogObject']['type'], event.catalogObject.type);
          expect(json['catalogObject']['id'], event.catalogObject.id);
          expect(json['catalogObject']['attributes'], isNotNull);
          expect(json['catalogObject']['relatedCatalogObjects'], isNotNull);
        }
        return null;
      });

      platform.trackEvent(event.toJson());
    }

    test('Comment Catalog Object Event', () {
      var catalogObject = createTestCatalogObject();
      var event = CatalogObjectEvent.commentCatalog(catalogObject);
      testCatalogObjectEvent(event, CatalogObjectEventName.comment.name);
    });

    test('Detail Catalog Object Event', () {
      var catalogObject = createTestCatalogObject();
      var event = CatalogObjectEvent.detailCatalog(catalogObject);
      testCatalogObjectEvent(event, CatalogObjectEventName.detail.name);
    });

    test('Favorite Catalog Object Event', () {
      var catalogObject = createTestCatalogObject();
      var event = CatalogObjectEvent.favoriteCatalog(catalogObject);
      testCatalogObjectEvent(event, CatalogObjectEventName.favorite.name);
    });

    test('Share Catalog Object Event', () {
      var catalogObject = createTestCatalogObject();
      var event = CatalogObjectEvent.shareCatalog(catalogObject);
      testCatalogObjectEvent(event, CatalogObjectEventName.share.name);
    });

    test('Review Catalog Object Event', () {
      var catalogObject = createTestCatalogObject();
      var event = CatalogObjectEvent.reviewCatalog(catalogObject);
      testCatalogObjectEvent(event, CatalogObjectEventName.review.name);
    });

    test('View Catalog Object Event', () {
      var catalogObject = createTestCatalogObject();
      var event = CatalogObjectEvent.viewCatalog(catalogObject);
      testCatalogObjectEvent(event, CatalogObjectEventName.view.name);
    });

    test('Quick View Catalog Object Event', () {
      var catalogObject = createTestCatalogObject();
      var event = CatalogObjectEvent.quickViewCatalog(catalogObject);
      testCatalogObjectEvent(event, CatalogObjectEventName.quickView.name);
    });
  });

  group('OrderEvent Tests', () {
    Order createTestOrder() {
      var lineItems = [LineItem('type', 'id', 1, 10.0, 'USD')];
      return Order('TestOrderId', lineItems, 10.0, 'USD');
    }

    void testOrderEvent(OrderEvent event, String expectedEventName) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'trackEvent') {
          var json = methodCall.arguments;
          expect(json['name'], expectedEventName);
          expect(json['order'], isNotNull);
          expect(json['order']['id'], event.order.id);
          expect(json['order']['lineItems'], isNotNull);
          expect(json['order']['totalValue'], event.order.totalValue);
        }
        return null;
      });

      platform.trackEvent(event.toJson());
    }

    test('Purchase Order Event', () {
      var order = createTestOrder();
      var event = OrderEvent.purchase(order);
      testOrderEvent(event, OrderEventName.purchase.name);
    });

    test('Preorder Order Event', () {
      var order = createTestOrder();
      var event = OrderEvent.preorder(order);
      testOrderEvent(event, OrderEventName.preorder.name);
    });

    test('Cancel Order Event', () {
      var order = createTestOrder();
      var event = OrderEvent.cancel(order);
      testOrderEvent(event, OrderEventName.cancel.name);
    });

    test('Ship Order Event', () {
      var order = createTestOrder();
      var event = OrderEvent.ship(order);
      testOrderEvent(event, OrderEventName.ship.name);
    });

    test('Deliver Order Event', () {
      var order = createTestOrder();
      var event = OrderEvent.deliver(order);
      testOrderEvent(event, OrderEventName.deliver.name);
    });

    test('Return Order Event', () {
      var order = createTestOrder();
      var event = OrderEvent.returnOrder(order);
      testOrderEvent(event, OrderEventName.returnOrder.name);
    });

    test('Exchange Order Event', () {
      var order = createTestOrder();
      var event = OrderEvent.exchange(order);
      testOrderEvent(event, OrderEventName.exchange.name);
    });
  });

  group('Runtime Toggle Tests', () {
    test('setAnalyticsEnabled', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'setAnalyticsEnabled') {
          methodCalled = true;
        }
        return null;
      });

      await platform.setAnalyticsEnabled(true);
      expect(methodCalled, true);
    });

    test('isAnalyticsEnabled', () async {
      expect(await platform.isAnalyticsEnabled(), true);
    });

    test('setPiAnalyticsEnabled', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'setPiAnalyticsEnabled') {
          methodCalled = true;
        }
        return null;
      });

      await platform.setPiAnalyticsEnabled(true);
      expect(methodCalled, true);
    });

    test('isPiAnalyticsEnabled', () async {
      expect(await platform.isPiAnalyticsEnabled(), true);
    });
  });

  group('Inbox Methods Tests', () {
    test('getMessages', () async {
      final messages = await platform.getMessages();
      expect(messages.length, 2);
      expect(messages[0].id, "1");
      expect(messages[1].id, "2");
    });

    test('getReadMessages', () async {
      final messages = await platform.getReadMessages();
      expect(messages.length, 1);
      expect(messages[0].id, "2");
      expect(messages[0].read, true);
    });

    test('getUnreadMessages', () async {
      final messages = await platform.getUnreadMessages();
      expect(messages.length, 1);
      expect(messages[0].id, "1");
      expect(messages[0].read, false);
    });

    test('getDeletedMessages', () async {
      final messages = await platform.getDeletedMessages();
      expect(messages.length, 1);
      expect(messages[0].id, "3");
      expect(messages[0].deleted, true);
    });

    test('setMessageRead', () async {
      bool methodCalled = false;
      const String messageId = "testMessageReadId";
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'setMessageRead' &&
            methodCall.arguments["messageId"] == messageId) {
          methodCalled = true;
        }
        return null;
      });

      await platform.setMessageRead(messageId);
      expect(methodCalled, true);
    });

    test('deleteMessage', () async {
      bool methodCalled = false;
      const String messageId = "testMessageDeletedId";
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'deleteMessage' &&
            methodCall.arguments["messageId"] == messageId) {
          methodCalled = true;
        }
        return null;
      });

      await platform.deleteMessage(messageId);
      expect(methodCalled, true);
    });

    test('getMessageCount', () async {
      expect(await platform.getMessageCount(), 5);
    });

    test('getReadMessageCount', () async {
      expect(await platform.getReadMessageCount(), 3);
    });

    test('getUnreadMessageCount', () async {
      expect(await platform.getUnreadMessageCount(), 2);
    });

    test('getDeletedMessageCount', () async {
      expect(await platform.getDeletedMessageCount(), 8);
    });

    test('markAllMessagesRead', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'markAllMessagesRead') {
          methodCalled = true;
        }
        return null;
      });

      await platform.markAllMessagesRead();
      expect(methodCalled, true);
    });

    test('markAllMessagesDeleted', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'markAllMessagesDeleted') {
          methodCalled = true;
        }
        return null;
      });

      await platform.markAllMessagesDeleted();
      expect(methodCalled, true);
    });

    test('refreshInbox', () async {
      expect(await platform.isPiAnalyticsEnabled(), true);
    });

    responseObject(response) {}

    test('registerInboxResponseListener', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'registerInboxResponseListener') {
          methodCalled = true;
        }
        return null;
      });

      await platform.registerInboxResponseListener(responseObject);
      expect(methodCalled, true);
    });

    test('unregisterInboxResponseListener', () async {
      bool methodCalled = false;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        if (methodCall.method == 'unregisterInboxResponseListener') {
          methodCalled = true;
        }
        return null;
      });

      await platform.unregisterInboxResponseListener(responseObject);
      expect(methodCalled, true);
    });
  });
}
