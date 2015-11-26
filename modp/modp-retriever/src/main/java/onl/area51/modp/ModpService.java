/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package onl.area51.modp;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.function.Function;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import javax.annotation.PostConstruct;
import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.xml.bind.JAXBException;
import org.apache.commons.configuration.Configuration;
import org.isomorphism.util.TokenBucket;
import org.isomorphism.util.TokenBuckets;
import uk.trainwatch.util.config.ConfigurationService;
import uk.trainwatch.util.xml.JAXBSupport;

/**
 * Handles all communication with the MetOffice
 *
 * @author peter
 */
@ApplicationScoped
public class ModpService
{

    private static final Logger LOG = Logger.getLogger( ModpService.class.getName() );

    @Inject
    private ConfigurationService configurationService;

    /**
     * API Scheme
     */
    private String scheme;
    /**
     * API Hostname
     */
    private String hostname;
    /**
     * API Key
     */
    private String key;
    private TokenBucket bucket;

    @PostConstruct
    void start()
    {
        Configuration config = configurationService.getPrivateConfiguration( "metoffice" );

        scheme = config.getString( "api.scheme", "http" );
        hostname = config.getString( "api.hostname", "datapoint.metoffice.gov.uk" );

        key = config.getString( "api.key" );

        int capacity = config.getInt( "api.capacity", 50 );
        bucket = TokenBuckets.builder()
                .withCapacity( capacity )
                .withInitialTokens( config.getInt( "api.initial", capacity ) )
                .withFixedIntervalRefillStrategy( config.getInt( "api.refill", capacity ), 1, TimeUnit.MINUTES )
                .build();
    }

    private URI getUri( final String path, final Map<String, String> params )
            throws URISyntaxException
    {
        // Use a new map as params may be null or read-only
        Map<String, String> p = params == null ? new HashMap<>() : new HashMap<>( params );

        // Add our API key
        params.put( "key", key );

        String query = p.entrySet()
                .stream()
                .filter( e -> e.getValue() != null )
                .map( e -> e.getKey() + "=" + e.getValue() )
                .collect( Collectors.joining( "&" ) );

        // Log the URI - we can use this to monitor remote useage so we stay within our licensed bounds
        LOG.log( Level.INFO, () -> "URI: " + path );

        return new URI( scheme, null, path, query, null );
    }

    private URLConnection getURLConnection( final String path, final Map<String, String> params )
            throws IOException,
                   URISyntaxException
    {
        URI newUri = getUri( path, params );

        // Rate limit to keep within licence constraints
        bucket.consume();

        return newUri.toURL().openConnection();
    }

    /**
     * Return an InputStream from the remote service
     * <p>
     * @param path API path
     * <p>
     * @return InputStream
     * <p>
     * @throws IOException
     * @throws URISyntaxException
     */
    public InputStream getInputStream( final String path )
            throws IOException,
                   URISyntaxException
    {
        return getInputStream( path, null );
    }

    /**
     * Return an InputStream from the remote service
     * <p>
     * @param path   API path
     * @param params API parameters
     * <p>
     * @return InputStream
     * <p>
     * @throws IOException
     * @throws URISyntaxException
     */
    public InputStream getInputStream( final String path, final Map<String, String> params )
            throws IOException,
                   URISyntaxException
    {
        return getURLConnection( path, params ).getInputStream();
    }

    /**
     * Return a Reader from the remote service
     * <p>
     * @param path API path
     * <p>
     * @return InputStream
     * <p>
     * @throws IOException
     * @throws URISyntaxException
     */
    public Reader getReader( final String path )
            throws IOException,
                   URISyntaxException
    {
        return getReader( path, null );
    }

    /**
     * Return a Reader from the remote service
     * <p>
     * @param path   API path
     * @param params API parameters
     * <p>
     * @return InputStream
     * <p>
     * @throws IOException
     * @throws URISyntaxException
     */
    public Reader getReader( final String path, final Map<String, String> params )
            throws IOException,
                   URISyntaxException
    {
        return new InputStreamReader( getInputStream( path, params ) );
    }

    /**
     * Retrieve an object as XML
     * <p>
     * @param <T>  Type
     * @param jaxb JAXBSupport to handle unmarshalling
     * @param path path
     * <p>
     * @return object
     * <p>
     * @throws IOException
     * @throws URISyntaxException
     * @throws JAXBException
     */
    public <T> T unmarshall( final JAXBSupport jaxb, final String path )
            throws IOException,
                   URISyntaxException,
                   JAXBException
    {
        return unmarshall( jaxb, path, null );
    }

    /**
     * Retrieve an object as XML
     * <p>
     * @param <T>    Type
     * @param jaxb   JAXBSupport to handle unmarshalling
     * @param path   path
     * @param params parameters
     * <p>
     * @return object
     * <p>
     * @throws IOException
     * @throws URISyntaxException
     * @throws JAXBException
     */
    public <T> T unmarshall( final JAXBSupport jaxb, final String path, final Map<String, String> params )
            throws IOException,
                   URISyntaxException,
                   JAXBException
    {
        try( Reader r = getReader( path, params ) ) {
            return jaxb.unmarshall( r );
        }
    }

    private static final Pattern pathPattern = Pattern.compile( "(\\{([a-zA-Z]+)\\})" );
    private static final Pattern queryPattern = Pattern.compile( "([a-zA-z]+)=\\{([a-zA-Z]+)\\}" );

    /**
     * Given a url use the supplied mapper to expand
     * <p>
     * Note: If the mapper returns null then "null" is included in the path, not ""
     * <p>
     * @param path
     * @param mapper
     *               <p>
     * @return
     */
    public String expand( String path, Function<String, String> mapper )
    {
        StringBuffer sb = new StringBuffer();
        Matcher m = pathPattern.matcher( path );
        while( m.find() ) {
            m.appendReplacement( sb, mapper.apply( m.group( 2 ) ) );
        }
        m.appendTail( sb );
        return sb.toString();
    }

    /**
     * Given the supplied query string, generate a property map.
     * <p>
     * Note: "key" is ignored here. Also if the mapper returns null then it's not added to the map.
     * <p>
     * @param query  query string
     * @param mapper mapper
     * <p>
     * @return Map of key/values
     */
    public Map<String, String> expandMap( String query, Function<String, String> mapper )
    {
        Map<String, String> map = new HashMap<>();
        Matcher m = queryPattern.matcher( query );
        while( m.find() ) {
            String k = m.group( 1 );
            if( !"key".equals( k ) ) {
                String value = mapper.apply( m.group( 2 ) );
                if( value != null ) {
                    map.put( key, value );
                }
            }
        }
        return map;
    }
}
