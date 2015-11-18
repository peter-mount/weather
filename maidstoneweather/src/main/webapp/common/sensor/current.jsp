<%-- 
    Document   : current

    Displays the current weather values

    Created on : Jun 24, 2014, 12:26:12 PM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://iot.onl/tlds/sensors" prefix="sensor" %>
<%@ taglib uri="http://maidstoneweather.com/tlds/metoffice" prefix="metoffice" %>
<script language="javascript" type="text/javascript" src="/js/raphael-min.js"></script>
<script language="javascript" type="text/javascript" src="/js/symbols.js"></script>

<div class="symbol-outer symbol-box">
    <h2 class="symbol-header">Latest measurements</h2>
    <div class="symbol-panel">
        <div class="symbol-outer">
            <div class="symbol-box">
                <div class="symbol-row">
                    <div class="symbol-cell">
                        <h3 class="symbol-header">Original Mark 1 Station <span id="kell-time">- updated hourly</span></h3>
                        <div class="symbol-inner">
                            <div id="mk1-temp" style="vertical-align: top; width:80px;height:200px;"></div>
                            <div style="font-size:12px;text-align:center;">Temperature</div>
                        </div>
                        <div class="symbol-inner">
                            <div id="mk1-dewpt" style="vertical-align: top; width:80px;height:200px;"></div>
                            <div style="font-size:12px;text-align:center;">Dew Point</div>
                        </div>
                        <div class="symbol-inner">
                            <div id="mk1-rain" class="symbol-rain"></div>
                            <div id="mk1-raind" class="symbol-rain"></div>
                            <div class="symbol-label">Hour - Rainfall - Today</div>
                        </div>
                        <div class="symbol-inner">
                            <div class="symbol-inner">
                                <div id="mk1-press" class="symbol-dial-block"></div>
                                <div id="mk1-humid" class="symbol-amp"></div>
                                <div class="symbol-label">&nbsp;</div>
                            </div>
                            <div class="symbol-inner">
                                <div id="mk1-wind" class="symbol-wind-block"></div>
                                <div id="mk1-windg" class="symbol-wind-block"></div>
                                <div class="symbol-label">&nbsp;</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="symbol-outer">
            <div class="symbol-box">
                <div class="symbol-row">
                    <div class="symbol-cell">
                        <h3 class="symbol-header">Sky Conditions<span id="helene-time"></span></h3>
                        <div class="symbol-inner">
                            <div id="sky-camera1" class="symbol-camera">
                                <img id="sky-camera1-image" src="http://webcam.retep.org/helene/imageThumb.jpg"/>
                                <div>Day Camera</div>
                            </div>
                            <div id="sky-camera2" class="symbol-camera">
                                <img id="sky-camera2-image" src="http://webcam.retep.org/helene/cloud_thumb.jpg"/>
                                <div>Cloud cover</div>
                            </div>
                        </div>
                        <div class="symbol-inner">
                            <div id="sky-uv-current" class="symbol-uv-block"></div>
                            <div id="sky-uv-max" class="symbol-uv-block"></div>
                            <div id="sky-cover" class="symbol-dial-small-block"></div>
                        </div>
                        <div class="symbol-inner">
                            <div id="sky-cloudbase" class="symbol-cloud"></div>
                            <div class="symbol-label">Cloud Base</div>
                        </div>
                        <div class="symbol-inner">
                            <div id="sky-lux" class="symbol-amp"></div>
                            <div id="sky-ir" class="symbol-amp"></div>
                            <div id="sky-vis" class="symbol-amp"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Mark I station
        var mk1temp = new Thermometer('mk1-temp', {
            title: 'Current temperature with todays min/max also shown',
            minmax: true
        });
        var mk1dewpt = new Thermometer('mk1-dewpt', {title: 'Current dewpoint temperature'});
        var mk1rain = new RainGauge('mk1-rain', 5, {title: 'Rainfall in the last hour'});
        var mk1raind = new RainGauge('mk1-raind', 10, {title: 'Total rainfall today'});
        var mk1wind = new WindDirSymbol('mk1-wind', {label: 'Current'});
        var mk1windg = new WindDirSymbol('mk1-windg', {label: 'Gust', gust: true});
        var mk1pres = new DialMeter('mk1-press', {label: 'Pressure', unit: 'hPa', min: 900, max: 1100, step: 100});
        var mk1humid = new AmpMeter('mk1-humid', {label: 'Humidity', unit: '%'});

        // Skycamera
        $('#sky-camera1-image').on('error', function() {
            $(this).prop('src', '/images/offline-thumb.jpg');
        });

        $('#sky-camera2-image').on('error', function() {
            $(this).prop('src', '/images/offline-thumb.jpg');
        });

        var skycloudbase = new CloudBase('sky-cloudbase', {
            title: 'The calculated base altitude of any clouds'
        });
        var skycover = new DialMeter('sky-cover', {
            label: 'Cloud Cover',
            title: 'The percentage of cloud cover visible in the camera',
            unit: '%',
            steps: 20,
            ticks: 5,
            minor: 10
        });
        var skyuvcur = new UVIndexSymbol('sky-uv-current', {
            label: 'Current',
            title: 'The currently observed UV Index'
        });
        var skyuvmax = new UVIndexSymbol('sky-uv-max', {
            label: 'Maximum',
            title: 'The observed maximum UV Index today'
        });
        var skylux = new AmpMeter('sky-lux', {
            label: 'Light Meter',
            title: 'The incident light level that the Human Eye can see',
            unit: ' lux',
            min: 0, max: 50000
        });
        var skyir = new AmpMeter('sky-ir', {
            label: 'Visible/Infra-Red',
            title: 'The raw incident light in the visible and near Infra-Red parts of the spectrum',
            'cover-colour': '#f90',
            min: 0, max: 15000
        });
        var skyvis = new AmpMeter('sky-vis', {
            label: 'UV/Visible',
            title: 'The raw incident light in the Visible and near Ultra-Violet parts of the spectrum',
            'cover-colour': '#cc9',
            min: 0, max: 2500
        });

        function getCurrent(d, f) {
            $.ajax({url: '//iot.onl/api/sensor/current/' + d + '.json', type: 'GET', dataType: 'json', success: f});
        }

        function kell() {
            getCurrent(1, function(s) {
                mk1temp.setTemp(s.current[89].value / 100);
                if (s.min[89])
                    mk1temp.setMinTemp(s.min[89].value / 100);
                if (s.max[89])
                    mk1temp.setMaxTemp(s.max[89].value / 100);

                mk1dewpt.setTemp(s.current[91].value / 100);

                mk1wind.setSpeed(s.current[86].value / 100);
                mk1wind.setDirection(s.current[85].value);

                mk1windg.setSpeed(s.current[87].value / 100);
                mk1windg.setDirection(s.current[85].value);

                mk1humid.setValue(s.current[88].value / 100);
                mk1pres.setValue(s.current[90].value / 100);
                mk1rain.setLevel(s.current[92].value / 100);
                mk1raind.setLevel(s.current[93].value / 100);

                // TODO temporarily use kell's value as helene's temp & pressure sensors are wrong
                skycloudbase.setValue(((s.current[89].value / 100) - (s.current[91].value / 100)) * 400);

                setTimeout(kell, 60000);
            });
        }

        function helene() {
            getCurrent(6, function(s) {
                skycover.setValue(s.current[83].value / 10);

                skylux.setValue(s.current[63].value / 10);
                skyir.setValue(s.current[71].value);
                skyvis.setValue(s.current[70].value);

                skyuvcur.setUv(s.current[69].value / 100);
                skyuvmax.setUv((s.max[69] === undefined ? s.current[69] : s.max[69]).value / 100);

                // TODO see above, currently kell's values are used as helene's sensors are for the enclosure not outside
                //skycloudbase.setValue(s.current[94].value);

                // run again in 1 minutes time
                setTimeout(helene, 60000);

                // Update the camera images
                $('#sky-camera1-image').prop('src', 'http://webcam.retep.org/helene/imageThumb.jpg' + '?' + new Date());
                $('#sky-camera2-image').prop('src', 'http://webcam.retep.org/helene/cloud_thumb.jpg' + '?' + new Date());
            });
        }

        kell();
        helene();

    });
