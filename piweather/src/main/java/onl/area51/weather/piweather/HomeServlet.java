/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package onl.area51.weather.piweather;

import java.io.IOException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import uk.trainwatch.web.servlet.AbstractServlet;
import uk.trainwatch.web.servlet.ApplicationRequest;

/**
 *
 * @author peter
 */
@WebServlet(name="HomeServlet",urlPatterns="/home")
public class HomeServlet
extends AbstractServlet
{
    @Override
    protected void doGet( ApplicationRequest request )
            throws ServletException,
            IOException
    {
        request.expiresIn( 1, ChronoUnit.HOURS );
        request.maxAge( 1, ChronoUnit.HOURS );
        request.lastModified( Instant.now() );
        
        request.renderTile( "homepage" );
    }

}
