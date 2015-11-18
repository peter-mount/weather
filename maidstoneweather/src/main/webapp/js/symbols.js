/*
 * Copyright 2014 Peter T Mount.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * A collection of jQuery/Raphael weather widgets.
 * 
 * Some of these are based on the symbols defined at
 * http://www.metoffice.gov.uk/guide/weather/symbols
 * 
 */

/**
 * Utility to extract a value from a property map, using a default value if not present
 * @param {type} prop property map
 * @param {type} name key
 * @param {type} def default value
 * @returns {propertyDefault.prop}
 */
function propertyDefault(prop, name, def) {
    return (prop !== undefined && prop[name] !== undefined) ? prop[name] : def;
}

/**
 * Ensures a value does not exceed a certain number of decimal places
 * @param {type} val
 * @param {type} dp
 * @returns {undefined}
 */
function fixDecimalPlace(val, dp) {
    if (dp === 0)
        return Math.round(val);
    var d = Math.pow(10, dp === undefined ? 1 : dp);
    return Math.round(val * d) / d;
}

/**
 * Extend Raphael to add a rounded rectangle
 * @param {type} x left
 * @param {type} y top
 * @param {type} w width
 * @param {type} h height
 * @param {type} r1 radius of top left corner, 0 for no rounding
 * @param {type} r2 radius of top right corner, 0 for no rounding
 * @param {type} r3 radius of bottom left corner, 0 for no rounding
 * @param {type} r4 radius of bottom right corner, 0 for no rounding
 * @returns {Raphael.path}
 */
Raphael.fn.roundedRectangle = function(x, y, w, h, r1, r2, r3, r4) {
    var array = [];
    array = array.concat(["M", x, r1 + y, "Q", x, y, x + r1, y]); //A
    array = array.concat(["L", x + w - r2, y, "Q", x + w, y, x + w, y + r2]); //B
    array = array.concat(["L", x + w, y + h - r3, "Q", x + w, y + h, x + w - r3, y + h]); //C
    array = array.concat(["L", x + r4, y + h, "Q", x, y + h, x, y + h - r4, "Z"]); //D

    return this.path(array);
};

Raphael.fn.arc = function(startX, startY, endX, endY, radius1, radius2, angle) {
    var arcSVG = [radius1, radius2, angle, 0, 1, endX, endY].join(' ');
    return this.path('M' + startX + ' ' + startY + " a " + arcSVG);
};

Raphael.fn.circularArc = function(centerX, centerY, radius, startAngle, endAngle) {
    var startX = centerX + radius * Math.cos(startAngle * Math.PI / 180);
    var startY = centerY + radius * Math.sin(startAngle * Math.PI / 180);
    var endX = centerX + radius * Math.cos(endAngle * Math.PI / 180);
    var endY = centerY + radius * Math.sin(endAngle * Math.PI / 180);
    return this.arc(startX, startY, endX - startX, endY - startY, radius, radius, 0);
};

/**
 * Wind Cardinal Direction. Each element represents a direction. North is 0.
 * Each element represents 
 * @type Array Wind Cardinal Direction
 */
var WindCardinalDirection = [
    'N', 'NNW', 'NW', 'WNW', 'W', 'WSW', 'SW', 'SSW',
    'S', 'SSE', 'SE', 'ESE', 'E', 'ENE', 'NE', 'NNE'
];
/**
 * An animated Wind symbol which indicates both Wind Speed and Direction.
 */
var WindDirSymbol = (function() {
    /**
     * An animated Wind symbol which indicates both Wind Speed and Direction.
     * 
     * @param {String} container Container element id
     * @param {boolean} gust If not 0 then this symbols defines Wind Gust rather than Wind Mean
     * @param {type} width of symbol, defaults to 60
     * @param {type} height of symbol, defaults to 60
     * @returns {WindDir} new instance
     */
    function WindDirSymbol(container, props) {
        var elem = $('#' + container);
        var width = elem.width(), height = elem.height();
        this.cx = width >> 1;
        this.cy = height >> 1;

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        // Fill of control
        this.gust = propertyDefault(props, 'gust', false);
        var fill = this.gust ? '#ccc' : '#fff';

        // Radius of control
        var circlerad = Math.floor(Math.min(width, height) / 4);

        this.curVal = 0;
        this.speed = 0;

        this.paper = Raphael(container, width, height);

        this.circle = this.paper.circle(this.cx, this.cy, circlerad).attr("fill", fill).attr("stroke", "#000");
        this.text = this.paper.text(this.cx, this.cy, this.speed).attr("font-size", "10px").attr("fill", "#000");

        var dirr1 = circlerad + 4, dirr2 = dirr1 + 8;
        this.pointer = this.paper.path('M' + (this.cx - 8) + ',' + (this.cy - dirr1) + ',' + (this.cx + 8) + ',' + (this.cy - dirr1) + ',' + this.cx + ',' + (this.cy - dirr2) + 'z').
                attr("stroke", "#000").attr("fill", fill);

        var t = propertyDefault(props, 'label', undefined);
        if (t !== undefined)
            this.paper.text(this.cx, height - 8, t).attr("font-size", "10px").attr("fill", "#000");

        this.setSpeed(0);
    }

    function setAlt() {
        $(this.elem).prop('title', (this.gust ? 'Maxumim gust ' : "Wind ") + this.speed + " mph from the " + WindCardinalDirection[Math.max(0, Math.min(15, Math.floor(this.dir / 22.5)))]);
    }
    ;

    /**
     * Set the wind speed
     * @param {type} speed in mph
     * @returns {undefined}
     */
    WindDirSymbol.prototype.setSpeed = function(speed) {
        this.speed = speed;
        this.text.attr('text', speed);
        setAlt();
    };

    /**
     * Set the wind direction. 0 North, 90 West, 180 South, 270 East etc
     * @param {type} val Wind direction
     * @returns {undefined}
     */
    WindDirSymbol.prototype.setDirection = function(val) {
        // The current value. Correct it into the range 0..360
        var ov = this.curVal;
        while (ov < 0)
            ov += 360;
        while (ov >= 360)
            ov -= 360;
        // Force an immediate transform to the corrected value
        this.pointer.transform(['R', ov, this.cx, this.cy]);

        // Now set the value again in the range 0..360
        this.curVal = Math.max(0, Math.min(360, val));

        // Now modify it so we rotate by the shortest route, e.g. 270 -> 45 we go via north
        var d = Math.abs(this.curVal - ov);
        if (d > 180) {
            if (this.curVal < ov)
                this.curVal += 360;
            else
                this.curVal -= 360;
            d = Math.abs(this.curVal - ov);
        }
        // Animate the rotation
        this.pointer.animate({transform: ['R', this.curVal, this.cx, this.cy]}, 1000 * Math.abs(d) / 180);
        setAlt();
    };

    return WindDirSymbol;
})();

