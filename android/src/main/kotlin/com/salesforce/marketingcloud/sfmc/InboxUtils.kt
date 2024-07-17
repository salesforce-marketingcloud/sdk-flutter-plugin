import com.salesforce.marketingcloud.messages.inbox.*
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

        fun InboxMessage.toJson(): JSONObject {
            return JSONObject().apply {
                put("id", id)
                subject?.let { put("subject", it) }
                title?.let { put("title", it) }
                alert?.let { put("alert", it) }
                sound?.let { put("sound", it) }
                read?.let { put("read", it) }
                deleted?.let { put("deleted", it) }
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
                put("url", url)
                custom?.let { put("custom", it) }
                customKeys?.asKeyValueJsonArray()?.let { put("keys", it) }
            }
        }

        fun inboxMessagesToString(messages: List<InboxMessage>): List<String> {
            return messages.mapNotNull { it.toJson().toString() }
        }
    }
}
