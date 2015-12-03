-- ================================================================================
-- forecast.sql - functions to manage forcast layers
-- ================================================================================

CREATE SCHEMA modp;
GRANT ALL ON SCHEMA modp TO weather;

SET search_path = modp;

CREATE TABLE metfcst_layer (
    id          SERIAL NOT NULL,
    layername   NAME NOT NULL,
    displayname TEXT,
    fmt         NAME,
    -- The timestamp as '2012-09-13T09:00:00'
    tm          NAME,
    steps       TEXT,
    -- tm as a TIMESTAMP
    ts          TIMESTAMP WITHOUT TIME ZONE,
    PRIMARY KEY (layername)
);

CREATE UNIQUE INDEX metfcst_layer_i ON metfcst_layer(id);

GRANT ALL ON metfcst_layer TO weather;

CREATE OR REPLACE FUNCTION modp_newforecast (
    playername   NAME,
    pdisplayname TEXT,
    pfmt         NAME,
    ptm          NAME,
    psteps       TEXT
) RETURNS VOID AS $$
DECLARE
    rec     RECORD;
BEGIN
    LOOP
        SELECT * FROM modp.metfcst_layer WHERE layername=playername;
        IF FOUND THEN
            UPDATE modp.forecast
                SET displayname=pdisplayname,fmt=pfmt,tm=ptm,steps=psteps,ts=ptm::TIMESTAMP WITHOUT TIME ZONE
                WHERE layername=playername;
            RETURN;
        END IF;
        BEGIN
            INSERT INTO modp.metfcst_layer
                (layername,displayname,fmt,tm,steps,ts)
                VALUES (playername,pdisplayname,pfmt,ptm,psteps,ptm::TIMESTAMP WITHOUT TIME ZONE);
        EXCEPTION WHEN unique_violation THEN
            -- Do nothing, loop & try again
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
