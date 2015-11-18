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

import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import onl.iot.common.servlet.AbstractHomeServlet;

/**
 *
 * @author Peter T Mount
 */
@WebServlet( name = "HomeServlet", urlPatterns =
     {
         // The uri's to map
         "/home",
         "/about",
         "/graphs",
         "/faq/",
         // The UK Weather map
         "/map",
         // Satellite image viewer
         "/satellite",
         // Webcam viewer
         "/webcams"
}, initParams =
     {
         // The uri -> tile mapping
         @WebInitParam( name = "/home", value = "homepage" ),
         @WebInitParam( name = "/about", value = "about" ),
         @WebInitParam( name = "/graphs", value = "graphs" ),
         @WebInitParam( name = "/faq/", value = "faq.home" ),
         @WebInitParam( name = "/forecast", value = "forecast" ),
         // The UK Weather map
         @WebInitParam( name = "/map", value = "map.home" ),
         // Satellite viewer
         @WebInitParam( name = "/satellite", value = "satellite.home" ),
         @WebInitParam( name = "/webcams", value = "webcam" )
} )
public class HomeServlet
        extends AbstractHomeServlet
{

}
