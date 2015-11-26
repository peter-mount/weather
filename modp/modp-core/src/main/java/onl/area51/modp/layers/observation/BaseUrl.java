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
package onl.area51.modp.layers.observation;

import java.util.Objects;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlValue;

/**
 *
 * @author Peter T Mount
 */
@XmlRootElement( name = "BaseUrl" )
@XmlAccessorType( XmlAccessType.PROPERTY )
public class BaseUrl
{

    private String timeFormat;
    private String baseUrl;

    @XmlAttribute( name = "forServiceTimeFormat" )
    public String getTimeFormat()
    {
        return timeFormat;
    }

    public void setTimeFormat( String timeFormat )
    {
        this.timeFormat = timeFormat;
    }

    @XmlValue
    public String getBaseUrl()
    {
        return baseUrl;
    }

    public void setBaseUrl( String baseUrl )
    {
        this.baseUrl = baseUrl;
    }

    @Override
    public int hashCode()
    {
        int hash = 7;
        hash = 89 * hash + Objects.hashCode( this.timeFormat );
        hash = 89 * hash + Objects.hashCode( this.baseUrl );
        return hash;
    }

    @Override
    public boolean equals( Object obj )
    {
        if( obj == null || getClass() != obj.getClass() )
        {
            return false;
        }
        final BaseUrl other = (BaseUrl) obj;
        return Objects.equals( this.timeFormat, other.timeFormat )
               && Objects.equals( this.baseUrl, other.baseUrl );
    }

}
