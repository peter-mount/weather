<%-- 
    Document   : homepage
    Created on : May 26, 2014, 12:11:06 PM
    Author     : Peter T Mount
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<div class="symbol-box">
    <h2 class="symbol-header">WebCameras</h2>
    <div class="symbol-box">
        <div id="preview"></div>
        <div class="clear"></div>
    </div>
    <h3 id="camera-name" class="symbol-header"></h3>
    <div class="symbol-box">
        <img id="camera" width="640" height="480" onerror="this.src='/images/offline-std.jpg"/>
    </div>
</div>
<p>To change the camera view, just click one of the preview's at the top of the page. The camera's will update themselves automatically every minute.</p>
<script language="javascript">
    var cameras = [
        {
            title: "CAM1 Raspberry Pi Sky/Cloud camera",
            thumbnail: "http://webcam.retep.org/helene/imageThumb.jpg",
            image: "http://webcam.retep.org/helene/image.jpg"
        }, {
            title: "CAM2 Cloud Cover",
            thumbnail: "http://webcam.retep.org/helene/cloud_thumb.jpg",
            image: "http://webcam.retep.org/helene/cloud.jpg"
        }, {
            title: "CAM3 Western Horizon",
            thumbnail: "http://webcam.retep.org/kari/imageThumb.jpg",
            image: "http://webcam.retep.org/kari/image.jpg"
        }, {
            title: "CAM4 Cloud Cover Western Horizon",
            thumbnail: "http://webcam.retep.org/kari/cloud_thumb.jpg",
            image: "http://webcam.retep.org/kari/cloud.jpg"
        }, {
            title: "CAM5 Development Raspberry Pi camera",
            thumbnail: "http://webcam.retep.org/fenrir/imageThumb.jpg",
            image: "http://webcam.retep.org/fenrir/image.jpg"
        }, <%--{
            title: "CAM5 Cloud Cover",
            thumbnail: "http://webcam.retep.org/fenrir/cloud_thumb.jpg",
            image: "http://webcam.retep.org/fenrir/cloud.jpg"
        },--%> {
            title: "CAM6 Front Door Cam",
            thumbnail: "http://webcam.retep.org/prometheus/webcam1_t.jpg",
            image: "http://webcam.retep.org/prometheus/webcam1.jpg"
        }
    ];
    function selectCamera(id) {
        $('#camera-name').text(cameras[id]['title']);
        $('#camera').prop('src', cameras[id]['image'] + '?' + new Date());
    }

    function refreshImage(e) {
        var s = $(e).attr('src');
        var i = s.indexOf('?');
        if (i > 0)
            s = s.substr(0, i);
        s = s + '?' + new Date();
        $(e).prop('src', s);
    }
    function refreshCameras() {
        refreshImage($('#camera'));
        for (var i = 0; i < cameras.length; i++) {
            refreshImage($('#preview-' + i));
        }
        setTimeout(refreshCameras, 60000);
    }

    $(document).ready(function() {
        for (var i = 0; i < cameras.length; i++) {
            var id = 'preview-' + i;
            $('#preview').append($('<img id="' + id + '" class="symbol-box left" width="100" height="75"></img>'));
            id = '#' + id;
            $(id).prop('src', cameras[i]['thumbnail'] + '?' + new Date());
            $(id).prop('title', cameras[i]['title']);
            $(id).on('error', function() {
                $(this).prop('src', '/images/offline-thumb.jpg');
            });
            $(id).on('click', function() {
                selectCamera($(this).attr('id').substr(8));
            });
        }
        selectCamera(0);

        setTimeout(refreshCameras, 60000);
    });
</script>