<%-- 
    Document   : about
    Created on : Jun 2, 2014, 10:25:39 AM
    Author     : Peter T Mount
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<h1>About the station</h1>
<tiles:insertAttribute name="abstract"/>

<p>
    There are currently three Raspberry PI's running this weather station.
    The first runs the original Mark I station which only updates online once an hour however the other two are part
    of the Mark II station which provides realtime monitoring of the weather.
</p>

<h2>The Mark I Weather Station</h2>
<img class="right symbol-box" style="margin:.2em;" src='/images/station-medium.jpg' title="The original Mark I weather station"/>

<p>The station currently comprises of a Maplin USB Weather station (<a href="http://www.maplin.co.uk/usb-wireless-weather-forecaster-223254" target="_blank">N96FY</a>) which is really a rebadged Watson <a href="http://www.foshk.com/Weather_Professional/WH1081.htm" target="_blank">WH1081</a> unit. The base unit is connected to a <a href="http://www.raspberrypi.org/" target="_blank">Raspberry PI</a> using <a href="http://code.google.com/p/pywws/" target="_blank">pywws</a> to take the measurements. It then uploads the measurements up to this website, <a href="http://wow.metoffice.gov.uk/">Met Office WOW</a>, <a href="http://www.wunderground.com/weatherstation/WXDailyHistory.asp?ID=IKENTMAI6" target="_blank">weatherunderground</a>, <a href="http://openweathermap.org/maps?zoom=12&lat=51.21843&lon=0.51385&layers=BTTTFFT" target="_blank">Open Weather Map</a> and to <a href="http://twitter.com/ME15Weather" target="_blank">Twitter</a>.

<p>The <a href="http://twitter.com/me15weather">@me15weather</a> twitter feed sends a tweet once per hour comprising the current conditions. Sometimes I do post additional weather related tweets, usually if it's a weather warning. <a href="http://twitter.com/me15weather" class="twitter-follow-button"></a>
    <script src="http://platform.twitter.com/widgets.js" type="text/javascript"></SCRIPT></p>

<p>Please Note: Maplin <del>appears to have stopped selling these units in late 2012</del><em>have these units back in stock</em> however they are still available from other outlets online including Amazon and EBay.</p>

<div class='clear'></div>

<h2>The Mark II Weather Station Project</h2>
<p>The Mark II project is to create a weather station from scratch using just components utilising both Raspberry PI's and Arduino's to provide real-time weather recording.</p>

<p>This project is underway and the software &amp; source for this are now available on <a href="https://bitbucket.org/petermount/piweather" target="_blank">Bitbucket</a>.</p>

<p>It's still in beta development stage but this is the software thats now providing both the newer webcam's as well as the sky conditions on this site.</p>

<h2>Articles about this station</h2>
<ul>
    <li><a href="http://blog.retep.org/2012/07/30/installing-a-usb-weather-station-on-a-raspberry-pi-part-1/" target="_blank">Installing a USB Weather Station on a Raspberry PI Part 1</a></li>
    <li><a href="http://blog.retep.org/2012/09/01/installing-a-usb-weather-station-on-a-raspberry-pi-part-2/" target="_blank">Installing a USB Weather Station on a Raspberry PI Part 2</a></li>
    <li><a href="http://blog.retep.org/2013/01/13/setting-up-a-linux-weather-webcam/" target="_blank">Setting up a Linux Weather WebCam</a></li>
    <li> <a href="http://www.theregister.co.uk/2013/03/14/feature_ten_raspberry_pi_projects/" target="_blank">Ten pi-fect projects for your new Raspberry Pi</a> on The Register, we are #6 on Page 3</li>
    <li><a href="https://www.google.com/+MaidstoneweatherKent">https://www.google.com/+MaidstoneweatherKent</a> is also our Google+ page.</li>
</ul>