/**
 * UVIndexSymbol - Displays standard warning triangle based on the current UV Index
 */
var UVIndexSymbol = (function() {
    /**
     * UVIndexSymbol - Displays standard warning triangle based on the current UV Index
     * 
     * @param {type} container
     * @returns {UVIndexSymbol}
     */
    function UVIndexSymbol(container, props) {

        var elem = $('#' + container);
        var width = elem.width(), height = elem.height();

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        this.uv = 0;
        this.cx = width >> 1;
        this.cy = height >> 1;
        this.paper = Raphael(container, width, height);

        this.triangle = this.paper.path('M' + (this.cx - 20) + ',' + (this.cy + 13) + ',' + this.cx + ',' + (this.cy - 20) + ',' + (this.cx + 20) + ',' + (this.cy + 13) + ' z').
                attr("stroke", "#000").
                attr("stroke-width", "2").
                attr("fill", '#fff');
        this.text = this.paper.text(this.cx, this.cy, this.uv).attr("font-size", "10px").attr("fill", "#000");
        this.label = this.paper.text(this.cx, this.cy + 20, '').attr("font-size", "10px").attr("fill", "#000");
        this.setUv(0);

        title = propertyDefault(props, 'label', undefined);
        if (title !== undefined)
            this.paper.text(this.cx, this.cy - 26, title).attr("font-size", "10px").attr("fill", "#000");
    }

    var uvIndexLevel = [
        ['#4db611', "Low", "None. You can safely stay outside."],
        ['#f7e900', 'Moderate', 'Take care during midday hours and do not spend too much time in the sun unprotected.'],
        ['#f57500', 'High', 'Seek shade during midday hours, cover up and wear sunscreen.'],
        ['#db0020', 'Very high', 'Spend time in the shade between 11 and 3. Shirt, sunscreen and hat essential.'],
        ['#aa84de', 'Extreme', 'Avoid being outside during midday hours. Shirt, sunscreen and hat essential.']
    ];
    var uvIndexLookup = [0, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 4];

    function lookup(uv) {
        return uvIndexLevel[uvIndexLookup[Math.max(0, Math.min(11, uv))]];
    }

    /**
     * Set the observed UV idex
     * @param {type} uv UV Index
     * @returns {undefined}
     */
    UVIndexSymbol.prototype.setUv = function(uv) {
        this.uv = Math.ceil(uv);
        var v = lookup(this.uv);
        this.text.attr('text', this.uv).attr("font-size", this.uv < 10 ? "12px" : "10px");
        this.triangle.attr('fill', v[0]);
        this.label.attr('text', v[1]);
        $(this.elem).prop("title", v[2]);
    };

    /**
     * Returns the current warning text that appears below the symbol for the current UV Index
     * @returns String
     */
    UVIndexSymbol.prototype.getLevel = function() {
        return lookup(this.uv)[1];
    };

    /**
     * Returns the Safety advice for the current UV Index
     * @returns String
     */
    UVIndexSymbol.prototype.getWarning = function() {
        return lookup(this.uv)[2];
    };

    return UVIndexSymbol;
})();

/**
 * A customisable vertical Ruler
 * @type VerticalRuler
 */
