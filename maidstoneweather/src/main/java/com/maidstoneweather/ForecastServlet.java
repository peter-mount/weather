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
 */
package com.maidstoneweather;

import java.io.IOException;
import java.time.Instant;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletResponse;
import onl.iot.common.servlet.AbstractServlet;
import onl.iot.common.servlet.ApplicationRequest;
import onl.iot.modp.layers.forecast.ForecastLayerManager;
import onl.iot.modp.layers.forecast.api.Layer;
import onl.iot.modp.layers.forecast.api.Timesteps;
import onl.iot.modp.regforecast.RegionalForecast;
import onl.iot.modp.regforecast.RegionalForecastKey;
import onl.iot.modp.regforecast.RegionalForecastManager;

/**
 *
 * @author Peter T Mount
 */
@WebServlet( name = "ForecastServlet", urlPatterns =
     {
         "/forecast",
         "/forecast/*"
} )
public class ForecastServlet
        extends AbstractServlet
{

    private static final String LAYER = "Total_Cloud_Cover_Precip_Rate_Overlaid";

    @Override
    protected void doGet( ApplicationRequest request )
            throws ServletException,
                   IOException
    {
        Map<String, String> params = request.getParam();
        Map<String, Object> reqScope = request.getRequestScope();

        // Work out the region defaulting to the South East
        RegionalForecastKey area;
        try
        {
            String path = request.getRequest().
                    getPathInfo();
            if( path == null || path.isEmpty() )
            {
                // Default to the South East
                path = "se";
            }
            else
            {
                // Strip leading /
                path = path.substring( 1 );
            }

            area = RegionalForecastKey.valueOf( params.getOrDefault( "region", path ) );
            reqScope.put( "area", area );
        }
        catch( IllegalArgumentException ex )
        {
            request.sendError( HttpServletResponse.SC_NOT_FOUND );
            return;
        }

        // Get the text forecast
        RegionalForecast forecast = RegionalForecastManager.INSTANCE.getRegionalForecast( area );
        reqScope.put( "forecast", forecast );

        // Get the cloud/rain forecast
        reqScope.put( "cloudLayerName", LAYER );

        Layer layer = ForecastLayerManager.INSTANCE.getLayer( LAYER );
        reqScope.put( "cloudLayer", layer );

        Timesteps steps = layer.getService().
                getTimesteps();
        Date time = steps.getDefaultTime();
        reqScope.put( "defaultTime", time );

        Calendar cal = Calendar.getInstance();
        cal.setTime( time );
        reqScope.put( "cloudPath", String.format( "%d/%d/%d/%d",
                                                  cal.get( Calendar.YEAR ),
                                                  cal.get( Calendar.MONTH ) + 1,
                                                  cal.get( Calendar.DAY_OF_MONTH ),
                                                  cal.get( Calendar.HOUR_OF_DAY )
              ) );

        // Start 9pm tonight, so set to 20:59
        cal = Calendar.getInstance();
        cal.set( Calendar.HOUR_OF_DAY, 20 );
        cal.set( Calendar.MINUTE, 59 );
        cal.set( Calendar.SECOND, 0 );
        cal.set( Calendar.MILLISECOND, 0 );
        Instant start = cal.toInstant();

        // End after 9 hours
        cal.add( Calendar.HOUR_OF_DAY, 9 );
        Instant end = cal.toInstant();

        reqScope.put( "cloudImages",
                      steps.getTimesteps().
                      stream().
                      map( s -> s.getOffset() ).
                      filter( offset ->
                              {
                                  Calendar cal1 = Calendar.getInstance();
                                  cal1.setTime( time );
                                  cal1.add( Calendar.HOUR, offset );
                                  Instant now = cal1.toInstant();
                                  return start.isBefore( now ) && now.isBefore( end );
                      } ).
                      map( offset ->
                              {
                                  Calendar now = Calendar.getInstance();
                                  now.setTime( time );
                                  now.add( Calendar.HOUR, offset );

                                  Object ret[] = new Object[2];
                                  ret[0] = now.getTime();
                                  ret[1] = offset;
                                  return ret;
                      } ).
                      collect( Collectors.toList() )
        );

        // Finally select the tile server, stripping any www prefix so our map's go to the right server
        String serverName = request.getRequest().
                getServerName();
        if( serverName.startsWith( "www." ) || serverName.startsWith( "www." ) )
        {
            serverName = serverName.substring( serverName.indexOf( '.' ) + 1 );
        }
        reqScope.put( "serverName", serverName );

        request.renderTile( "forecast" );
    }

}
