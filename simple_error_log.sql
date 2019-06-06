-- ERROR LOG PROCEDURE
CREATE OR REPLACE PROCEDURE J1NX_SIMPLE_ERROR_LOG_WRITE (PV_CURRENT_TABLE VARCHAR2, PV_CURRENT_FIELD VARCHAR2, PV_CURRENT_ACTION VARCHAR2) IS
    LV_SQL_TEXT VARCHAR2(4000);
    LV_COUNT    NUMBER;
BEGIN
    --dbms_output.put_line('TEST');
    -- CHECK FOR THE PRESENCE OF THE ERROR LOG
    LV_SQL_TEXT := 'SELECT COUNT(*) FROM ALL_OBJECTS WHERE OBJECT_TYPE = ''TABLE'' AND OBJECT_NAME = ''J1NX_SIMPLE_ERROR_LOG''';
    EXECUTE IMMEDIATE LV_SQL_TEXT INTO LV_COUNT;

    -- IF ERROR LOG TABLE DOES NOT EXIST, CREATE IT
    IF LV_COUNT = 0 THEN
        LV_SQL_TEXT :=  'CREATE TABLE J1NX_SIMPLE_ERROR_LOG (' ||
                        'ERROR_TIME TIMESTAMP,' ||
                        'CURRENT_TABLE VARCHAR2(30),' ||
                        'CURRENT_FIELD VARCHAR2(30),' ||
                        'ERROR_MESSAGE VARCHAR2(4000))';
        --dbms_output.put_line(LV_SQL_TEXT);
        EXECUTE IMMEDIATE LV_SQL_TEXT;
    END IF;

    -- WRITE PARAMETER VALUES TO ERROR LOG
    LV_SQL_TEXT :=  'INSERT INTO J1NX_SIMPLE_ERROR_LOG (ERROR_TIME, CURRENT_TABLE, CURRENT_FIELD, ERROR_MESSAGE) VALUES (' ||
                    'SYSDATE, ''' ||
                    PV_CURRENT_TABLE    || ''',''' ||
                    PV_CURRENT_FIELD    || ''',''' ||
                    PV_CURRENT_ACTION   || '''' ||
                    ')';
    EXECUTE IMMEDIATE LV_SQL_TEXT;
END;
