package com.goccuameo.lich_am

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class LichAmWidget2x2Provider : HomeWidgetProvider() {
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        WidgetAlarmReceiver.scheduleNextMidnight(context)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        WidgetAlarmReceiver.scheduleNextMidnight(context)
        val todayKey = "lich_widget_2x2_image_" +
            SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.lich_am_widget_2x2).apply {
                val path = widgetData.getString(todayKey, null)
                    ?: widgetData.getString("lich_widget_2x2_image", null)
                if (path != null) {
                    val file = File(path)
                    if (file.exists()) {
                        val bmp = BitmapFactory.decodeFile(file.absolutePath)
                        if (bmp != null) setImageViewBitmap(R.id.widget_image_2x2, bmp)
                    }
                }
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context, MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_image_2x2, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
