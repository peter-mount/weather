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

import java.util.Map;
import org.apache.tiles.AttributeContext;
import org.apache.tiles.preparer.ViewPreparer;
import org.apache.tiles.request.Request;

/**
 * ViewPreparer which ensures our stationName is in the template
 * <p>
 * @author Peter T Mount
 */
public class StationInfoPreparer
        implements ViewPreparer
{

    @Override
    public void execute( Request tilesContext, AttributeContext attributeContext )
    {
        Map<String, Object> req = tilesContext.getContext( "request" );
        
        // The station name
        req.put( "stationName",
                 attributeContext.getAttribute( "station" ).
                 toString() );
        
        // Notify tile to include the javascript
        req.put( "includeTimer", true );
    }

}
