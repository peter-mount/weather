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

import com.maidstoneweather.astro.EphemerisManager;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

/**
 *
 * @author Peter T Mount
 */
public class MeteorTag
        extends SimpleTagSupport
{

    private String var;

    public void setVar( String var )
    {
        this.var = var;
    }

    @Override
    public void doTag()
            throws JspException
    {
        getJspContext().
                setAttribute( var, EphemerisManager.INSTANCE.getMeteors() );
    }

}