var VerticalRuler = (function() {
    function VerticalRuler(paper, x, y, w, h, props) {
        this.rmin = Math.min(props['min'], props['max']);
        this.rmax = Math.max(props['min'], props['max']);
        var rstep = propertyDefault(props, 'step', 1);

        var rr = x + w - 1;
        this.rs = h / (this.rmax - this.rmin);
        this.yz = y + h;

        // Ruler colour & stroke width
        var rcol = propertyDefault(props, 'ruler-colour', '#666');
        var rsw = propertyDefault(props, 'ruler-thickness', 2);

        // Text colour & font size
        var tcol = propertyDefault(props, 'text-colour', '#666');
        var fsize = propertyDefault(props, 'font-size', 10);

        // Major tick & label positions
        var major = propertyDefault(props, 'major', (this.rmax - this.rmin) / 10);

        // Minor tick is optional
        var minor = props['minor'];

        // The ruler graphics
        var yc = rsw / 2; // Correct vertical line by half stroke-width else we'll see a step
        var ar = ['M', rr, y - yc, 'L', rr, this.yz + yc];
        for (var t = this.rmin; t <= this.rmax; t += rstep) {
            var ty = this.getY(t);//this.yz - (this.rs * (t - rmin));

            // tick width
            var w = 5;
            if (minor !== undefined && minor !== 0 && (t % minor) === 0)
                w = 10;
            if ((t % major) === 0) {
                w = 15;
                paper.text(rr - 17, ty, t).attr('text-anchor', 'end').attr('font-size', fsize).attr('fill', tcol);
            }

            ar = ar.concat(['M', rr, ty, 'L', rr - w, ty]);
        }
        paper.path(ar).attr("stroke", rcol).attr('fill', rcol).attr('stroke-width', rsw);
    }

    /**
     * The minimum value of this Ruler
     * @returns {Number}
     */
    VerticalRuler.prototype.getMin = function() {
        return this.rmin;
    };

    /**
     * The maximum value of this Ruler
     * @returns {Number}
     */
    VerticalRuler.prototype.getMax = function() {
        return this.rmax;
    };

    /**
     * Adjusts the value so that it's within the rulers bounds
     * @param {type} val Value
     * @returns {Number}
     */
    VerticalRuler.prototype.fitInBounds = function(val) {
        return Math.max(this.rmin, Math.min(this.rmax, val));
    };

    /**
     * Returns the y coordinate of a value to match that of the ruler
     * @param {type} val Value
     * @returns {Number}
     */
    VerticalRuler.prototype.getY = function(val) {
        return this.yz - (this.rs * (this.fitInBounds(val) - this.rmin));
    };

    /**
     * Returns the height from the value on the ruler and the bottom
     * @param {type} val Value
     * @returns {Number}
     */
    VerticalRuler.prototype.getHeight = function(val) {
        return this.getY(this.rmin) - this.getY(val);
    };

    /**
     * Returns the animation duration to move between two values
     * @param {type} start value
     * @param {type} end value
     * @returns {Number} speed in ms
     */
    VerticalRuler.prototype.animSpeed = function(start, end) {
        if (start === undefined)
            start = this.rmin;
        return 2000 * Math.abs(this.fitInBounds(start) - this.fitInBounds(end)) / (this.rmax - this.rmin);
    };

    /**
     * Animates a column who's base is at the minimum value which will move from an old to a new value.
     * 
     * The animation speed is proportionate to the amount of change. Going from min to max will take 2 seconds.
     * 
     * @param {type} col Column to animate
     * @param {type} oldVal old value
     * @param {type} newVal new value
     * @returns {Number} the new corrected Value
     */
    VerticalRuler.prototype.animateColumn = function(col, oldVal, newVal) {
        col.animate({'y': this.getY(newVal), 'height': this.getHeight(newVal)}, this.animSpeed(oldVal, newVal));
        return this.fitInBounds(newVal);
    };

    /**
     * Animates a rect by moving it's Y coordinate from an old to a new value.
     * 
     * Usually the rect is 1 pixel high - e.g. the min/max markers in Thermometer uses this.
     * 
     * The animation speed is proportionate to the amount of change. Going from min to max will take 2 seconds.
     * 
     * @param {type} col Column to animate
     * @param {type} oldVal old value
     * @param {type} newVal new value
     * @returns {Number} the new corrected Value
     */
    VerticalRuler.prototype.animateY = function(col, oldVal, newVal) {
        col.animate({'y': this.getY(newVal)}, this.animSpeed(oldVal, newVal));
        return this.fitInBounds(newVal);
    };

    /**
     * Animates a path by translating it from the current to new values.
     * 
     * The animation speed is proportionate to the amount of change. Going from min to max will take 2 seconds.
     * 
     * @param {type} col Column to animate
     * @param {type} oldVal old value
     * @param {type} newVal new value
     * @returns {Number} the new corrected Value
     */
    VerticalRuler.prototype.animatePath = function(col, oldVal, newVal) {
        col.animate({transform: ['T', 0, this.getY(newVal) - this.getY(this.rmin)]}, this.animSpeed(oldVal, newVal));
        return this.fitInBounds(newVal);
    };

    return VerticalRuler;
})();

/**
 * A simple Thermometer which is capable of displaying temperatures between -10..40
 * @param {type} container a div width 80, height 200 is best
 * @returns {Thermometer}
 */
