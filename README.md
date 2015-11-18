This project contains the weather based webapps that utilise the opendata project.

The reason this is separate is to keep that project primarily specific to processing opendata. This is more so as the uktra.in and departureboards.mobi
websites are in there and I felt that adding everything into one big project is (now) probably a bad idea.

Initially this project will not compile - it's mainly pulling in code from the original repositories in readiness of converting the code over to the new
platform. It's probably not going to be of interest to most others either - but in keeping with the rest of the projects (& I'm old school as well) the source
is here & in the open ;-)

So this repository will contain the following sites:
* maidstoneweather.com - the original site, will be rewritten to be a view over the data
* piweather.center - another view but more oriented towards showing the Raspberry PI weather station hardware & software who's source is already in the git repository of the same name.

The opendata project however will contain the backend for the following feeds:
* MetOffice Data Point (modp) - this will be the inbound feeds of UK weather, e.g. rain fall radar, lightning & forecasts
