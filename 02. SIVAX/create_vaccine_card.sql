--Function:
CREATE OR REPLACE FUNCTION SIVAX.create_kartu_vaksin()
RETURNS trigger AS
$$
    DECLARE
        kode_stat VARCHAR(50);
        jumlah_sertifikat INTEGER;
    BEGIN
        SELECT COUNT(*) INTO jumlah_sertifikat FROM KARTU_VAKSIN 
        WHERE email = NEW.email;
        
        SELECT kode_status INTO kode_stat FROM TIKET WHERE email = NEW.email 
        ORDER BY kode_status DESC LIMIT 1;

        IF(kode_stat = '04') THEN
            SELECT substr(concat(md5(random()::VARCHAR), md5(random()::VARCHAR)), 0, 31) INTO NEW.no_sertifikat;            
            IF(jumlah_sertifikat > 0) THEN
                SELECT concat('Tahap ', cast((jumlah_sertifikat + 1) AS VARCHAR)) INTO NEW.status_tahapan;
            ELSE 
                SELECT 'Tahap 1' INTO NEW.status_tahapan;
            END IF;
        END IF;
        RETURN NEW;
    END;
$$
LANGUAGE plpgsql;

--Trigger:
CREATE TRIGGER trigger_create_kartu_vaksin
BEFORE INSERT ON KARTU_VAKSIN
FOR EACH ROW
EXECUTE PROCEDURE create_kartu_vaksin();