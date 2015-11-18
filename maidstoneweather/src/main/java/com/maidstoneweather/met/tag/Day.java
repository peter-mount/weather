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
package com.maidstoneweather.met.tag;

import java.util.Calendar;

/**
 *
 * @author Peter T Mount
 */
enum Day
{

    TODAY( 0 ),
    TOMORROW( 1 );
    private final int dateOffset;

    private Day( int dateOffset )
    {
        this.dateOffset = dateOffset;
    }

    public Calendar getCalendar()
    {
        Calendar cal = Calendar.getInstance();
        if( dateOffset != 0 )
        {
            cal.add( Calendar.DAY_OF_MONTH, dateOffset );
        }
        return cal;
    }

    public static Day getDay( String s )
    {
        return s == null ? Day.TODAY : Day.valueOf( s.toUpperCase() );
    }
}