var Thermometer = (function() {
    function Thermometer(container, props) {
        // The displayed temperature
        var minTemp = propertyDefault(props, 'min', -10);
        var maxTemp = propertyDefault(props, 'max', 40);
        this.temp = minTemp;

        var elem = $('#' + container);
        var width = elem.width();
        var height = elem.height();
        var cx = width >> 1;
        var paper = Raphael(container, width, height);

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        // Tube width. tb is half that to give us a nice bulb ends
        var tw = 18, tb = tw >> 1;
        // Mercury base
        var mercy = 2 + tb;
        var merch = height - 15 - tb;

        var h = merch - 10;

        // Glass colour & thickness
        var gc = propertyDefault(props, 'glass-colour', '#666');
        var gw = propertyDefault(props, 'glass-thickness', 2);
        // 'vacuum' colour - where no mercury exists
        var vc = propertyDefault(props, 'vacuum-colour', '#ccc');
        // 'mercury' colour
        var mc = propertyDefault(props, 'mercury-colour', '#c4b600');

        // Text colour & font size
        var tc = propertyDefault(props, 'text-colour', '#000');
        var ts = propertyDefault(props, 'font-size', 12);

        this.ruler = new VerticalRuler(paper, 0, mercy, cx - 5, h, {
            min: minTemp, max: maxTemp, major: 10, minor: 5,
            // Pass on ruler setings
            'text-colour': propertyDefault(props, 'ruler-text-colour', undefined),
            'font-size': propertyDefault(props, 'ruler-font-size', undefined),
            'ruler-colour': propertyDefault(props, 'ruler-colour', undefined),
            'ruler-thickness': propertyDefault(props, 'ruler-thickness', undefined)
        });

        // The tube glass
        paper.roundedRectangle(cx, 2, tw, height - 15, tb, tb, tb, tb).
                attr('stroke', gc).attr('fill', vc).attr('stroke-width', gw);

        // The "mercury" in the thermometer default to min temp
        this.merc = paper.rect(cx + 1.5, this.ruler.getY(-10), tw - 3, 1).attr('stroke', mc).attr('fill', mc);

        // The tube bottom is solid. After the mercury so it's above, then when -10 we show nothing
        paper.roundedRectangle(cx, 2 + merch, tw, tb, 0, 0, tb, tb).
                attr('stroke', gc).attr('fill', gc).attr('stroke-width', gw);

        this.text = paper.text(cx, height - 5, '0°C').attr('font-size', ts).attr('fill', tc);

        // Min/Max mode?
        this.minmax = propertyDefault(props, 'minmax', false);
        if (this.minmax) {
            var ms = propertyDefault(props, 'ruler-thickness', gw);
            var mc = propertyDefault(props, 'min-colour', '#00f');
            var y = this.ruler.getY(minTemp);
            this.minLine = paper.rect(cx - 4.5, y, 3.5, 1).
                    attr('stroke', mc).attr('fill', mc).attr('stroke-width', ms);

            mc = propertyDefault(props, 'max-colour', '#f00');
            this.maxLine = paper.rect(cx - 4.5, y, 3.5, 1).
                    attr('stroke', mc).attr('fill', mc).attr('stroke-width', ms);
        }
    }

    /**
     * Set the temperature to display.
     * @param {type} temp Temperature in celsius
     * @returns {undefined}
     */
    Thermometer.prototype.setTemp = function(temp) {
        this.text.attr('text', fixDecimalPlace(temp) + '°C');
        this.temp = this.ruler.animateColumn(this.merc, this.temp, temp);
        if (this.minmax) {
            this.minVal = this.ruler.animateY(this.minLine, this.minVal, this.minVal === undefined ? this.temp : Math.min(this.minVal, this.temp));
            this.maxVal = this.ruler.animateY(this.maxLine, this.maxVal, this.maxVal === undefined ? this.temp : Math.max(this.maxVal, this.temp));
        }
    };

    /**
     * Set the minimum temperature display. Does nothing if minmax mode is disabled
     * @param {type} temp
     * @returns {undefined}
     */
    Thermometer.prototype.setMinTemp = function(temp) {
        if (this.minmax) {
            this.minVal = this.ruler.animateY(this.minLine, this.minVal, temp);
        }
    };

    /**
     * Set the maximum temperature display. Does nothing if minmax mode is disabled
     * @param {type} temp
     * @returns {undefined}
     */
    Thermometer.prototype.setMaxTemp = function(temp) {
        if (this.minmax) {
            this.maxVal = this.ruler.animateY(this.maxLine, this.maxVal, temp);
        }
    };

    return Thermometer;
})();

/**
 * A RainGauge
 * @type Function|_L409.RainGauge
 */
