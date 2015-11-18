/*
 * OpenLayers 2 Layer for using our local tileserver
 */

OpenLayers.Util.OSMLocal = {};

/**
 * Constant: MISSING_TILE_URL
 * {String} URL of image to display for missing tiles
 */
OpenLayers.Util.OSMLocal.MISSING_TILE_URL = "/maps/blank.png";
/**
 * Function: onImageLoadError
 */
OpenLayers.Util.onImageLoadError = function() {
    this.src = OpenLayers.Util.OSMLocal.MISSING_TILE_URL;
};

/**
 * Class: OpenLayers.Layer.OSM.LocalMassachusettsMapnik
 *
 * Inherits from:
 *  - <OpenLayers.Layer.OSM>
 */
OpenLayers.Layer.OpenTransportMaps = OpenLayers.Class(OpenLayers.Layer.OSM, {
    /**
     * Constructor: OpenLayers.Layer.OSM.LocalMassachuettsMapnik
     *
     * Parameters:
     * name - {String}
     * options - {Object} Hashtable of extra options to tag onto the layer
     */
    initialize: function(name, layer, base) {
        OpenLayers.Layer.OSM.prototype.initialize.apply(this, [
            name,
            [
                '//a.tiles.' + location.hostname + '/' + layer + '/${z}/${x}/${y}.png',
                '//b.tiles.' + location.hostname + '/' + layer + '/${z}/${x}/${y}.png',
                '//c.tiles.' + location.hostname + '/' + layer + '/${z}/${x}/${y}.png'
            ],
            {
                numZoomLevels: 19,
                buffer: 0,
                transitionEffect: "resize",
                isBaseLayer: base,
                tileOptions: {crossOriginKeyword: null}
            }]);
    },
    CLASS_NAME: "OpenLayers.Layer.OpenTransportMaps"
});