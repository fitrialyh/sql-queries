-- Trigger 1
-- Kontributor:
-- 1. Assyifa Raudina - 1906399152
-- 2. Fitri 'aliyah - 2006597115
-- 3. Nathanael Horasi Ondiraja - 2006596586  

--Function:
CREATE OR REPLACE FUNCTION verify_pass() RETURNS trigger AS
$$
BEGIN 
	IF NOT ((NEW.password <> lower(NEW.password)) AND (NEW.password SIMILAR TO '%[0-9]%'))
	THEN
		RAISE EXCEPTION 'Password Anda belum memenuhi syarat, 
		silahkan pastikan bahwa password minimal terdapat 1 huruf 
		kapital dan 1 angka';
	END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

--Trigger:
CREATE TRIGGER PASSWORD_CHECK
BEFORE INSERT OR UPDATE OF password ON PENGGUNA
FOR EACH ROW EXECUTE PROCEDURE verify_pass();