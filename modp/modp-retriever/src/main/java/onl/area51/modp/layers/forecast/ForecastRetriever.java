/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package onl.area51.modp.layers.forecast;

import java.io.IOException;
import java.net.URISyntaxException;
import java.sql.SQLException;
import java.util.Objects;
import java.util.function.Consumer;
import javax.annotation.PostConstruct;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.json.Json;
import javax.xml.bind.JAXBException;
import onl.area51.modp.ModpService;
import uk.trainwatch.rabbitmq.Publisher;
import uk.trainwatch.scheduler.Cron;
import uk.trainwatch.util.JsonUtils;
import uk.trainwatch.util.xml.JAXBSupport;

/**
 * Handles the retrieval of forecast layer updates
 * <p>
 * @author peter
 */
@ApplicationScoped
public class ForecastRetriever
{

    private static final String PATH = "/public/data/layer/wxfcs/all/xml/capabilities";
    @Inject
    private ModpService modpService;

    @Publisher("modp.image.retrieve")
    private Consumer<String> publisher;

    @Inject
    private ForecastService forecastService;

    private JAXBSupport jaxb;

    @PostConstruct
    void start()
    {
        jaxb = forecastService.getJaxb();
    }

    /**
     * Retrieve at 00:15, 06:15, 12:15 & 18:15
     * <p>
     * @throws IOException
     * @throws URISyntaxException
     * @throws JAXBException
     * @throws SQLException
     */
    @Cron("0 15 0/6 * * ? *")
    public void retrieve()
            throws IOException,
                   URISyntaxException,
                   JAXBException,
                   SQLException
    {
        Layers layers = modpService.unmarshall( jaxb, PATH );

        // Update our layer details
        forecastService.update( layers );

        // Send each layer/timestep to the retrieval queue
        layers.getLayers()
                .forEach( layer -> {
                    Service service = layer.getService();

                    Timesteps t = service.getTimesteps();
                    String defaultTime = t.getDefaultTime();

                    service.getTimesteps()
                    .getTimesteps()
                    .stream()
                    .map( ts -> {
                        return Json.createObjectBuilder()
                        .add( "baseUrl", layers.getBaseUrl().getBaseUrl() )
                        .add( "timeFormat", Objects.toString( layers.getBaseUrl().getTimeFormat(), "" ) )
                        .add( "dir", service.getName() )
                        .add( "name", String.format( "%s%02d.%s", service.getName(), ts.getOffset(), service.getImageFormat() ) )
                        .add( "params", Json.createObjectBuilder()
                              .add( "LayerName", service.getName() )
                              .add( "ImageFormat", service.getImageFormat() )
                              .add( "DefaultTime", defaultTime )
                              .add( "Timestep", ts.getOffset() )
                        )
                        .build();
                    } )
                    .map( JsonUtils.jsonObjectToString )
                    .forEach( publisher );
                } );
    }
}
