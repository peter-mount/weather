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
import java.util.Date;
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
@XmlRootElement(name = "Timesteps")
@XmlAccessorType(XmlAccessType.PROPERTY)
public class Timesteps
        implements Serializable
{

    private static final long serialVersionUID = 1L;

    private String defaultTime;
    private final List<Timestep> timesteps = new ArrayList<>();

    public Timesteps()
    {
    }

    public Timesteps( String defaultTime )
    {
        this.defaultTime = defaultTime;
    }

    @XmlAttribute()
    public String getDefaultTime()
    {
        return defaultTime;
    }

    public void setDefaultTime( String defaultTime )
    {
        this.defaultTime = defaultTime;
    }

    @XmlElements(
            @XmlElement(name = "Timestep", type = Timestep.class)
    )
    public List<Timestep> getTimesteps()
    {
        return timesteps;
    }

    @Override
    public int hashCode()
    {
        int hash = 7;
        hash = 17 * hash + Objects.hashCode( this.defaultTime );
        hash = 17 * hash + Objects.hashCode( this.timesteps );
        return hash;
    }

    @Override
    public boolean equals( Object obj )
    {
        if( obj == null || getClass() != obj.getClass() ) {
            return false;
        }
        final Timesteps other = (Timesteps) obj;
        return Objects.equals( this.defaultTime, other.defaultTime )
               && Objects.equals( this.timesteps, other.timesteps );
    }

}
