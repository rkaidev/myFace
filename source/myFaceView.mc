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

    // Fixed signature for onLayout as per Garmin SDK
    function onLayout(dc) {
        // layout setup if needed
    }

    function drawTime(dc, time) {
        dc.drawText(50, 50, Graphics.FONT_MEDIUM, time.hour.format("%02d"));
        dc.drawText(120, 50, Graphics.FONT_SMALL, time.min.format("%02d"));
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

        // Clamp fillHeight to [0, innerH]
        if (fillHeight < 0) {
            fillHeight = 0;
        }
        if (fillHeight > innerH) {
            fillHeight = innerH;
        }
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

        dc.setColor(fillColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(innerX, fillY, innerW, fillHeight);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawRectangle(BAT_X, BAT_Y, BAT_W, BAT_H);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
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

    // Fixed signature for onUpdate as per Garmin SDK
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        // Minimal safe render to verify runtime stability
        dc.drawText(40, 120, Graphics.FONT_SMALL, "HELLO, WHOLE WORLD", Graphics.TEXT_JUSTIFY_LEFT);
    }
}