var RainGauge = (function() {

    /**
     * 
     * @param {type} container
     * @param {type} gaugeCapacity in mm, usually 10, 50 or 500
     * @param {type} props Properties
     * @returns {RainGauge}
     */
    function RainGauge(container, gaugeCapacity, props) {
        this.level = 0;

        var capacity = gaugeCapacity;

        var elem = $('#' + container);
        var width = elem.width();
        var height = elem.height();
        var cx = width >> 1;
        var paper = Raphael(container, width, height);

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        // Tube width
        var tw = 23;

        // Mercury base
        var mercy = 8;
        var merch = height - mercy - 22;

        var st = Math.floor(capacity / 5) / 10;
        var mat = 10 * st, mit = 5 * st;
        if (capacity === 10) {
            st = 0.25;
            mat = 1;
            mit = 0;
        } else if (capacity === 5) {
            st = 0.125;
            mat = 0.5;
            mit = 0;
        }
        else if (capacity === 1) {
            st = 0.025;
            mat = 0.1;
            mit = 0;
        }

        this.ruler = new VerticalRuler(paper, 0, mercy, cx - 5, merch, {
            min: 0, max: capacity,
            step: st, major: mat, minor: mit,
            // Pass on ruler setings
            'text-colour': propertyDefault(props, 'ruler-text-colour', undefined),
            'font-size': propertyDefault(props, 'ruler-font-size', undefined),
            'ruler-colour': propertyDefault(props, 'ruler-colour', undefined),
            'ruler-thickness': propertyDefault(props, 'ruler-thickness', undefined)
        });

        // Glass colour & thickness
        var gc = propertyDefault(props, 'glass-colour', '#666');
        var gw = propertyDefault(props, 'glass-thickness', 2);
        // 'air' colour - where no water exists
        var ac = propertyDefault(props, 'air-colour', '#ccc');
        // 'water' colour
        var wc = propertyDefault(props, 'water-colour', '#369');

        // Text colour & font size
        var tc = propertyDefault(props, 'text-colour', '#000');
        var ts = propertyDefault(props, 'font-size', 12);

        // The tube glass
        paper.rect(cx, mercy, tw, merch).
                attr("stroke", gc).attr('fill', ac).attr('stroke-width', gw);
        // The tube is open at the top
        paper.path(['M', cx + 1, mercy, 'L', cx + tw - 1, mercy]).
                attr("stroke", ac).attr('fill', ac).attr('stroke-width', gw);

        // The water level when empty
        this.water = paper.rect(cx + 1.5, this.ruler.getY(0), tw - 3, 1).attr('stroke', wc).attr('fill', wc);

        // The tube bottom is solid. After water level as when empty we show nothing
        paper.rect(cx, mercy + merch, tw, 4).
                attr("stroke", gc).attr('fill', gc).attr('stroke-width', gw);

        // The 'water', defaulting to 0
        this.text = paper.text(cx, height - 5, '0mm').attr('font-size', ts).attr('fill', tc);
    }

    /**
     * Set the temperature to display. This will enforce the range -10..40 of the display
     * @param {type} newLevel Temperature in celsius
     * @returns {undefined}
     */
    RainGauge.prototype.setLevel = function(newLevel) {
        this.text.attr('text', fixDecimalPlace(newLevel) + 'mm');
        this.level = this.ruler.animateColumn(this.water, this.level, newLevel);
    };

    return RainGauge;
})();

/**
 * Amp Meter style dial
 * 
 * @type AmpMeter
 */
