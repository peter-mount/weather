<%-- 
    Document   : home
    Created on : Jun 2, 2014, 10:36:26 AM
    Author     : Peter T Mount

    Satellite image viewer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<div id="satellite">
    <div id="satellite-inner">
        <div id="satellite-menu">
            <h3>Meteosat 0˚</h3>
            <div id="eumetsat"></div>
            <h3>Met Éireann</h3>
            <div id="metie"></div>
        </div>
        <div id="satelllite-image">
            <div id="sat-image"></div>
            <div id="sat-copy"></div>
        </div>
    </div>
</div>
<script lang="Javascript">
    var year = new Date().getFullYear();
    // Copyright strings for each image type
    var copyr = {
        eumetsat: "Copyright " + year + " <C2><A9> <a href='http://www.eumetsat.int/'>EUMETSAT</a>. All rights reserved.<br/>European Organisation for the Exploitation of Meteorological Satellites",
        metie: "Image provided by <a href='http://www.met.ie/'>Met Éireann</a>"
    };
    var images = {
        // EUMetSat Meteosat 0˚ 
        eumetsat0: ['eumetsat', 'Infrared 3.9 Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_IR039EColor-westernEurope.jpg'],
        eumetsat1: ['eumetsat', 'Infrared 10.8 Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_IR108EColor-westernEurope.jpg'],
        eumetsat2: ['eumetsat', 'Visible 0.6 Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_VIS006EColor-westernEurope.jpg'],
        eumetsat3: ['eumetsat', 'Dust Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-dust-westernEurope.jpg'],
        eumetsat4: ['eumetsat', 'Air Mass Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-airmass-westernEurope.jpg'],
        eumetsat5: ['eumetsat', 'Fog Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-fog-n-westernEurope.jpg'],
        eumetsat6: ['eumetsat', 'Snow Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-Snow-westernEurope.jpg'],
        eumetsat7: ['eumetsat', 'Day Micro Physics Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-Microphysics-westernEurope.jpg'],
        eumetsat8: ['eumetsat', 'RGB Natural Colour Western Europe', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-naturalcolor-westernEurope.jpg'],
        //RGB Composite E-View Segment 4 (UK)
        eumetsat9: ['eumetsat', 'RGB Composite UK', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-12-12-9i-segment4.jpg'],
        //RGB Composite E-View Segment 6 (Southern UK & France)
        eumetsat10: ['eumetsat', 'RGB Composite Southern UK &amp; France', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_RGB-12-12-9i-segment6.jpg'],
        eumetsat11: ['eumetsat', 'Infrared 3.9 Full Disk', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_IR039Color-all.jpg'],
        eumetsat12: ['eumetsat', 'Infrared 10.8 Full Disk', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_IR108Color-all.jpg'],
        eumetsat13: ['eumetsat', 'Visible 0.6 Full Disk', 'http://oiswww.eumetsat.org/IPPS/html/latestImages/EUMETSAT_MSG_VIS006Color-all.jpg'],
        // Met Éireann
        metie0: ['metie', 'UK & Ireland Infra - Red', 'http://www.met.ie/weathermaps/WEB_sat_ir_irl.jpg'],
        metie1: ['metie', 'UK & Ireland Visible', 'http://www.met.ie/weathermaps/WEB_sat_vis_eur.jpg'],
        metie2: ['metie', 'Europe Infra-Red', 'Europe Infra-Red', 'http://www.met.ie/weathermaps/WEB_sat_ir_eur.jpg']
    };

    function showImage(id) {
        $('#sat-image').replaceWith('<div id="sat-image"><h1>'+images[id][1]+'</h1><img src="' + images[id][2] + '" title="' + images[id][1] + '"/></div>');
        $('#sat-copy').replaceWith('<div id="sat-copy">' + copyr[images[id][0]] + '</div>');
    }

    $.each(images, function(i, v) {
        console.info(i);
        $('#' + v[0]).append('<div id="' + i + '">' + v[1] + '</div>');
        $('#' + i).click(function() {
            showImage($(this).attr('id'));
        });
    });
    showImage('eumetsat2');
</script>