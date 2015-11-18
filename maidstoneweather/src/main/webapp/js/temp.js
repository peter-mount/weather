/**
 * Initiate ajax call to last24h rest api
 * @param {type} u userId
 * @param {type} d deviceId
 * @param {type} s sensorId
 * @param {String} t Type of aggregate
 * @param {type} f callback function
 * @returns {undefined}
 */
function retrieveLast24(u, d, s, t, f) {
    $.ajax({url: '//iot.onl/api/sensor/history/' + u + '/' + d + '/' + s + '/10/' + t + '/last24h.json', type: 'GET', dataType: 'json', success: f});
}
/**
 * Utility to define a flot dataset entry
 * @param {type} l Label
 * @param {type} d data
 * @param {type} o order
 * @param {type} c line colour
 * @returns {tds.Anonym$1}
 */
function tds(l, d, o, c) {
    return {label: l, data: d, lines: {order: o}, color: c};
}

/**
 * Utility to create the plot options
 * @param {type} c Legend Container
 * @returns {topt.Anonym$2}
 */
function topt(c) {
    return {
        legend: {show: true, container: c},
        lines: {lineWidth: 1, show: true, fill: false},
        xaxis: {mode: "time"}
    };
}

$(document).ready(function() {

    var kell_temp = [];
    var kell_rain = [];
    var kell_dailyrain = [];
    var kell_humid = [];
    var kell_pres = [];
    var kell_dewpt = [];

    var helene_cloud = [];
    var helene_dew = [];
    var helene_enc = [];
    var helene_dome = [];
    var helene_cpu = [];
    var helene_pres = [];
    var helene_humid = [];
    var helene_uv = [];
    var helene_lux = [];

    var kari_cloud = [];
    var kari_cpu = [];

    var tempDataSet, humidDataSet, presDataSet, skyDataSet, sysTempDataSet;
    var uvDataSet, rainDataSet;

    var rainOptions = {
        legend: {show: true, container: $('#rainLegend')},
        lines: {lineWidth: 1, show: true, fill: false},
        xaxis: {mode: "time"},
        yaxis: {min: 0}
    };
    var tempOptions = topt($('#tempLegend'));
    var presOptions = {
        legend: {show: true, container: $('#presLegend')},
        lines: {lineWidth: 1, show: true, fill: false},
        xaxis: {mode: "time"}
//        yaxis: {
//            // 127 year low is 936.8hPa Dev 23 2013
//            min: 900,
//            // Guinness records highest 1054.7 Aberdeen 31 Jan 1902
//            max: 1060
//        }
    };
    var humidOptions = {
        legend: {show: true, container: $('#humidLegend')},
        lines: {lineWidth: 1, show: true, fill: false},
        xaxis: {mode: "time"},
        yaxis: {min: 0, max: 100, tickSize: 10}
    };
    var uvOptions = {
        legend: {show: true, container: $('#uvLegend')},
        lines: {lineWidth: 1, show: true, fill: false},
        xaxis: {mode: "time"},
        yaxes: [{
                min: 0,
                max: 15,
                tickSize: 2,
                alignTicksWithAxis: 1
            },
            {
                min: 0,
                // Sensor max is 54612.5 in low res
                max: 55000,
                alignTicksWithAxis: 1,
                position: "right"
            }]
    };
    var skyOptions = {
        legend: {show: true, container: $('#skyLegend')},
        lines: {lineWidth: 1, show: true, fill: false},
        xaxis: {mode: "time"},
        yaxis: {min: 0, max: 100, tickSize: 10}
    };
    var sysTempOptions = topt($('#sysTempLegend'));

    // The temperature graph
    function tempReplot() {
        tempDataSet = [
            tds("Temp Mk1", kell_temp, 1, "#0000ff"),
            tds("Dewpoint Mk1", kell_dewpt, 1, "#00ff00"),
            tds("Dewpoint Mk2", helene_dew, 1, "#00ffff")
        ];

        $.plot('#tempPlot', tempDataSet, tempOptions);
    }

    function presReplot() {
        presDataSet = [
            tds("Pressure Mk1", kell_pres, 1, "#ff0000"),
            tds("Pressure SkyCam", helene_pres, 1, "#0000ff")
        ];

        $.plot('#presPlot', presDataSet, presOptions);
    }

    function humidReplot() {
        humidDataSet = [
            tds("Humidity Mk1", kell_humid, 1, "#ffff00"),
            tds("Humidity SkyCam", helene_humid, 1, "#00ffff")
        ];

        $.plot('#humidPlot', humidDataSet, humidOptions);
    }

    function rainReplot() {
        rainDataSet = [
            tds("Rainfall Mk1", kell_rain, 1, "#ff0000"),
            tds("Rainfall Mk1 Daily", kell_dailyrain, 1, "#ffff00")
        ];

        $.plot('#rainPlot', rainDataSet, rainOptions);
    }

    function uvReplot() {
        uvDataSet = [
            {
                label: "UV Index",
                data: helene_uv,
                lines: {order: 1},
                color: "#ff0000",
                yaxis: 1
            },
            {
                label: "Ambient Light (Lux)",
                data: helene_lux,
                lines: {order: 2},
                color: "#0000ff",
                yaxis: 2
            }
        ];

        $.plot('#uvPlot', uvDataSet, uvOptions);
    }
    // The temperature graph
    function skyReplot() {
        skyDataSet = [
            tds("Zenith", helene_cloud, 1, "#00ff00"),
            tds("West Horizon", kari_cloud, 1, "#0000ff")
        ];

        $.plot('#skyPlot', skyDataSet, skyOptions);
    }

    // The system temperature graph
    function sysTempReplot() {
        sysTempDataSet = [
            tds("SkyCam Enclosure", helene_enc, 1, "#00ff00"),
            tds("SkyCam Dome", helene_dome, 2, "#00ffff"),
            tds("SkyCam CPU", helene_cpu, 3, "#0000ff"),
            tds("West Cam CPU", kari_cpu, 4, "#ff0000")
        ];

        $.plot('#sysTempPlot', sysTempDataSet, sysTempOptions);
    }

    // Update the graphs
    function updatePlots() {

        retrieveLast24(1, 1, 89, 'average', function(s) {
            kell_temp = s;
            tempReplot();
        });

        retrieveLast24(1, 1, 91, 'average', function(s) {
            kell_dewpt = s;
            tempReplot();
        });

        retrieveLast24(1, 6, 72, 'average', function(s) {
            helene_dew = s;
            tempReplot();
        });

        retrieveLast24(1, 1, 92, 'max', function(s) {
            kell_rain = s;
            rainReplot();
        });

        retrieveLast24(1, 1, 93, 'max', function(s) {
            kell_dailyrain = s;
            rainReplot();
        });

        retrieveLast24(1, 6, 64, 'average', function(s) {
            helene_pres = s;
            presReplot();
        });

        retrieveLast24(1, 1, 90, 'average', function(s) {
            kell_pres = s;
            presReplot();
        });

        retrieveLast24(1, 6, 68, 'average', function(s) {
            helene_humid = s;
            humidReplot();
        });

        retrieveLast24(1, 1, 88, 'average', function(s) {
            kell_humid = s;
            humidReplot();
        });

        retrieveLast24(1, 6, 69, 'max', function(s) {
            helene_uv = s;
            uvReplot();
        });

        retrieveLast24(1, 6, 63, 'max', function(s) {
            helene_lux = s;
            uvReplot();
        });

        retrieveLast24(1, 6, 83, 'average', function(s) {
            helene_cloud = s;
            skyReplot();
        });

        retrieveLast24(1, 5, 81, 'average', function(s) {
            kari_cloud = s;
            skyReplot();
        });

        retrieveLast24(1, 6, 65, 'average', function(s) {
            helene_enc = s;
            sysTempReplot();
        });
        retrieveLast24(1, 6, 76, 'average', function(s) {
            helene_dome = s;
            sysTempReplot();
        });
        retrieveLast24(1, 6, 59, 'average', function(s) {
            helene_cpu = s;
            sysTempReplot();
        });
        retrieveLast24(1, 5, 62, 'average', function(s) {
            kari_cpu = s;
            sysTempReplot();
        });
    }
    updatePlots();
});