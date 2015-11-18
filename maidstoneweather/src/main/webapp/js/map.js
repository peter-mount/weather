// Version 3 of the Weather Map Browser

var map;

// Metadata received from modp
var modpObservationMeta, modpObservationLayers = {};
var modpForecastMeta, modpForecastLayers = {};
var latestTime=0;

function getLayer(n) {
    var l = map.getLayersByName(n);
    return l.length === 1 ? l[0] : undefined;
}

/**
 * Issues calls to modp rest services to get the available layer details
 * 
 * TODO: This only adds layers, it does not remove layers, which shouldn't occur (until we need them)
 * 
 * @returns {undefined}
 */
function modpUpdate() {

    // Update/Create MODP Observation layers
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "http://modp." + location.hostname + "/observation/layers.json",
        success: function(data) {
            modpObservationMeta = data;
            for (var i = 0; i < modpObservationMeta.length; i++) {
                latestTime=modpObservationMeta[i]["latest"];
                var n = 'obs_' + modpObservationMeta[i]["layer"];
                var l = getLayer(n);
                if (l === undefined) {
                    l = new OpenLayers.Layer.MODPObservation(n, modpObservationMeta[i]["display"], modpObservationMeta[i]["layer"], latestTime, map);
                    modpObservationLayers[n] = l;
                    addLayerComponent($('#map-observation-layers ul'), "obs", n, modpObservationMeta[i]["display"], l, true, false);
                }
                else
                    l.setLatest(latestTime);
            }
            
            /*
            for (var i = 0; i < modpForecastMeta.length; i++) {
                var l = getLayer('fcst_' + modpForecastMeta[i]["layer"]);
                if(l!==undefined)l.setLatest(latestTime);
            }
            */
            
            setStep(timeStep);
        }
    });

    // Update/Create MODP Forecast layers
    /* Not yet working
    $.ajax({
        type: "GET",
        dataType: "json",
        url: "http://modp." + location.hostname + "/forecast/layers.json",
        success: function(data) {
            console.info("Received Forecast Layers", data);
            modpForecastMeta = data;
            for (var i = 0; i < modpForecastMeta.length; i++) {
                console.info("Layer", i, modpForecastMeta[i]["display"], modpForecastMeta[i]["layer"], modpForecastMeta[i]["latest"]);
                var n = 'fcst_' + modpForecastMeta[i]["layer"];
                var l = getLayer(n);
                if (l === undefined) {
                    l = new OpenLayers.Layer.MODPForecast(n, modpForecastMeta[i]["display"], modpForecastMeta[i]["layer"], latestTime, map);
                    modpForecastLayers[n] = l;
                    addLayerComponent($('#map-forecast-layers ul'), "obs", n, modpForecastMeta[i]["display"], l, true, false);
                }
                else
                    l.setLatest(latestTime);
            }
            setStep(timeStep);
        }
    });
    */

    // Update again in 15 minutes
    timer = setTimeout(modpUpdate, 900000);
}

/**
 * Adds DOM and Event's to the page for a layer
 * @param {type} comp UL component to add
 * @param {type} pre prefix making ul unique, eg "obs" "fore", "base" etc
 * @param {type} name Layer name
 * @param {type} display Display name
 * @param {type} layer Layer to add
 * @param {type} visible is layer visible, ignored if base===true
 * @param {type} base is base layer
 * @returns {undefined}
 */
function addLayerComponent(comp, pre, name, display, layer, visible, base) {
    var id = 'layer-' + pre + '-' + name;
    if (base) {
        map.addLayer(layer);
        comp.append('<li><input id="' + id + '" type="radio" name="base" value="' + layer.name + '"/>' + display + '</li>');
        $('#' + id).change(function() {
            var l = getLayer($(this).val());
            if (l !== undefined)
                map.setBaseLayer(l);
            else
                console.error("Unable to set base layer ", $(this).val());
        });
    } else {
        comp.append('<li><input id="' + id + '" type="checkbox" name="' + name + '" value="' + layer.name + '"/>' + display + '</li>');
        setTimeout(function() {
            layer.setVisibility(visible);
            if (visible)
                $('#' + id).attr('checked', 'checked');
        }, 500);
        map.addLayer(layer);
        $('#' + id).change(function() {
            var l = getLayer($(this).val());
            if (l !== undefined)
                l.setVisibility($(this).is(':checked'));
            else
                console.error("Unable to set layer ", $(this).attr('name'));
        });
    }
}

// Time controls backend

var timeStep = 0;
var timer = null;
function f(v) {
    return (v < 10 ? '0' : '') + v;
}
var mnth = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dev'];
function setStep(t) {
    timeStep = Math.max($('#map-time-range').attr('min'), Math.min($('#map-time-range').attr('max'), t));
    $('#map-time-range').val(timeStep);
    $.each(modpObservationLayers, function(i, l) {
        l.setFrame(timeStep);
    });
    $.each(modpForecastLayers, function(i, l) {
        l.setFrame(timeStep);
    });

    // Update time shown to the current step
    var d = new Date();
    d.setTime(latestTime + (900000 * timeStep));
    $('#map-time-shown').replaceWith('<div id="map-time-shown">Showing ' + mnth[d.getMonth()] + ' ' + f(d.getDate()) + ' ' + f(d.getHours()) + ':' + f(d.getMinutes()) + '</div>');
}
function playForward() {
    setStep(timeStep >= 0 ? -9 : timeStep + 1);
    timer = setTimeout(playForward, 1000);
}

