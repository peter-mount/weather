/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package onl.area51.modp;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * Ensures the core services are started
 * <p>
 * @author peter
 */
@WebListener
@ApplicationScoped
public class ModpContextListener
        implements ServletContextListener
{

    @Inject
    private ModpImageRetriever imageRetriever;

    @Override
    public void contextInitialized( ServletContextEvent sce )
    {
        imageRetriever.start();
    }

    @Override
    public void contextDestroyed( ServletContextEvent sce )
    {
    }

}
