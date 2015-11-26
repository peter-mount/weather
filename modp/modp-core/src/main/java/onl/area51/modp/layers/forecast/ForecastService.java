/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package onl.area51.modp.layers.forecast;

import java.io.Reader;
import java.sql.SQLException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import javax.annotation.PostConstruct;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.xml.bind.JAXBException;
import uk.trainwatch.util.sql.UncheckedSQLException;
import uk.trainwatch.util.xml.JAXBSupport;

/**
 *
 * @author peter
 */
@ApplicationScoped
public class ForecastService
{

    @Inject
    private ForecastCache cache;

    private JAXBSupport jaxb;

    private volatile List<String> layerNames;

    @PostConstruct
    void start()
            throws SQLException,
                   JAXBException
    {
        jaxb = new JAXBSupport( Layers.class );

        // Initialise with the current layer names
        layerNames = Collections.unmodifiableList( cache.getLayers() );
    }

    private void update( Layer layer )
    {
        try {
            cache.setLayer( layer.getService().getLayerName(), layer );
        }
        catch( SQLException ex ) {
            throw new UncheckedSQLException( ex );
        }
    }

    /**
     * Used by the feed retriever to update the forecast
     * <p>
     * @param layers
     *               <p>
     * @throws SQLException
     */
    void update( Layers layers )
            throws SQLException
    {
        layers.getLayers().forEach( this::update );

        layerNames = layers.getLayers()
                .stream()
                .map( l -> l.getService().getLayerName() )
                .collect( Collectors.toList() );
    }

    public List<String> getLayerNames()
    {
        return layerNames;
    }

    public Layer getLayer( String name )
    {
        try {
            return cache.getLayer( name );
        }
        catch( SQLException ex ) {
            throw new UncheckedSQLException( ex );
        }
    }

    public JAXBSupport getJaxb()
    {
        return jaxb;
    }

}
