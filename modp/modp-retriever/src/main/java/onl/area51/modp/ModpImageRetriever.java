/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package onl.area51.modp;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.annotation.PostConstruct;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.json.JsonObject;
import uk.trainwatch.rabbitmq.Rabbit;
import uk.trainwatch.rabbitmq.RabbitMQ;

/**
 * Handles the retrieval of image files from the MetOffice
 * <p>
 * @author peter
 */
@ApplicationScoped
public class ModpImageRetriever
{

    private static final Logger LOG = Logger.getLogger(ModpImageRetriever.class.getName() );
    @Inject
    private ModpService modpService;

    @Inject
    private Rabbit rabbit;

    private Path basePath;

    void start()
    {
        rabbit.queueDurableConsumer( "modp.retrieve.image", "modp.image.retrieve", RabbitMQ.toJsonObject, this::retrieve );
    }

    private void retrieve( JsonObject obj )
    {
        try {
            JsonObject params = obj.getJsonObject( "params" );

            URI baseUrl = new URI( obj.getString( "baseUrl" ) );
            String path = modpService.expand( baseUrl.getPath(), params::getString );
            Map<String, String> args = modpService.expandMap( baseUrl.getQuery(), params::getString );

            Path dir = basePath.resolve( obj.getString( "dir" ) );
            if( dir.toFile().mkdirs() ) {
                LOG.log( Level.INFO, () -> "Created " + dir );
            }

            Path file = dir.resolve( obj.getString( "name" ) );

            try( InputStream is = modpService.getInputStream( path, args ) ) {
                LOG.log( Level.INFO, () -> "Storing " + file );
                Files.copy( is, file, StandardCopyOption.REPLACE_EXISTING );
            }
        }
        catch( IOException |
               URISyntaxException ex ) {
            LOG.log( Level.SEVERE, null, ex );
        }
    }
}
