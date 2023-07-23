CREATE OR REPLACE TRIGGER PBD_STUD_121.TRG_DATA_SPECTACOL 
    BEFORE INSERT OR UPDATE ON PBD_STUD_121.SPECTACOLE 
    FOR EACH ROW 
BEGIN 
  IF(:new.data_spectacol>SYSDATE)
  THEN
    RAISE_APPLICATION_ERROR(-20001, 'Data invalida'||TO_CHAR(:new.data_spectacol,'DD.MM.YYYY HH24:MI:SS')||' trebuie sa fe mai mare decat data curenta.');
  END IF;
END; 

CREATE OR REPLACE TRIGGER verifica_daca_se_poate_introduce_elev_nou_in_grupa
BEFORE INSERT OR UPDATE OF grupe_id_grupa ON elevi 
DECLARE
  ex_capacitate_sala_depasita EXCEPTION;
  TYPE elev_rec_type IS RECORD
    (p_id_grupa elevi.grupe_id_grupa%TYPE,
     p_id_elev elevi.id_elev%TYPE);
  TYPE rc_dept IS REF CURSOR RETURN elev_rec_type;
  rc rc_dept;
  el elev_rec_type;
  v_flag BOOLEAN;
BEGIN
  OPEN rc FOR
    SELECT grupe_id_grupa, id_elev
    FROM elevi;
  LOOP
    FETCH rc INTO el;
    verifica_daca_incape_elev_in_grupa_trigger(el.p_id_grupa, v_flag);
    IF v_flag = true then
        RAISE ex_capacitate_sala_depasita;
    END IF;
  EXIT WHEN rc%NOTFOUND;
  END LOOP;

EXCEPTION
  WHEN ex_capacitate_sala_depasita THEN 
    RAISE_APPLICATION_ERROR(-20004, 'Nu este loc in sala asignata grupei pentru elev');
  WHEN OTHERS THEN
    dbms_output.put_line('Error: ' || SQLERRM);
END;

CREATE OR REPLACE TRIGGER adaugare_elev_in_spectacol
BEFORE INSERT ON elevi_spectacol
FOR EACH ROW
DECLARE
    v_flag BOOLEAN;
BEGIN
    dbms_output.put_line('AIIIIICI');
    dbms_output.put_line(:new.spectacole_id_spectacol);
    verifica_daca_nu_a_fost_atinsa_capacitatea(:new.spectacole_id_spectacol, v_flag);
    dbms_output.put_line('s-a executat asta');
    IF v_flag = false then   
        dbms_output.put_line('v_flag este false');
    ELSE 
        dbms_output.put_line('v_flag este true');
    END IF;
    IF v_flag = FALSE THEN
--        dbms_output.put_line('Nu mai sunt locuri disponibile pentru acest spectacol');
        RAISE_APPLICATION_ERROR(-20001,'Nu mai sunt locuri disponibile pentru acest spectacol');
    END IF;
END;

CREATE OR REPLACE TRIGGER actualizare_experienta_instructori 
BEFORE UPDATE OF experienta ON instructori
FOR EACH ROW
DECLARE
    experienta_exceptie EXCEPTION;
BEGIN   
    IF :new.experienta <= :old.experienta THEN
        RAISE experienta_exceptie;
    END IF;
    EXCEPTION
        WHEN experienta_exceptie THEN
            RAISE_APPLICATION_ERROR(-20033, 'Experienta invalida');
END;

CREATE OR REPLACE TRIGGER actualizare_experienta_pianisti
BEFORE UPDATE OF experienta ON pianisti
FOR EACH ROW
DECLARE
    experienta_exceptie EXCEPTION;
BEGIN   
    IF :new.experienta <= :old.experienta THEN
        RAISE experienta_exceptie;
    END IF;
    EXCEPTION
        WHEN experienta_exceptie THEN
            RAISE_APPLICATION_ERROR(-20033, 'Experienta invalida');
END;

CREATE OR REPLACE PACKAGE testare_triggeri IS
    PROCEDURE testeaza_trigger_actualizare_experienta_cadru_didactic_crapa;
    PROCEDURE testeaza_trigger_actualizare_experienta_cadru_didactic;
    PROCEDURE testeaza_adaugare_elev_in_spectacol_capacitate_atinsa_deja;
    PROCEDURE testeaza_adaugare_spectacol_data_in_viitor;
    PROCEDURE testeaza_introducere_elev_nou_grupa_unde_nu_mai_are_loc;
END;
/

CREATE OR REPLACE PACKAGE BODY testare_triggeri IS
    PROCEDURE testeaza_introducere_elev_nou_grupa_unde_nu_mai_are_loc
    IS
    BEGIN
        INSERT INTO elevi(statut, nume, prenume, varsta, grupe_id_grupa, grupe_sali_id_sala)
        VALUES('incepator','ddd','ddd',6,1,1);
         EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM); 
    END;
    

    PROCEDURE testeaza_adaugare_elev_in_spectacol_capacitate_atinsa_deja
    IS
        v_id_grupa grupe.id_grupa%TYPE;
        v_id_spect spectacole.id_spectacol%TYPE;
    BEGIN 
        SELECT grupe_id_grupa 
        INTO v_id_grupa
        FROM elevi
        WHERE id_elev = 12;
        
        SELECT id_spectacol
        INTO v_id_spect
        FROM spectacole
        WHERE nume_spectacol = 'Ghioceii';
        
        DELETE FROM elevi_spectacol WHERE spectacole_id_spectacol = v_id_spect;
        DELETE FROM elevi_spectacol_istoric WHERE id_spectacol = v_id_spect;
        
        adaugare.elev_la_spectacol(10,'Ghioceii');
        adaugare.elev_la_spectacol(11,'Ghioceii');
        adaugare.elev_spect_istoric(12,v_id_grupa,v_id_spect);
        adaugare.elev_la_spectacol(13,'Ghioceii');
    END;
    
    PROCEDURE testeaza_trigger_actualizare_experienta_cadru_didactic_crapa
    IS
    BEGIN
        actualizari.modifica_experienta_instructor(5, 6);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;
    
    PROCEDURE testeaza_trigger_actualizare_experienta_cadru_didactic
    IS
    BEGIN
        actualizari.modifica_experienta_instructor(5, 16);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;
    
     PROCEDURE testeaza_adaugare_spectacol_data_in_viitor
    IS
    BEGIN
        adaugare.nou_spectacol('numerge',10,'2024-2-2');
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    
END;


SELECT * FROM elevi_spectacol;
SELECT * FROM spectacole;

EXECUTE testare_triggeri.testeaza_trigger_actualizare_experienta_cadru_didactic_crapa;
EXECUTE testare_triggeri.testeaza_trigger_actualizare_experienta_cadru_didactic;
EXECUTE testare_triggeri.testeaza_adaugare_elev_in_spectacol_capacitate_atinsa_deja;
EXECUTE testare_triggeri.testeaza_adaugare_spectacol_data_in_viitor;
EXECUTE testare_triggeri.testeaza_introducere_elev_nou_grupa_unde_nu_mai_are_loc;