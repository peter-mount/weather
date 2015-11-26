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
package onl.area51.modp.layers.forecast;

import java.io.Serializable;
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
@XmlRootElement( name = "Service" )
@XmlAccessorType( XmlAccessType.PROPERTY )
public class Service
implements Serializable
{
    private static final long serialVersionUID=1L;

    private String name;
    private String layerName;
    private String imageFormat;
    private Timesteps timesteps;

    @XmlAttribute
    public String getName()
    {
        return name;
    }

    public void setName( String name )
    {
        this.name = name;
    }

    @XmlElement( name = "LayerName" )
    public String getLayerName()
    {
        return layerName;
    }

    public void setLayerName( String layerName )
    {
        this.layerName = layerName;
    }

    @XmlElement( name = "ImageFormat" )
    public String getImageFormat()
    {
        return imageFormat;
    }

    public void setImageFormat( String imageFormat )
    {
        this.imageFormat = imageFormat;
    }

    @XmlElement( name = "Timesteps" )
    public Timesteps getTimesteps()
    {
        return timesteps;
    }

    public void setTimesteps( Timesteps timesteps )
    {
        this.timesteps = timesteps;
    }

    @Override
    public int hashCode()
    {
        int hash = 7;
        hash = 17 * hash + Objects.hashCode( this.name );
        hash = 17 * hash + Objects.hashCode( this.layerName );
        hash = 17 * hash + Objects.hashCode( this.imageFormat );
        hash = 17 * hash + Objects.hashCode( this.timesteps );
        return hash;
    }

    @Override
    public boolean equals( Object obj )
    {
        if( obj == null || getClass() != obj.getClass() )
        {
            return false;
        }
        final Service other = (Service) obj;
        return Objects.equals( this.name, other.name )
               && Objects.equals( this.layerName, other.layerName )
               && Objects.equals( this.imageFormat, other.imageFormat )
               && Objects.equals( this.timesteps, other.timesteps );
    }

}
