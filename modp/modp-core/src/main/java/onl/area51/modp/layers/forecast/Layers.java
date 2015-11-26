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
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Peter T Mount
 */
@XmlRootElement(name = "Layers")
@XmlAccessorType(XmlAccessType.PROPERTY)
public class Layers
        implements Serializable
{

    private static final long serialVersionUID = 1L;
    private String type;
    private BaseUrl baseUrl;
    private final List<Layer> layers = new ArrayList<>();

    public String getType()
    {
        return type;
    }

    @XmlAttribute(name = "type")
    public void setType( String type )
    {
        this.type = type;
    }

    @XmlElement(name = "BaseUrl")
    public BaseUrl getBaseUrl()
    {
        return baseUrl;
    }

    public void setBaseUrl( BaseUrl baseUrl )
    {
        this.baseUrl = baseUrl;
    }

    @XmlElements(
            @XmlElement(name = "Layer", type = Layer.class)
    )
    public List<Layer> getLayers()
    {
        return layers;
    }

    @Override
    public int hashCode()
    {
        int hash = 7;
        hash = 11 * hash + Objects.hashCode( this.baseUrl );
        hash = 11 * hash + Objects.hashCode( this.layers );
        return hash;
    }

    @Override
    public boolean equals( Object obj )
    {
        if( obj == null || getClass() != obj.getClass() ) {
            return false;
        }
        final Layers other = (Layers) obj;
        return Objects.equals( this.baseUrl, other.baseUrl )
               && Objects.equals( this.layers, other.layers );
    }

}
