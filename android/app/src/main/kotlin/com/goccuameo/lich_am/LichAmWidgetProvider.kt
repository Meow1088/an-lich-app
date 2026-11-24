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

class LichAmWidgetProvider : HomeWidgetProvider() {
    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        // Bắt đầu lịch tự đổi ngày khi người dùng thêm widget.
        WidgetAlarmReceiver.scheduleNextMidnight(context)
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        // Đặt lại báo thức nửa đêm mỗi lần cập nhật (mở app / resume / broadcast).
        WidgetAlarmReceiver.scheduleNextMidnight(context)
        // Chọn ảnh đã render sẵn cho NGÀY HIỆN TẠI (đổi ngày tự động lúc
        // updatePeriodMillis chạy hoặc khi nhận broadcast đổi ngày). Nếu chưa
        // có ảnh ngày đó (app lâu chưa mở) thì dùng khoá cũ làm fallback.
        val todayKey = "lich_widget_image_" +
            SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date())

        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.lich_am_widget).apply {
                val path = widgetData.getString(todayKey, null)
                    ?: widgetData.getString("lich_widget_image", null)
                if (path != null) {
                    val file = File(path)
                    if (file.exists()) {
                        val bmp = BitmapFactory.decodeFile(file.absolutePath)
                        if (bmp != null) setImageViewBitmap(R.id.widget_image, bmp)
                    }
                }
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context, MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.widget_image, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