var AmpMeter = (function() {

    /**
     * 
     * @param {type} container
     * @param {type} props
     * @returns {_L606.AmpMeter}
     */
    function AmpMeter(container, props) {
        this.curVal = this.rmin = propertyDefault(props, 'min', 0);
        this.rmax = propertyDefault(props, 'max', 100);
        this.range = (this.rmax - this.rmin);

        var elem = $('#' + container);
        var width = elem.width();
        var height = elem.height();
        this.cx = width >> 1;
        this.cy = height - 8;
        var paper = Raphael(container, width, height);

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        this.unit = propertyDefault(props, 'unit', '');

        // Dial text
        var dts = propertyDefault(props, 'legend-size', 7);
        var dtc = propertyDefault(props, 'legend-colour', '#555');

        var bc = propertyDefault(props, 'border-colour', '#888');
        var bw = propertyDefault(props, 'border-width', 1);
        paper.roundedRectangle(0, 0, width, height, 10, 10, 10, 10).
                attr('stroke', bc).
                attr('stroke-width', bw).
                attr('fill', propertyDefault(props, 'background', '#fff'));

        // The dial
        // Radius of dial, must have room for text
        var cr = Math.min(this.cx - 20, this.cy - 20);

        var startAngle = -160, endAngle = -20;
        var startX = this.cx + cr * Math.cos(startAngle * Math.PI / 180);
        var startY = this.cy + cr * Math.sin(startAngle * Math.PI / 180);
        var endX = this.cx + cr * Math.cos(endAngle * Math.PI / 180);
        var endY = this.cy + cr * Math.sin(endAngle * Math.PI / 180);
        var ar = ['M', startX, startY, 'a', cr, cr, 0, 0, 1, endX - startX, endY - startY];

        this.dr = (endAngle - startAngle) / this.range;
        var st = this.range / 20;
        var ts = this.range / 5;
        for (var v = this.rmin; v <= this.rmax; v += st) {
            var a = startAngle + ((v - this.rmin) * this.dr);
            var cr1 = cr + ((v % ts === 0) ? 10 : 5);
            var c = Math.cos(a * Math.PI / 180), s = Math.sin(a * Math.PI / 180);
            var x = this.cx + cr * c, x1 = this.cx + cr1 * c;
            var y = this.cy + cr * s, y1 = this.cy + cr1 * s;
            ar = ar.concat(['M', x, y, 'L', x1, y1]);
            if (v % ts === 0) {
                cr1 += 5;
                x1 = this.cx + cr1 * c;
                y1 = this.cy + cr1 * s;
                paper.text(x1, y1, v).
                        attr('font-size', dts).attr('fill', dtc).
                        attr({transform: 'r' + (a + 90)});

            }
        }
        paper.path(ar).attr('stroke', dtc);

        // The pointer set to the minimum value
        var ptc = propertyDefault(props, 'pointer-colour', '#f00');
        cr1 = cr + 15;
        this.pointer = paper.path(['M', this.cx, this.cy,
            this.cx + cr1 * Math.cos(startAngle * Math.PI / 180),
            this.cy + cr1 * Math.sin(startAngle * Math.PI / 180)]).
                attr('stroke', ptc).
                attr('stroke-width', propertyDefault(props, 'pointer-width', 1)).
                attr('fill', ptc);

        // Display value
        this.text = paper.text(this.cx, this.cy - 15, '0' + this.unit).
                attr('font-size', propertyDefault(props, 'value-size', 10)).
                attr('fill', propertyDefault(props, 'value-colour', '#000'));

        // Label & the base covering of the meter
        paper.roundedRectangle(0, height - 15, width, 15, 0, 0, 10, 10).
                attr('stroke', bc).
                attr('stroke-width', bw).
                attr('fill', propertyDefault(props, 'cover-colour', '#fc0'));
        paper.text(this.cx, height - 8, propertyDefault(props, 'label', '')).
                attr('fill', propertyDefault(props, 'label-colour', '#000')).
                attr('font-size', propertyDefault(props, 'label-size', 10));
    }

    /**
     * Adjusts the value so that it's within the meter's bounds
     * @param {type} val Value
     * @returns {Number}
     */
    AmpMeter.prototype.fitInBounds = function(val) {
        return Math.max(this.rmin, Math.min(this.rmax, val));
    };

    /**
     * Returns the animation duration to move between two values
     * @param {type} start value
     * @param {type} end value
     * @returns {Number} speed in ms
     */
    AmpMeter.prototype.animSpeed = function(start, end) {
        if (start === undefined)
            start = this.rmin;
        return 2000 * Math.abs(this.fitInBounds(start) - this.fitInBounds(end)) / this.range;
    };

    /**
     * Set's the dial's value and animates the pointer moving to the new value
     * @param {type} val
     * @returns {undefined}
     */
    AmpMeter.prototype.setValue = function(val) {
        this.text.attr('text', fixDecimalPlace(val) + this.unit);
        var ov = this.curVal;
        this.curVal = this.fitInBounds(val);
        this.pointer.animate({
            transform: ['r', this.dr * (this.curVal - this.rmin), this.cx, this.cy]
        }, this.animSpeed(ov, val));
    };

    return AmpMeter;
})();

/**
 * A pressure dial style meter
 * @type DialMeter
 */
