import com.salesforce.marketingcloud.messages.inbox.*
import com.salesforce.marketingcloud.notifications.*
import com.salesforce.marketingcloud.push.data.*
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date

class InboxUtils {
    companion object {
        fun Date?.asDateString(): String? {
            return this?.let {
                val format = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
                val formattedDate = format.format(it)
                formattedDate
            }
        }

        fun Map<String, String>?.asKeyValueJsonArray(): JSONArray? {
            val jsonArray = JSONArray()
            this?.forEach { (key, value) ->
                val jsonObject = JSONObject()
                jsonObject.put("key", key)
                jsonObject.put("value", value)
                jsonArray.put(jsonObject)
            }
            return jsonArray
        }

        fun NotificationMessage.toJson(): JSONObject {
            return JSONObject().apply { 
                put("id", id)
                put("alert", alert)
                put("sound", sound)
                soundName?.let { put("soundName", it) }
                title?.let { put("title", it) }
                subtitle?.let { put("subtitle", it) }
                put("type", type.toString()) 
                put("trigger", trigger.toString()) 

                url?.let { put("url", it) }
                mediaUrl?.let { put("mediaUrl", it) }
                mediaAltText?.let { put("mediaAltText", it) }
                customKeys.asKeyValueJsonArray()?.let { put("customKeys", it) }
                custom?.let { put("custom", it) }
                payload?.let { put("payload", mapToJson(it)) }
                // richFeatures?.let { put("richFeatures", it.toJson()) }
             }
        }

        fun InboxMessage.toJson(): JSONObject {
            return JSONObject().apply {
                put("id", id)
                put("calculatedType", messageType)
                put("deleted", deleted) 
                messageType?.let { put("messageType", it) }
                url?.let {put("url", it)}
                subject?.let { put("subject", it) }
                title?.let { put("title", it) }
                alert?.let { put("alert", it) }
                sound?.let { put("sound", it) }
                put("read", read) 
                media?.let {
                    val mediaJsonObject = JSONObject().apply {
                        put("altText", it.altText)
                        put("url", it.url)
                    }
                    put("media", mediaJsonObject)
                }
                startDateUtc?.asDateString()?.let { put("startDateUtc", it) }
                sendDateUtc?.asDateString()?.let { put("sendDateUtc", it) }
                endDateUtc?.asDateString()?.let { put("endDateUtc", it) }
                custom?.let { put("custom", it) }
                customKeys?.asKeyValueJsonArray()?.let { put("keys", it) }
                subtitle?.let { put("subtitle", it) }
                inboxMessage?.let { put("inboxMessage", it) }
                inboxSubtitle?.let { put("inboxSubtitle", it) }
                notificationMessage?.let { put("notificationMessage", it.toJson()) }
            }
        }

        fun inboxMessagesToString(messages: List<InboxMessage>): List<String> {
            var messageString = messages.mapNotNull { it.toJson().toString() }
            return messageString
        }

        fun mapToJson(map: Map<String, String>): String {
            return JSONObject(map).toString()
        }
    }
}