</script>
<%--
<span id="winddir" style="margin:1px;padding:1px;width:60px;height:60px;"></span>
<span id="uv" style="margin:1px;padding:1px;width:60px;height:60px;">&nbsp;</span>

<div id="compass" style="display:inline-block;width:100px;height:100px;"></div>
<div id="humid" style="display:inline-block;width:120px;height:70px;"></div>
<div id="barom" style="display:inline-block;width:100px;height:100px;"></div>

<div id="temp" style="display:inline-block;width:80px;height:200px;"></div>
<div id="raind" style="display:inline-block;width:80px;height:200px;"></div>
<div id="cloud" style="display:inline-block;width:100px;height:200px;"></div>

<div style="height:20px;"></div>

<script>

    $(document).ready(function() {

        var winddir = new WindDirSymbol('winddir');
        var uv = new UVIndexSymbol('uv');
        var temp = new Thermometer('temp', {minmax: true});
        var raind = new RainGauge('raind', 10);
        var humid = new AmpMeter('humid', {label: 'Humidity', unit: '%'});
        var barom = new DialMeter('barom', {label: 'Dew Point', unit: '°C', min: -10, max: 40});
        var cloud = new CloudBase('cloud');

        var compass = new Compass('compass');

        //var cp = [90, 45, 315, 135, 270, 45];
        var cp = [45, 180, 270, 45, 270];
        var i = 0;
        function t() {
            temp.setTemp((Math.random() * 50) - 10);
            humid.setValue(Math.random() * 100);
            barom.setValue((Math.random() * 50) - 10);
            raind.setLevel(Math.random() * 10);
            uv.setUv(Math.random() * 11);
            cloud.setValue(Math.random() * 5000);
            //winddir.setDirection(Math.random() * 360);
            winddir.setDirection(cp[i % cp.length]);
            compass.setDirection(cp[i % cp.length]);
            i++;
            if (i < 10)
                setTimeout(t, 2000);
        }
        t();
    });
</script>
--%>
