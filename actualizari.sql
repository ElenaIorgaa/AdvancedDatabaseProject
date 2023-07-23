CREATE OR REPLACE PACKAGE actualizari IS
    PROCEDURE modifica_statut_grupa(p_id_grupa grupe.id_grupa%TYPE, p_statut grupe.statut%TYPE);
    PROCEDURE modifica_experienta_instructor(p_id_instructor instructori.id_instructor%TYPE, p_experienta instructori.experienta%TYPE);
    PROCEDURE modifica_experienta_pianist(p_id_pianist pianisti.id_pianist%TYPE, p_experienta pianisti.experienta%TYPE);
    PROCEDURE modifica_elev_statut_grupa_sala(p_id_elev elevi.id_elev%TYPE, p_id_grupa grupe.id_grupa%TYPE, p_statut elevi.statut%TYPE);
    PROCEDURE modifica_statut_elev(p_id_elev elevi.id_elev%TYPE, p_statut elevi.statut%TYPE);
END actualizari;
/
CREATE OR REPLACE PACKAGE BODY actualizari IS
    
    PROCEDURE modifica_statut_elev
        (p_id_elev elevi.id_elev%TYPE, p_statut elevi.statut%TYPE)
    IS
    BEGIN
        verificari.verifica_daca_statutul_e_valid(p_statut);
        verificari.verifica_daca_exista_elev(p_id_elev);
        UPDATE elevi
        SET statut = p_statut
        WHERE id_elev = p_id_elev;
        
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM); 
    END;
    
    PROCEDURE modifica_elev_statut_grupa_sala
        (p_id_elev elevi.id_elev%TYPE, p_id_grupa grupe.id_grupa%TYPE, p_statut elevi.statut%TYPE)
    IS
        v_id_sala sali.id_sala%TYPE;
    BEGIN
        verificari.verifica_daca_statutul_e_valid(p_statut);
        verificari.verifica_daca_exista_elev(p_id_elev);
        verificari.verifica_daca_exsita_grupa(p_id_grupa);
        
        SELECT sali_id_sala
        INTO v_id_sala
        FROM grupe
        WHERE id_grupa = p_id_grupa;
        
        UPDATE elevi
        SET grupe_id_grupa = p_id_grupa, grupe_sali_id_sala = v_id_sala, statut = p_statut
        WHERE id_elev = p_id_elev;

        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM); 
    END;
    
    PROCEDURE modifica_experienta_pianist
        (p_id_pianist pianisti.id_pianist%TYPE,
        p_experienta pianisti.experienta%TYPE)
    IS
    BEGIN
        verificari.verifica_daca_exista_pianist(p_id_pianist);
        
        UPDATE pianisti
        SET experienta = p_experienta
        WHERE id_pianist = p_id_pianist;
        
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM); 
    END;
    
    PROCEDURE modifica_experienta_instructor
        (p_id_instructor instructori.id_instructor%TYPE,
        p_experienta instructori.experienta%TYPE)
    IS
    BEGIN
    dbms_output.put_line('verific daca exista '||p_id_instructor);
        verificari.verifica_daca_exista_instructor(p_id_instructor);
        UPDATE instructori
        SET experienta = p_experienta
        WHERE id_instructor = p_id_instructor;
        
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM); 
    END;
    
    
    PROCEDURE modifica_statut_grupa(p_id_grupa grupe.id_grupa%TYPE, p_statut grupe.statut%TYPE)
    IS
        CURSOR c IS
            SELECT id_elev
            FROM elevi
            WHERE grupe_id_grupa = p_id_grupa;
        v_elev elevi.grupe_id_grupa%TYPE;
    BEGIN
            verificari.verifica_daca_statutul_e_valid(p_statut);
            verificari.verifica_daca_exsita_grupa(p_id_grupa);
            
             OPEN c;
             LOOP
                FETCH c INTO v_elev;
                EXIT WHEN c%NOTFOUND;
                    UPDATE elevi
                    SET statut = p_statut
                    WHERE elevi.grupe_id_grupa = p_id_grupa;
             END LOOP;
            CLOSE c;
            
            UPDATE grupe
            SET statut = p_statut
            WHERE id_grupa = p_id_grupa;
        
         EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END modifica_statut_grupa;
END actualizari;