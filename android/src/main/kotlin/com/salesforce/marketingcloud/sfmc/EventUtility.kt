// EventUtility.kt
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

package com.salesforce.marketingcloud.sfmc

import com.salesforce.marketingcloud.sfmcsdk.components.events.*

private enum class OrderEventType(val stringValue: String) {
    PURCHASE("Purchase"),
    PREORDER("Preorder"),
    CANCEL("Cancel"),
    SHIP("Ship"),
    DELIVER("Deliver"),
    RETURN("Return"),
    EXCHANGE("Exchange")
}

private enum class CartEventType(val stringValue: String) {
    ADD("Add To Cart"),
    REMOVE("Remove From Cart"),
    REPLACE("Replace Cart")
}

private enum class CatalogEventType(val stringValue: String) {
    COMMENT("Comment Catalog Object"),
    VIEW("View Catalog Object"),
    QUICK_VIEW("Quick View Catalog Object"),
    DETAIL("View Catalog Object Detail"),
    FAVORITE("Favorite Catalog Object"),
    SHARE("Share Catalog Object"),
    REVIEW("Review Catalog Object")
}

@Suppress("UNCHECKED_CAST")
class EventUtility {

    companion object {
        fun toEvent(eventMap: Map<String, Any?>): Event? {
            return when (eventMap["objType"]) {
                "CartEvent" -> createCartEvent(eventMap)
                "CustomEvent" -> createCustomEvent(eventMap)
                "OrderEvent" -> createOrderEvent(eventMap)
                "CatalogObjectEvent" -> createCatalogEvent(eventMap)
                else -> checkForOtherEvents(eventMap)
            }
        }

        private fun createCustomEvent(eventMap: Map<String, Any?>): Event? {
            return EventManager.customEvent(
                eventMap["name"] as? String ?: "CustomEvent",
                eventMap["attributes"] as? Map<String, Any> ?: emptyMap()
            )
        }

        private fun createCartEvent(eventMap: Map<String, Any?>): CartEvent? {
            val lineItemsList = eventMap["lineItems"] as? List<Map<String, Any?>> ?: return null
            if (lineItemsList.isEmpty()) return null
            val lineItem = getLineItem(lineItemsList.first())

            return when (eventMap["name"]) {
                CartEventType.ADD.stringValue -> CartEvent.add(lineItem)
                CartEventType.REMOVE.stringValue -> CartEvent.remove(lineItem)
                CartEventType.REPLACE.stringValue -> CartEvent.replace(
                    lineItemsList.map { getLineItem(it) }
                )

                else -> null
            }
        }

        private fun createOrderEvent(eventMap: Map<String, Any?>): OrderEvent? {
            val order = getOrder(eventMap["order"] as? Map<String, Any?> ?: emptyMap())
            return when (eventMap["name"]) {
                OrderEventType.PURCHASE.stringValue -> OrderEvent.purchase(order)
                OrderEventType.PREORDER.stringValue -> OrderEvent.preorder(order)
                OrderEventType.CANCEL.stringValue -> OrderEvent.cancel(order)
                OrderEventType.SHIP.stringValue -> OrderEvent.ship(order)
                OrderEventType.DELIVER.stringValue -> OrderEvent.deliver(order)
                OrderEventType.RETURN.stringValue -> OrderEvent.returnOrder(order)
                OrderEventType.EXCHANGE.stringValue -> OrderEvent.exchange(order)
                else -> null
            }
        }

        private fun createCatalogEvent(eventMap: Map<String, Any?>): CatalogEvent? {
            val catalogObject =
                getCatalogObject(eventMap["catalogObject"] as? Map<String, Any?> ?: emptyMap())
            return when (eventMap["name"]) {
                CatalogEventType.COMMENT.stringValue -> CatalogEvent.comment(catalogObject)
                CatalogEventType.VIEW.stringValue -> CatalogEvent.view(catalogObject)
                CatalogEventType.QUICK_VIEW.stringValue -> CatalogEvent.quickView(catalogObject)
                CatalogEventType.DETAIL.stringValue -> CatalogEvent.viewDetail(catalogObject)
                CatalogEventType.FAVORITE.stringValue -> CatalogEvent.favorite(catalogObject)
                CatalogEventType.SHARE.stringValue -> CatalogEvent.share(catalogObject)
                CatalogEventType.REVIEW.stringValue -> CatalogEvent.review(catalogObject)
                else -> null
            }
        }

        private fun checkForOtherEvents(eventMap: Map<String, Any?>): Event? {
            val category = when (eventMap["category"] as? String) {
                "system" -> Event.Category.SYSTEM
                "engagement" -> Event.Category.ENGAGEMENT
                else -> null
            }
            return category?.let {
                EventManager.customEvent(
                    eventMap["name"] as? String ?: "",
                    eventMap["attributes"] as? Map<String, Any> ?: emptyMap(),
                    Event.Producer.PUSH,
                    it
                )
            }
        }

        private fun getOrder(orderMap: Map<String, Any?>): Order {
            val id = orderMap["id"] as? String ?: ""
            val currency = orderMap["currency"] as? String
            val totalValue = (orderMap["totalValue"] as? Number)?.toDouble()
            val lineItems =
                (orderMap["lineItems"] as? List<Map<String, Any?>>)?.map { getLineItem(it) }
                    ?: emptyList()
            val attributes = orderMap["attributes"] as? Map<String, Any> ?: emptyMap()
            return Order(id, lineItems, totalValue, currency, attributes)
        }

        private fun getLineItem(lineItemMap: Map<String, Any?>): LineItem {
            val catalogObjectType = lineItemMap["catalogObjectType"] as? String ?: ""
            val catalogObjectId = lineItemMap["catalogObjectId"] as? String ?: ""
            val quantity = (lineItemMap["quantity"] as? Number)?.toInt() ?: 0
            val price = (lineItemMap["price"] as? Number)?.toDouble()
            val currency = lineItemMap["currency"] as? String
            val attributes = lineItemMap["attributes"] as? Map<String, Any> ?: emptyMap()
            return LineItem(
                catalogObjectType,
                catalogObjectId,
                quantity,
                price,
                currency,
                attributes
            )
        }

        private fun getCatalogObject(catalogObjectMap: Map<String, Any?>): CatalogObject {
            val type = catalogObjectMap["type"] as? String ?: ""
            val id = catalogObjectMap["id"] as? String ?: ""
            val attributes = catalogObjectMap["attributes"] as? Map<String, Any> ?: emptyMap()
            val relatedCatalogObjects =
                getRelatedCatalogObjects(catalogObjectMap["relatedCatalogObjects"] as? Map<String, Any?>)
            return CatalogObject(type, id, attributes, relatedCatalogObjects)
        }

        private fun getRelatedCatalogObjects(relatedCatalogObjectsMap: Map<String, Any?>?): Map<String, List<String>> {
            return relatedCatalogObjectsMap?.mapValues { (_, value) ->
                (value as? List<*>)?.filterIsInstance<String>() ?: emptyList()
            } ?: emptyMap()
        }
    }
}