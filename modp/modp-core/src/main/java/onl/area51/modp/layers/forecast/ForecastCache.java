/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package onl.area51.modp.layers.forecast;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;
import javax.cache.annotation.CacheDefaults;
import javax.cache.annotation.CacheKey;
import javax.cache.annotation.CacheRemove;
import javax.cache.annotation.CacheResult;
import javax.enterprise.context.ApplicationScoped;
import javax.sql.DataSource;
import uk.trainwatch.util.sql.Database;
import uk.trainwatch.util.sql.SQL;

/**
 *
 * @author peter
 */
@ApplicationScoped
@CacheDefaults(cacheName = "weatherForecast")
class ForecastCache
{

    @Database("weather")
    private DataSource dataSource;

    /**
     * Return a list of the current layers
     * <p>
     * @return
     * <p>
     * @throws SQLException
     */
    public List<String> getLayers()
            throws SQLException
    {
        try( Connection con = dataSource.getConnection() ) {
            try( PreparedStatement ps = SQL.prepare( con, "SELECT layername FROM modp.metfcst_layer" ) ) {
                return SQL.stream( ps, SQL.STRING_LOOKUP )
                        .collect( Collectors.toList() );
            }
        }
    }

    @CacheResult
    public Layer getLayer( String name )
            throws SQLException
    {
        try( Connection con = dataSource.getConnection() ) {
            try( PreparedStatement ps = SQL.prepare( con, "SELECT * FROM modp.metfcst_layer WHERE layername=?", name ) ) {
                return SQL.stream( ps, Layer::new )
                        .findAny()
                        .orElse( null );
            }
        }
    }

    /**
     * Update the layer in the database, removing it from the cache so the next response updates it
     * <p>
     * @param name  Cache key name
     * @param layer Layer to update
     */
    @CacheRemove
    public void setLayer( @CacheKey String name, Layer layer )
            throws SQLException
    {
        try( Connection con = dataSource.getConnection() ) {
            Service s = layer.getService();
            Timesteps t = s.getTimesteps();
            try( PreparedStatement ps = SQL.prepare( con, "SELECT modp_newforecast(?,?,?,?,?)",
                                                     s.getLayerName(),
                                                     layer.getDisplayName(),
                                                     s.getImageFormat(),
                                                     t.getDefaultTime(),
                                                     t.getTimesteps()
                                                     .stream()
                                                     .map( Timestep::getOffset )
                                                     .map( String::valueOf )
                                                     .collect( Collectors.joining( "," ) )
            ) ) {
                try( ResultSet rs = ps.executeQuery() ) {
                }
            }
        }
    }
}
