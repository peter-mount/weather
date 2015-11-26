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
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Peter T Mount
 */
@XmlRootElement( name = "Layer" )
@XmlAccessorType( XmlAccessType.PROPERTY )
public class Layer
{

    private String displayName;
    private Service service;

    public Layer()
    {
    }

    @XmlAttribute
    public String getDisplayName()
    {
        return displayName;
    }

    public void setDisplayName( String displayName )
    {
        this.displayName = displayName;
    }

    @XmlElement( name = "Service" )
    public Service getService()
    {
        return service;
    }

    public void setService( Service service )
    {
        this.service = service;
    }

    @Override
    public int hashCode()
    {
        int hash = 7;
        hash = 43 * hash + Objects.hashCode( this.displayName );
        hash = 43 * hash + Objects.hashCode( this.service );
        return hash;
    }

    @Override
    public boolean equals( Object obj )
    {
        if( obj == null || getClass() != obj.getClass() )
        {
            return false;
        }
        final Layer other = (Layer) obj;
        return Objects.equals( this.displayName, other.displayName )
               && Objects.equals( this.service, other.service );
    }

}