function showMap() {

    var graticuleControl = new OpenLayers.Control.Graticule();
    map = new OpenLayers.Map({
        div: "map",
        projection: new OpenLayers.Projection("EPSG:900913"),
        displayProjection: new OpenLayers.Projection("EPSG:4326"),
        layers: [],
        controls: [
            new OpenLayers.Control.KeyboardDefaults(),
            graticuleControl,
            new OpenLayers.Control.Navigation(),
            //new OpenLayers.Control.Permalink({anchor: true}), // to change page url as you pan/zoom?
            //new OpenLayers.Control.MousePosition(),
            //new OpenLayers.Control.OverviewMap(),
            new OpenLayers.Control.ScaleLine({div: document.getElementById('map-zoom-scale')})
        ]});

    // Base Layers
    var baseLayers = {
        osm: new OpenLayers.Layer.OpenTransportMaps('Street Map', 'osm', true),
        land: new OpenLayers.Layer.OpenTransportMaps('Land Cover', 'land', true)
    };
    jQuery.each(baseLayers, function(i, v) {
        addLayerComponent($('#map-base-layers ul'), 'base', i, v.name, v, true, true);
    });
    // Default with the OSM layer
    $('#layer-base-osm').prop('checked', true);
    map.setBaseLayer(baseLayers.osm);

    // Overlay Layers
    var overlays = {
        graticule: graticuleControl.gratLayer
                /* For now these overlays are disabled
                 mainline: new OpenLayers.Layer.OpenTransportMaps('Mainline', 'mainline', false),
                 hs2: new OpenLayers.Layer.OpenTransportMaps('HS2', 'hs2', false),
                 abandoned: new OpenLayers.Layer.OpenTransportMaps('Abandoned lines', 'abandoned', false),
                 disused: new OpenLayers.Layer.OpenTransportMaps('Disused lines', 'disused', false),
                 motorway: new OpenLayers.Layer.OpenTransportMaps('Motorways', 'motorway', false)
                 */
    };
    jQuery.each(overlays, function(i, v) {
        addLayerComponent($('#map-aux-layers ul'), 'base', i, v.name, v, false, false);
    });

    // The Map preset zoom control
    var map_presets = {
        kent: [0.77952, 51.22017, 9, "Kent"],
        london: [-0.1447, 51.46466, 9, "London"],
        southeast: [0.56494, 51.47245, 8, "Southeast England"],
        southwest: [-3.0166, 50.74824, 7, "Southwest England"],
        uk: [-3.5, 54.5, 5, "UK"],
        england: [-2.30249, 53.06891, 6, "England"],
        scotland: [-5.30176, 57.57004, 6, "Scotland"],
        wales: [-3.82959, 52.39367, 7, "Wales"],
        nire: [-6.82336, 54.64647, 8, 'Northern Ireland'],
        ire: [-7.81763, 53.58073, 6, "Ireland"]
    };
    function setPreset(name) {
        map.setCenter(new OpenLayers.LonLat(map_presets[name][0], map_presets[name][1]).transform(new OpenLayers.Projection("EPSG:4326"), map.getProjectionObject()), map_presets[name][2]);
    }
    $('#map-presets').append('<select id="map-presets-select" title="Select an area to automatically zoom the map"></select>');
    $('#map-presets-select').append('<option value="">Zoom to</option>');
    jQuery.each(map_presets, function(i, v) {
        $('#map-presets-select').append('<option value="' + i + '">' + v[3] + '</option>');
    });
    $('#map-presets-select').change(function() {
        var v = $('#map-presets select').val();
        $('#map-presets select').val('');
        setPreset(v);
    });
    // If the map is not yet centered then default to Kent
    if (!map.getCenter())
        setPreset('kent');

    // Map Zoom control
    $('#map-zoom-level').append('<img id="map-zoom-level-out" src="/images/nav/Back24.gif" title="Zoom the map out"/>');
    $('#map-zoom-level-out').bind('click', function() {
        map.zoomOut();
    });
    $('#map-zoom-level').append('<input id="map-zoom-level-slide" type="range" min="0" max="18" step="1" keyboard="false" title="Zoom in or out of the map"/>');
    $('#map-zoom-level-slide').val(map.getZoom());
    $('#map-zoom-level-slide').attr('min', map.getMinZoom());
    $('#map-zoom-level-slide').attr('max', Math.max(17, map.getNumZoomLevels() - map.getMinZoom() + 1));
    $('#map-zoom-level-slide').change(function() {
        map.setCenter(map.getCenter(), $('#map-zoom-level-slide').val());
    });
    map.events.register("move", $('#map-zoom-level-slide'), function() {
        $('#map-zoom-level-slide').val(map.getZoom());
    });
    $('#map-zoom-level').append('<img id="map-zoom-level-in" src="/images/nav/Forward24.gif" title="Zoom the map in"/>');
    $('#map-zoom-level-in').bind('click', function() {
        map.zoomIn();
    });

    // ============================================================
    // Time controls
    $('#map-time-now').click(function() {
        setStep(0);
    });
    $('#map-time-range').change(function() {
        setStep($('#map-time-range').val());
    });
    $('#map-time-rewind').click(function() {
        setStep(Math.max(-9, timeStep - 4));
    });
    $('#map-time-back').click(function() {
        setStep(Math.max(-9, timeStep - 1));
    });
    $('#map-time-forward').click(function() {
        setStep(Math.min(144, timeStep + 1));
    });
    $('#map-time-fastfwd').click(function() {
        setStep(Math.min(144, timeStep + 4));
    });
    $('#map-time-play').click(function() {
        if (timer === null)
            playForward();
    });
    $('#map-time-stop').click(function() {
        if (timer !== null) {
            clearTimeout(timer);
            timer = null;
        }
    });

    // Finally run an update. This will get the current image to show in the map
    modpUpdate();
}
