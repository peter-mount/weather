/*
 * OpenLayers 2 Layer for using our MODP service
 */

/**
 * Class: OpenLayers.Layer.MODPObservation
 * 
 * Displays a MODP Observation layer with support for time travel
 *
 * Inherits from:
 *  - <OpenLayers.Layer.OSM>
 */
OpenLayers.Layer.MODPObservation = OpenLayers.Class(OpenLayers.Layer.Image, {
    layerName: "",
    frameNumber: 0,
    latest: 0,
    displayName: "",
    /**
     * Constructor: OpenLayers.Layer.OSM.LocalMassachuettsMapnik
     *
     * Parameters:
     * @param {String} name
     * @param {undefined} layer
     * @param {undefined} map
     * options - {Object} Hashtable of extra options to tag onto the layer
     */
    initialize: function(name, displayName, layer, latest, map) {
        this.displayName = displayName;
        this.layerName = layer;

        var projection = new OpenLayers.Projection("EPSG:4326");
        var bounds = new OpenLayers.Bounds();
        bounds.extend(new OpenLayers.LonLat(-12.0, 48.0).transform(projection, map.getProjectionObject()));
        bounds.extend(new OpenLayers.LonLat(5.0, 61.0).transform(projection, map.getProjectionObject()));
        var layerSize = new OpenLayers.Size(500, 500);
        this.frameNumber = 0;
        this.latest = latest;
        var url = this.frameUrl(this.frameNumber);
        var newArguments = [name, url, bounds, layerSize, {
                isBaseLayer: false,
                tileOptions: {crossOriginKeyword: null}
            }];
        OpenLayers.Layer.Image.prototype.initialize.apply(this, newArguments);
    },
    /**
     * Select the frame to view
     * @param {type} timeStep
     * @returns {undefined}
     */
    setFrame: function(timeStep) {
        this.frameNumber = Math.max(-10, Math.min(144, timeStep));
        this.setUrl(this.frameUrl(this.frameNumber));
    },
    /**
     * Moves a frame by a number of steps
     * @param {type} step
     * @returns {undefined}
     */
    stepFrame: function(step) {
        this.setFrame(this.frameNumber + step);
    },
    /**
     * Sets the current time that represents frame 0. It will also refresh the currently displayed frame so that it's
     * then in sync.
     * @param {type} t
     * @returns {undefined}
     */
    setLatest: function(t) {
        this.latest = t;
        setFrame(this.frameNumber);
    },
    /**
     * Calculates the required url for the feature.
     * 
     * @param {type} offset Frame offset, 0=latest, 10 earliest
     * @returns url
     */
    frameUrl: function(offset) {
        if(offset>0)
            return '/images/modp-blank.png';
        
        var d = new Date(this.latest);
        // Adjust time to be 15 minutes ago
        //d.setTime(d.getTime() - 900000);
        // Adjust so that minutes is one of 0,15,30 & 45m
        //d.setTime(d.getTime() - (60000 * (d.getUTCMinutes() % 15)));
        // Adjust to required offset - unit = 15 minutes
        d.setTime(d.getTime() + (900000 * offset));
        return  '//modp.' + location.hostname +
                '/observation/' + this.layerName +
                '/' + d.getUTCFullYear() +
                '/' + (1 + d.getUTCMonth()) +
                '/' + d.getUTCDate() +
                '/' + d.getUTCHours() +
                '/' + d.getUTCMinutes() +
                '.png';
    },
    CLASS_NAME: "OpenLayers.Layer.MODPObservation"
});

/**
 * Class: OpenLayers.Layer.MODPForecast
 * 
 * Displays a MODP Forecast layer with support for time travel
 *
 * Inherits from:
 *  - <OpenLayers.Layer.OSM>
 */
OpenLayers.Layer.MODPForecast = OpenLayers.Class(OpenLayers.Layer.Image, {
    layerName: "",
    frameNumber: 0,
    latest: 0,
    displayName: "",
    /**
     * Constructor: OpenLayers.Layer.OSM.LocalMassachuettsMapnik
     *
     * Parameters:
     * @param {String} name
     * @param {undefined} layer
     * @param {undefined} map
     * options - {Object} Hashtable of extra options to tag onto the layer
     */
    initialize: function(name, displayName, layer, latest, map) {
        this.displayName = displayName;
        this.layerName = layer;

        var projection = new OpenLayers.Projection("EPSG:4326");
        var bounds = new OpenLayers.Bounds();
        bounds.extend(new OpenLayers.LonLat(-12.0, 48.0).transform(projection, map.getProjectionObject()));
        bounds.extend(new OpenLayers.LonLat(5.0, 61.0).transform(projection, map.getProjectionObject()));
        var layerSize = new OpenLayers.Size(500, 500);
        this.frameNumber = 0;
        this.latest = latest;
        var url = this.frameUrl(this.frameNumber);
        var newArguments = [name, url, bounds, layerSize, {
                isBaseLayer: false,
                tileOptions: {crossOriginKeyword: null}
            }];
        OpenLayers.Layer.Image.prototype.initialize.apply(this, newArguments);
    },
    /**
     * Select the frame to view
     * @param {type} timeStep
     * @returns {undefined}
     */
    setFrame: function(timeStep) {
        this.frameNumber = Math.max(0, Math.min(13, timeStep));
        this.setUrl(this.frameUrl(this.frameNumber));
    },
    /**
     * Moves a frame by a number of steps
     * @param {type} step
     * @returns {undefined}
     */
    stepFrame: function(step) {
        this.setFrame(this.frameNumber + step);
    },
    /**
     * Sets the current time that represents frame 0. It will also refresh the currently displayed frame so that it's
     * then in sync.
     * @param {type} t
     * @returns {undefined}
     */
    setLatest: function(t) {
        this.latest = t;
        setFrame(this.frameNumber);
    },
    /**
     * Calculates the required url for the feature.
     * 
     * @param {type} offset Frame offset, 0=latest, 10 earliest
     * @returns url
     */
    frameUrl: function(offset) {
        var d = new Date(this.latest);
        // Adjust time to be 15 minutes ago
        //d.setTime(d.getTime() - 900000);
        // Adjust so that minutes is one of 0,15,30 & 45m
        //d.setTime(d.getTime() - (60000 * (d.getUTCMinutes() % 15)));
        // Adjust to required offset - unit = 3 hours
        d.setTime(d.getTime() - (10800000 * offset));
        return  '//modp.' + location.hostname +
                '/forecast/' + this.layerName +
                '/' + d.getUTCFullYear() +
                '/' + (1 + d.getUTCMonth()) +
                '/' + d.getUTCDate() +
                '/' + d.getUTCHours() +
                '/' + d.getUTCMinutes() +
                '.png';
    },
    CLASS_NAME: "OpenLayers.Layer.MODPForecast"
});