var DialMeter = (function() {

    function DialMeter(container, props) {

        this.curVal = this.rmin = propertyDefault(props, 'min', 0);
        this.rmax = propertyDefault(props, 'max', 100);
        this.range = this.rmax - this.rmin;

        var elem = $('#' + container);
        var width = elem.width(), height = elem.height();
        this.cx = width >> 1;
        this.cy = height >> 1;
        var cr = Math.min(this.cx, this.cy) - 1;
        var paper = Raphael(container, width, height);

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        this.unit = propertyDefault(props, 'unit', '');

        // Dial text
        var dts = propertyDefault(props, 'legend-size', 7);
        var dtc = propertyDefault(props, 'legend-colour', '#555');

        // Outer dial
        paper.circle(this.cx, this.cy, cr).
                attr('stroke', propertyDefault(props, 'dial-border', '#000')).
                attr('fill', propertyDefault(props, 'dial-fill', '#fff')).
                attr('stroke-width', propertyDefault(props, 'dial-width', 2));

        var startAngle = -230, endAngle = 50;
        this.dr = (endAngle - startAngle) / this.range;

        // Inner dial
        var cc = propertyDefault(props, 'dial-fill', '#555');
        var cw = propertyDefault(props, 'dial-width', 2);
        cr -= 8;
        paper.circularArc(this.cx, this.cy, cr, startAngle, -90).attr('stroke', cc).attr('stroke-width', cw);
        paper.circularArc(this.cx, this.cy, cr, -90, endAngle).attr('stroke', cc).attr('stroke-width', cw);

        // Dial ticks & labels
        var st = this.range / propertyDefault(props, 'steps', 50);
        var ts = this.range / propertyDefault(props, 'ticks', 5);

        // Optioonal
        var ms = propertyDefault(props, 'minor', undefined);
        if (ms !== undefined)
            ms = this.range / ms;

        var ar = [];
        for (var v = this.rmin; v <= this.rmax; v += st) {
            var a = startAngle + ((v - this.rmin) * this.dr);
            var cs = (v % ts === 0) ? 6 : ((ms !== undefined && (v % ms === 0)) ? 4 : 2);
            var cr1 = cr + cs, cr2 = cr - cs;
            var c = Math.cos(a * Math.PI / 180), s = Math.sin(a * Math.PI / 180);
            var x = this.cx + cr1 * c, x1 = this.cx + cr2 * c;
            var y = this.cy + cr1 * s, y1 = this.cy + cr2 * s;
            ar = ar.concat(['M', x, y, 'L', x1, y1]);
            if (v % ts === 0) {
                cr2 -= 5;
                x1 = this.cx + cr2 * c;
                y1 = this.cy + cr2 * s;
                paper.text(x1, y1, v).
                        attr('font-size', dts).attr('fill', dtc).
                        attr({transform: 'r' + (a + 90)});
            }
        }
        paper.path(ar).attr('stroke', dtc);

        // label in upper half
        this.text = paper.text(this.cx, this.cy - 15, propertyDefault(props, 'label', '')).
                attr('font-size', dts).attr('fill', dtc);

        // The pointer set to the minimum value
        var ptc = propertyDefault(props, 'pointer-colour', cc);
        this.pointer = paper.path([
            'M', this.cx, this.cy - 3,
            'L',
            this.cx + cr1 * Math.cos(startAngle * Math.PI / 180),
            this.cy + cr1 * Math.sin(startAngle * Math.PI / 180),
            'L', this.cx + 3, this.cy,
            'Z'
        ]).attr('stroke', ptc).attr('fill', ptc);

        // Cover over the pointer center
        paper.circle(this.cx, this.cy, propertyDefault(props, 'cover-size', 5)).
                attr('stroke', propertyDefault(props, 'cover-colour', cc)).
                attr('stroke-width', propertyDefault(props, 'cover-border', 1)).
                attr('fill', propertyDefault(props, 'cover-colour', cc));

        // Display value & label
        var ls = propertyDefault(props, 'value-size', 10), lc = propertyDefault(props, 'value-colour', '#000');
        this.text = paper.text(this.cx, height - 8 - ls, '0' + this.unit).attr('font-size', ls).attr('fill', lc);
    }

    /**
     * Adjusts the value so that it's within the meter's bounds
     * @param {type} val Value
     * @returns {Number}
     */
    DialMeter.prototype.fitInBounds = function(val) {
        return Math.max(this.rmin, Math.min(this.rmax, val));
    };

    /**
     * Returns the animation duration to move between two values
     * @param {type} start value
     * @param {type} end value
     * @returns {Number} speed in ms
     */
    DialMeter.prototype.animSpeed = function(start, end) {
        if (start === undefined)
            start = this.rmin;
        return 2000 * Math.abs(this.fitInBounds(start) - this.fitInBounds(end)) / this.range;
    };

    /**
     * Set's the dial's value and animates the pointer moving to the new value
     * @param {type} val
     * @returns {undefined}
     */
    DialMeter.prototype.setValue = function(val) {
        this.text.attr('text', fixDecimalPlace(val) + this.unit);
        var ov = this.curVal;
        this.curVal = this.fitInBounds(val);
        this.pointer.animate({
            transform: ['r', this.dr * (this.curVal - this.rmin), this.cx, this.cy]
        }, this.animSpeed(ov, val));
    };

    return DialMeter;
})();

/**
 * Cloud base widget to show calculated hight of clouds
 * @type CloudBase
 */
var CloudBase = (function() {

    function CloudBase(container, props) {

        var rmin = propertyDefault(props, 'min', 0);
        var rmax = propertyDefault(props, 'max', 5000);
        this.curVal = rmin;

        this.unit = propertyDefault(props, 'unit', 'ft');

        var elem = $('#' + container);
        var width = elem.width(), height = elem.height();
        var cx = width >> 1;
        var cy = height >> 1;
        var paper = Raphael(container, width, height);

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        // 17 here to allow room for the cloud at the max value
        var mercy = 17, merch = height - mercy - 17;
        this.ruler = new VerticalRuler(paper, 0, mercy, cx - 5, merch, {
            min: rmin, max: rmax,
            step: 200, major: 1000,
            // Pass on ruler setings
            'text-colour': propertyDefault(props, 'text-colour', undefined),
            'font-size': propertyDefault(props, 'font-size', undefined),
            'ruler-colour': propertyDefault(props, 'ruler-colour', undefined),
            'ruler-thickness': propertyDefault(props, 'ruler-thickness', undefined)
        });

        // Extend base line to represent the ground
        var rcol = propertyDefault(props, 'ruler-colour', '#666');
        var rsw = propertyDefault(props, 'ruler-thickness', 2);
        var y = this.ruler.getY(0);
        paper.path(['M', cx - 5, y, 'L', cx + 40, y]).
                attr("stroke", rcol).attr('fill', rcol).attr('stroke-width', rsw);

        // Now the moving cloud icon
        var cs = propertyDefault(props, 'cloud-border', '#666');
        var cf = propertyDefault(props, 'cloud-colour', '#ccc');
        var cw = propertyDefault(props, 'cloud-thickness', 1);
        //start with the pointer then the cloud itself
        this.pointer = paper.path(['M', cx, y - 4, 'L', cx - 4, y, 'L', cx, y + 4, 'M', cx - 4, y, 'L', cx + 5, y]).
                attr("stroke", cs).attr('stroke-width', cw);
        // Now the cloud ;-)
        this.cloud = paper.path("m" + (cx + 30) + "," + (y - 9.5) + "c0.019-0.195,0.03-0.392,0.03-0.591c0-3.452-2.798-6.25-6.25-6.25c-2.679,0-4.958,1.689-5.847,4.059c-0.589-0.646-1.429-1.059-2.372-1.059c-1.778,0-3.219,1.441-3.219,3.219c0,0.21,0.023,0.415,0.062,0.613c-2.372,0.391-4.187,2.436-4.187,4.918c0,2.762,2.239,5,5,5h15.875c2.762,0,5-2.238,5-5C28.438,16.362,26.672,14.332,24.345z").
                attr("stroke", cs).attr('stroke-width', cw).attr('fill', cf);


        this.text = paper.text(cx, height - 5, '0' + this.unit).
                attr('font-size', propertyDefault(props, 'value-size', 12)).
                attr('fill', propertyDefault(props, 'value-colour', '#000'));

    }

    /**
     * Set's the cloud base altitude and animates the pointer and cloud moving to the new value
     * @param {type} val
     * @returns {undefined}
     */
    CloudBase.prototype.setValue = function(val) {
        this.text.attr('text', Math.round(val) + this.unit);
        this.ruler.animatePath(this.cloud, this.curVal, val);
        this.ruler.animatePath(this.pointer, this.curVal, val);
        this.curVal = this.ruler.fitInBounds(val);
    };

    return CloudBase;
})();

