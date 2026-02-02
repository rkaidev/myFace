import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.Weather;

class myFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchUi.WatchFace.initialize();
    }

    function onLayout() {
        // layout setup if needed
    }

    function drawTime(dc, time) {
        dc.drawText(50, 50, Graphics.FONT_LARGE, time.hour.format("%02d"));
        dc.drawText(120, 50, Graphics.FONT_MEDIUM, time.min.format("%02d"));
    }

    function drawSteps(dc, steps) {
        var stepsText;
        if (steps > 1000) {
            stepsText = (steps.toFloat() / 1000.0).format("%.1fk");
        } else {
            stepsText = steps.toString();
        }
        dc.drawText(10, 200, Graphics.FONT_SMALL, "STEPS " + stepsText);
    }

    function drawBattery(dc, batteryLevel) {
        if (batteryLevel == null) {
            batteryLevel = 0;
        }
        if (batteryLevel < 0) {
            batteryLevel = 0;
        }
        if (batteryLevel > 100) {
            batteryLevel = 100;
        }

        var BAT_X = 0;
        var BAT_Y = 0;
        var BAT_W = 10;
        var BAT_H = 50;
        var BORDER = 1;

        var innerX = BAT_X + BORDER;
        var innerY = BAT_Y + BORDER;
        var innerW = BAT_W - (2 * BORDER);
        var innerH = BAT_H - (2 * BORDER);

        var rawHeight = (batteryLevel * innerH) / 100.0;
        var fillHeight = rawHeight.toNumber();
        fillHeight = (fillHeight < 0) ? 0 : ((fillHeight > innerH) ? innerH : fillHeight);
        if (batteryLevel > 0 && fillHeight < 1) {
            fillHeight = 1;
        }

        var fillY = innerY + (innerH - fillHeight);

        var fillColor = Graphics.COLOR_GREEN;
        if (batteryLevel < 20) {
            fillColor = Graphics.COLOR_RED;
        }
        else if (batteryLevel < 50) {
            fillColor = Graphics.COLOR_YELLOW;
        }

        dc.setColor(fillColor);
        dc.fillRectangle(innerX, fillY, innerW, fillHeight);

        dc.setColor(Graphics.COLOR_BLACK);
        dc.drawRectangle(BAT_X, BAT_Y, BAT_W, BAT_H);

        dc.drawText(20, 10, Graphics.FONT_SMALL, batteryLevel.toString() + "%");
    }

    function drawBodyBattery(dc, bodyBattery) {
        var bbText = (bodyBattery != null) ? bodyBattery.toString() : "N/A";
        dc.drawText(50, 100, Graphics.FONT_SMALL, "Body: " + bbText);
    }

    function drawBadges(dc, badges) {
        var x = 10;
        if (badges["bluetooth"]) {
            dc.drawText(x, 300, Graphics.FONT_SMALL, "BT");
            x += 30;
        }
        if (badges["notification"]) {
            dc.drawText(x, 300, Graphics.FONT_SMALL, "NTF");
            x += 30;
        }
        if (badges["alarm"]) {
            dc.drawText(x, 300, Graphics.FONT_SMALL, "ALM");
        }
    }

    function drawTemperature(dc, temp, icon) {
        var tempText = (temp != null) ? temp.toString() : "N/A";
        dc.drawText(10, 250, Graphics.FONT_SMALL, icon + " " + tempText);
    }

    function drawDistance(dc, distance) {
        dc.drawText(10, 280, Graphics.FONT_SMALL, distance.toString() + "km");
    }

    function draw(dc, data) {
        drawTime(dc, data["time"]);
        drawSteps(dc, data["steps"]);
        drawBattery(dc, data["battery"]);
        drawBodyBattery(dc, data["bodyBattery"]);
        drawBadges(dc, data["badges"]);
        drawTemperature(dc, data["temperature"], data["weatherIcon"]);
        drawDistance(dc, data["distance"]);
    }

    function onUpdate() {
        var dc = WatchUi.getDisplayContext();
        dc.setColor(Graphics.COLOR_WHITE);
        dc.clear();

        var time = System.getClockTime();
        var info = ActivityMonitor.getInfo();
        var steps = info["steps"];
        var distance = (info["distance"] != null) ? (info["distance"].toFloat() / 1000.0).toNumber() : 0;
        var battery = System.getSystemStats().battery.toNumber();
        var bodyBattery = info["bodyBattery"];  // safe access, null if missing

        var settings = System.getDeviceSettings();
        var badges = {
            "bluetooth" => settings.phoneConnected,
            "notification" => (settings.notificationCount > 0),
            "alarm" => (settings.alarmCount > 0)
        };

        var conditions = Weather.getCurrentConditions();
        var temp = null;
        var weatherIcon = "?";
        if (conditions != null) {
            if (conditions.temperature != null) {
                temp = conditions.temperature;
            }

            var cond = conditions.condition;
            if (cond == Weather.CONDITION_CLEAR || cond == Weather.CONDITION_MOSTLY_CLEAR) {
                weatherIcon = "SUN";
            }
            else if (cond == Weather.CONDITION_RAIN || cond == Weather.CONDITION_LIGHT_RAIN) {
                weatherIcon = "RAIN";
            }
            else if (cond == Weather.CONDITION_CLOUDY || cond == Weather.CONDITION_PARTLY_CLOUDY) {
                weatherIcon = "CLOUD";
            }
            else {
                weatherIcon = "?";
            }
        }

        var data = {
            "time" => time,
            "steps" => steps,
            "battery" => battery,
            "bodyBattery" => bodyBattery,
            "badges" => badges,
            "temperature" => temp,
            "weatherIcon" => weatherIcon,
            "distance" => distance
        };

        draw(dc, data);
    }
}
