package com.goccuameo.lich_am

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import java.util.Calendar

/**
 * Tự cập nhật widget khi sang ngày mới (nửa đêm) + sau khi khởi động máy.
 *
 * Dùng AlarmManager (setAndAllowWhileIdle) đặt mốc ~00:00 hôm sau và tự ĐẶT
 * LẠI mỗi lần kích hoạt → đổi ngày chắc chắn ngay cả khi OEM (Samsung One UI)
 * chặn broadcast nền hoặc throttle updatePeriodMillis. Không cần app chạy nền,
 * không mở Flutter engine: chỉ phát APPWIDGET_UPDATE để provider chọn ảnh đã
 * render sẵn cho ngày hiện tại.
 */
class WidgetAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // Cập nhật mọi widget (provider chọn ảnh ngày hiện tại) + đặt lại báo thức.
        updateWidgets(context)
        scheduleNextMidnight(context)
    }

    companion object {
        const val ACTION_MIDNIGHT = "com.goccuameo.lich_am.WIDGET_MIDNIGHT"
        private const val REQUEST_CODE = 7001

        fun updateWidgets(context: Context) {
            val mgr = AppWidgetManager.getInstance(context)
            for (cls in listOf(
                LichAmWidgetProvider::class.java,
                LichAmWidget2x2Provider::class.java
            )) {
                val ids = mgr.getAppWidgetIds(ComponentName(context, cls))
                if (ids.isEmpty()) continue
                val intent = Intent(context, cls).apply {
                    action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                    putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                }
                context.sendBroadcast(intent)
            }
        }

        /** Đặt báo thức cho ~00:00:05 ngày hôm sau (inexact, đủ chính xác để đổi ngày). */
        fun scheduleNextMidnight(context: Context) {
            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val next = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 5)
                set(Calendar.MILLISECOND, 0)
            }.timeInMillis
            val pi = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE,
                Intent(context, WidgetAlarmReceiver::class.java)
                    .setAction(ACTION_MIDNIGHT),
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            try {
                // setAndAllowWhileIdle + RTC_WAKEUP: fire kể cả trong Doze, KHÔNG cần quyền
                // SCHEDULE_EXACT_ALARM. Sai số vài phút là chấp nhận được.
                am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next, pi)
            } catch (e: Exception) {
                // An toàn: nếu hệ thống chặn, vẫn còn broadcast DATE_CHANGED +
                // updatePeriodMillis làm lớp dự phòng.
            }
        }
    }
}