/**
 * A Compass who's needle can be set to any direction. When moving the needle we move it in the shortest
 * direction to the destination.
 * 
 * @type Compass
 */
var Compass = (function() {

    function Compass(container, props) {
        this.curVal = 0;

        var elem = $('#' + container);
        var width = elem.width();
        var height = elem.height();
        this.cx = width >> 1;
        this.cy = height >> 1;
        var cr = Math.min(this.cx, this.cy) - 1;
        var paper = Raphael(container, width, height);

        // Optional title
        var title = propertyDefault(props, 'title', undefined);
        if (title !== undefined)
            $(elem).prop('title', title);

        // Glass colour & thickness
        var gb = propertyDefault(props, 'glass-colour', '#666');
        var gc = propertyDefault(props, 'glass-colour', '#fff');
        var gw = propertyDefault(props, 'glass-thickness', 2);

        // The main compass glass
        paper.circle(this.cx, this.cy, cr).attr('stroke', gb).attr('fill', gc).attr('stroke-width', gw);

        // The compass points
        cr -= gw;
        var ar = [];
        var dp = 360 / WindCardinalDirection.length, tr = Math.PI / 180;
        for (var i = 0, j = 0; i < WindCardinalDirection.length; i++, j += dp) {
            var c = -Math.cos(j * tr), s = -Math.sin(j * tr);
            var cr1 = cr - (i % 2 === 0 ? 10 : 5);
            ar = ar.concat(['M', this.cx + cr * s, this.cy + cr * c, 'L', this.cx + cr1 * s, this.cy + cr1 * c]);
            if (i % 2 === 0) {
                cr1 = cr - 15;
                var t = paper.text(this.cx + cr1 * s, this.cy + cr1 * c, WindCardinalDirection[i]).
                        attr('font-size', 8).attr('fill', gb);
                if (i % 4 !== 0)
                    t.attr({transform: ['r', j + (i < 8 ? -90 : 90)]});
            }
        }
        paper.path(ar).attr('stroke', gb).attr('fill', gb).attr('stroke-width', gw);

        // Pointer default to north
        var ptc = propertyDefault(props, 'pointer-colour', '#666');
        this.pointer = paper.path(['M', this.cx, 6, 'L', this.cx - 3, this.cy, 'L', this.cx + 3, this.cy, 'Z']).attr('stroke', ptc).attr('fill', ptc);

        // Pointer cover
        paper.circle(this.cx, this.cy, propertyDefault(props, 'cover-size', 7.5)).
                attr('stroke', propertyDefault(props, 'cover-colour', ptc)).
                attr('stroke-width', propertyDefault(props, 'cover-border', 1)).
                attr('fill', propertyDefault(props, 'cover-colour', ptc));
    }

    /**
     * Rotate the compass to point to the required direction using the shortest route.
     * 
     * The speed is adjusted so that it takes 2 seconds to do one revolution
     * @param {type} val
     * @returns {undefined}
     */
    Compass.prototype.setDirection = function(val) {
        // The current value. Correct it into the range 0..360
        var ov = this.curVal;
        while (ov < 0)
            ov += 360;
        while (ov >= 360)
            ov -= 360;
        // Force an immediate transform to the corrected value
        this.pointer.transform(['R', ov, this.cx, this.cy]);

        // Now set the value again in the range 0..360
        this.curVal = Math.max(0, Math.min(360, val));

        // Now modify it so we rotate by the shortest route, e.g. 270 -> 45 we go via north
        var d = Math.abs(this.curVal - ov);
        if (d > 180) {
            if (this.curVal < ov)
                this.curVal += 360;
            else
                this.curVal -= 360;
            d = Math.abs(this.curVal - ov);
        }

        // Animate the rotation
        this.pointer.animate({transform: ['R', this.curVal, this.cx, this.cy]}, 1000 * Math.abs(d) / 180);
    };

    return Compass;
})();
