CREATE OR REPLACE PACKAGE stergeri IS 
    PROCEDURE elev(p_id_elev elevi.id_elev%TYPE);
    PROCEDURE elev_spectacol(p_id_elev elevi.id_elev%TYPE,
                                p_nume_spectacol spectacole.nume_spectacol%TYPE);
    PROCEDURE spectacol(p_nume spectacole.nume_spectacol%TYPE);
    PROCEDURE instructor(p_id_instructor instructori.id_instructor%TYPE);
    PROCEDURE pianist(p_id_pianist pianisti.id_pianist%TYPE);
    PROCEDURE sterge_spectacolele_la_care_a_participat_un_elev(p_id_elev elevi.id_elev%TYPE);   
END;
/
CREATE OR REPLACE PACKAGE BODY stergeri IS
    PROCEDURE sterge_spectacolele_la_care_a_participat_un_elev(p_id_elev elevi.id_elev%TYPE)
    IS
    BEGIN
        verificari.verifica_daca_exista_elev(p_id_elev);
        DELETE FROM elevi_spectacol
        WHERE elevi_id_elev = p_id_elev;
        
        COMMIT;
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE instructor
        (p_id_instructor instructori.id_instructor%TYPE)
    IS
    BEGIN
        verificari.verifica_daca_exista_instructor(p_id_instructor);
        DELETE FROM instructori
        WHERE id_instructor = p_id_instructor;
        
        COMMIT;
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE pianist
        (p_id_pianist pianisti.id_pianist%TYPE)
    IS
    BEGIN
        verificari.verifica_daca_exista_pianist(p_id_pianist);
        DELETE FROM pianisti
        WHERE id_pianist = p_id_pianist;
        
        COMMIT;
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE spectacol
        (p_nume spectacole.nume_spectacol%TYPE)
    IS
        v_id_spectacol spectacole.id_spectacol%TYPE;
    BEGIN
        verificari.verifica_daca_exista_spectacol_cu_acest_nume(p_nume);
        
        SELECT id_spectacol
        INTO v_id_spectacol
        FROM spectacole
        WHERE nume_spectacol = p_nume; 
        
        DELETE from elevi_spectacol
        WHERE spectacole_id_spectacol = v_id_spectacol;
        
        DELETE FROM spectacole
        WHERE nume_spectacol = p_nume;
        
        COMMIT;
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE elev_spectacol
        (p_id_elev elevi.id_elev%TYPE,
        p_nume_spectacol spectacole.nume_spectacol%TYPE)
    IS
        v_id_spectacol spectacole.id_spectacol%TYPE;
    BEGIN
    
        verificari.verifica_daca_exista_spectacol_cu_acest_nume(p_nume_spectacol);
        verificari.verifica_daca_exista_elev(p_id_elev);
        
        SELECT id_spectacol
        INTO v_id_spectacol
        FROM spectacole
        WHERE nume_spectacol = p_nume_spectacol;
        
        DELETE FROM elevi_spectacol
        WHERE elevi_id_elev = p_id_elev
        AND spectacole_id_spectacol = v_id_spectacol;
        
        COMMIT;
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE elev(p_id_elev elevi.id_elev%TYPE)
    IS
        CURSOR c IS 
            SELECT *
            FROM elevi_spectacol
            WHERE elevi_id_elev = p_id_elev;
        v_row_elev elevi_spectacol%ROWTYPE;
    BEGIN
        verificari.verifica_daca_exista_elev(p_id_elev);
        --iau spectacolele , le pun in istoric si le sterg din elevi_spectacol
        OPEN c;
        LOOP
            FETCH c INTO v_row_elev;        
            EXIT WHEN c%NOTFOUND;
            INSERT INTO elevi_spectacol_istoric(id_elev, id_grupa, id_spectacol)
            VALUES(v_row_elev.elevi_id_elev, v_row_elev.elevi_id_grupa, v_row_elev.spectacole_id_spectacol);
            COMMIT;
        END LOOP;
        DELETE FROM elevi_spectacol
        WHERE elevi_id_elev = p_id_elev;
        COMMIT;
        DELETE FROM elevi
        WHERE id_elev = p_id_elev;
        COMMIT;
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;    
END;