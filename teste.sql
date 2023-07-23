


CREATE OR REPLACE PACKAGE teste_actualizari IS
    PROCEDURE testeaza_modifica_statut_grupa;
    PROCEDURE testeaza_modifica_statut_invalid_grupa;
    PROCEDURE testeaza_modifica_experienta_daca_e_invalida_conform_triggerului_instructor;
    PROCEDURE testeaza_modifica_experienta_instructor;
    PROCEDURE testeaza_modifica_experienta_daca_e_invalida_conform_triggerului_pianist;
    PROCEDURE testeaza_modifica_experienta_pianist;
END teste_actualizari;
/
CREATE OR REPLACE PACKAGE BODY teste_actualizari IS

     PROCEDURE testeaza_modifica_experienta_pianist
    IS
    BEGIN
        actualizari.modifica_experienta_pianist(7, 21);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;

    PROCEDURE testeaza_modifica_experienta_daca_e_invalida_conform_triggerului_pianist
    IS
    BEGIN
        actualizari.modifica_experienta_pianist(7, 5);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;


     PROCEDURE testeaza_modifica_experienta_instructor
    IS
    BEGIN
        actualizari.modifica_experienta_instructor(21, 5);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;

    PROCEDURE testeaza_modifica_experienta_daca_e_invalida_conform_triggerului_instructor
    IS
    BEGIN
        actualizari.modifica_experienta_instructor(2, 5);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;

    PROCEDURE testeaza_modifica_statut_grupa
    IS  v_id_grupa GRUPE.id_grupa%TYPE;
    v_id_sala sali.id_sala%TYPE;
    BEGIN
        SELECT max(id_grupa)
        INTO v_id_grupa
        FROM grupe;
        
        SELECT sali_id_sala
        INTO v_id_sala
        FROM grupe
        WHERE id_grupa = v_id_grupa;
        
        actualizari.modifica_statut_grupa(v_id_grupa, 'incepator');
        INSERT INTO elevi(statut, nume, prenume, varsta, grupe_id_grupa,grupe_sali_id_sala)
        VALUES ('incepator', 'ccc','ccc',7,v_id_grupa,v_id_sala);
        
        actualizari.modifica_statut_grupa(v_id_grupa, 'profesionist');
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;
    
    PROCEDURE testeaza_modifica_statut_invalid_grupa
    IS  v_id_grupa GRUPE.id_grupa%TYPE;
    BEGIN
        SELECT max(id_grupa)
        INTO v_id_grupa
        FROM grupe;
        
        actualizari.modifica_statut_grupa(v_id_grupa, 'lalala');
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);   
    END;
    
END teste_actualizari;
select * from grupe;
EXECUTE teste_actualizari.testeaza_modifica_statut_grupa;
EXECUTE teste_actualizari.testeaza_modifica_statut_invalid_grupa;
EXECUTE teste_actualizari.testeaza_modifica_experienta_daca_e_invalida_conform_triggerului_instructor;
EXECUTE teste_actualizari.testeaza_modifica_experienta_instructor;
EXECUTE teste_actualizari.testeaza_modifica_experienta_daca_e_invalida_conform_triggerului_pianist;
EXECUTE teste_actualizari.testeaza_modifica_experienta_pianist;

select * from instructori;

/
CREATE OR REPLACE PACKAGE teste_stergeri IS
    PROCEDURE testeaza_stergere_elev_inexistent;
    PROCEDURE testeaza_stergere_elev_care_are_spectacole;
    PROCEDURE testeaza_stergere_elev_spectacol;
    PROCEDURE testeaza_stergere_spectacol;
    PROCEDURE testeaza_stergere_spectacol_inexistent;
    PROCEDURE testeaza_stergere_instructor_inexistent;
    PROCEDURE testeaza_stergere_pianist_inexistent;
    PROCEDURE testeaza_stergere_instructor;
    PROCEDURE testeaza_stergere_pianist; 
END;
/

CREATE OR REPLACE PACKAGE BODY teste_stergeri IS
    PROCEDURE testeaza_adaugare_spectacol_data_in_viitor
    IS
    BEGIN
        adaugare.nou_spectacol('numerge',10,'2022-2-2');
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_stergere_pianist
    IS
        v_id_instructor pianisti.id_pianist%TYPE;
    
    BEGIN
        
        
        adaugare.nou_pianist('test','test','incepator',11,13);
        
        SELECT max(id_pianist)
        INTO v_id_instructor
        FROM pianisti;
        
        stergeri.pianist(v_id_instructor);
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    

    PROCEDURE testeaza_stergere_instructor
    IS
        v_id_instructor instructori.id_instructor%TYPE;
    BEGIN
        adaugare.nou_instructor('test','test','incepator',11,13);
        
        SELECT max(id_instructor)
        INTO v_id_instructor
        FROM instructori;
        
        stergeri.instructor(v_id_instructor);
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE testeaza_stergere_instructor_inexistent
    IS
    BEGIN
        stergeri.instructor(9999);
         EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_stergere_pianist_inexistent
    IS
    BEGIN
        stergeri.pianist(9999);
         EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE testeaza_stergere_spectacol_inexistent
    IS
    BEGIN
        stergeri.spectacol('NUEXISTA');
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE testeaza_stergere_spectacol
    IS
    BEGIN   
        adaugare.nou_spectacol('NouSpect',11,'2023-9-23');
        stergeri.spectacol('NouSpect');
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_stergere_elev_spectacol
    IS
    BEGIN   
        adaugare.elev_la_spectacol(10,'Nopti albe');
        dbms_output.put_line('Am inserat elevul la Nopti albe');
        stergeri.elev_spectacol(10, 'Nopti albe');
        dbms_output.put_line('Apoi l-am sters');
    END;
    
    PROCEDURE testeaza_stergere_elev_inexistent
    IS
    BEGIN
        stergeri.elev(9999);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_stergere_elev_care_are_spectacole
    IS
        v_elev_nou_inserat elevi%ROWTYPE;
        v_elev_la_spectacol elevi_spectacol%ROWTYPE;
    BEGIN
        adaugare.nou_elev('profesionist','test','test',8);
        
        SELECT *
        INTO v_elev_nou_inserat
        FROM elevi
        WHERE nume = 'test'
        AND prenume = 'test'
        AND varsta = 8
        AND statut = 'profesionist';
        
        dbms_output.put_line('Am inserat elevul nou care va avea id-ul '||v_elev_nou_inserat.id_elev);
        
        adaugare.elev_la_spectacol(v_elev_nou_inserat.id_elev,'Nopti albe');
        
        SELECT *
        INTO v_elev_la_spectacol
        FROM elevi_spectacol
        WHERE elevi_id_elev = v_elev_nou_inserat.id_elev
        AND spectacole_id_spectacol = (SELECT id_spectacol FROM spectacole WHERE nume_spectacol = 'Nopti albe');
        
        dbms_output.put_line('Am inserat la spectacolul Nopti albe');
        
        stergeri.elev(v_elev_nou_inserat.id_elev);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
END;
SET SERVEROUTPUT ON;
EXECUTE teste_stergeri.testeaza_stergere_elev_inexistent;
EXECUTE teste_stergeri.testeaza_stergere_elev_care_are_spectacole;
EXECUTE teste_stergeri.testeaza_stergere_elev_spectacol;
EXECUTE teste_stergeri.testeaza_stergere_spectacol;
EXECUTE teste_stergeri.testeaza_stergere_spectacol_inexistent;
EXECUTE teste_stergeri.testeaza_stergere_pianist_inexistent;
EXECUTE teste_stergeri.testeaza_stergere_instructor_inexistent;
EXECUTE teste_stergeri.testeaza_stergere_instructor;
EXECUTE teste_stergeri.testeaza_stergere_pianist;




CREATE OR REPLACE PACKAGE teste_adaugari IS
    PROCEDURE testeaza_adaugare_spectacol_cu_capacitate_invalida;
    PROCEDURE testeaza_adaugare_spectacol_cu_data_invalida;
    PROCEDURE testeaza_adaugare_spectacol_cu_data_in_viitor;
    PROCEDURE testeaza_adaugare_spectacol_corect;
    PROCEDURE testeaza_adaugare_elev_la_spectacol_unde_nu_mai_are_loc;
    PROCEDURE testeaza_adaugare_elev_la_spectacol_inexistent;
    PROCEDURE testeaza_adaugare_elev_inexistent_la_spectacol;
    PROCEDURE testeaza_adaugare_elev_nou_cu_statut_invalid;
    PROCEDURE testeaza_adaugare_elev_nou_cu_varsta_invalida;
    PROCEDURE testeaza_adaugare_elev_nou_care_ar_trb_sa_ajunga_in_grupa_2;
    PROCEDURE testeaza_adaugare_nou_instructor_pentru_grupa_care_are_deja_unul;
    PROCEDURE testeaza_adaugare_nou_instructor;
    PROCEDURE testeaza_adaugare_nou_instructor_care_nu_corespunde_grupei;
    PROCEDURE testeaza_adaugare_nou_pianist_pentru_grupa_care_are_deja_unul;
    PROCEDURE testeaza_adaugare_nou_pianist;
    PROCEDURE testeaza_adaugare_nou_pianist_care_nu_corespunde_grupei;
    PROCEDURE testeaza_adaugare_noua_grupa_statut_invalid;
    PROCEDURE testeaza_adaugare_noua_grupa_in_sala_inexistenta;
    PROCEDURE testeaza_adaugare_noua_grupa;
    PROCEDURE testeaza_adaugare_sala_capacitate_invalida;
    PROCEDURE testeaza_adaugare_sala_dimensiune_invalida;
    PROCEDURE testeaza_adaugare_sala;
END teste_adaugari;
/
CREATE OR REPLACE PACKAGE BODY teste_adaugari IS

    PROCEDURE testeaza_adaugare_sala_capacitate_invalida
    IS
    BEGIN
        adaugare.nou_sala(11,-5);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_adaugare_sala_dimensiune_invalida
    IS
    BEGIN
    adaugare.nou_sala(2,5);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_adaugare_sala
    IS
    BEGIN
        DELETE FROM SALI
        WHERE dimensiune = 66
        AND capacitate = 6;
        adaugare.nou_sala(66,6);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;


    PROCEDURE testeaza_adaugare_noua_grupa
    IS
    BEGIN
        DELETE FROM grupe WHERE statut='profesionist' AND sali_id_sala = 3;
        adaugare.nou_grupa('profesionist',3);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE testeaza_adaugare_noua_grupa_in_sala_inexistenta
    IS
    BEGIN
        adaugare.nou_grupa('incepator',9999);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_adaugare_noua_grupa_statut_invalid
    IS
    BEGIN
        adaugare.nou_grupa('lalala',3);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;

 PROCEDURE testeaza_adaugare_nou_pianist_care_nu_corespunde_grupei
    IS
    BEGIN
        DELETE FROM PIANISTI WHERE grupe_id_grupa = 8;
        adaugare.nou_pianist('nou','instructo','incepator',5,8);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    PROCEDURE testeaza_adaugare_nou_pianist
    IS
    BEGIN
        DELETE FROM PIANISTI WHERE grupe_id_grupa = 8;
        adaugare.nou_pianist('nou','pianist','profesionist',5,8);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_adaugare_nou_pianist_pentru_grupa_care_are_deja_unul
    IS
    BEGIN   
        adaugare.nou_pianist('nou','pianist','incepator',4,4);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    
    PROCEDURE testeaza_adaugare_nou_instructor_care_nu_corespunde_grupei
    IS
    BEGIN
        DELETE FROM INSTRUCTORI WHERE grupe_id_grupa = 8;
        adaugare.nou_instructor('nou','instructo','incepator',5,8);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    PROCEDURE testeaza_adaugare_nou_instructor
    IS
    BEGIN
        DELETE FROM INSTRUCTORI WHERE grupe_id_grupa = 8;
        adaugare.nou_instructor('nou','instructo','profesionist',5,8);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_adaugare_nou_instructor_pentru_grupa_care_are_deja_unul
    IS
    BEGIN   
        adaugare.nou_instructor('nou','instructor','incepator',4,4);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE testeaza_adaugare_elev_nou_care_ar_trb_sa_ajunga_in_grupa_2   
    IS
    BEGIN
        DELETE FROM elevi
        WHERE nume = 'elev'
        AND prenume = 'nou';
        adaugare.nou_elev('incepator','elev','nou',7);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
        
    PROCEDURE testeaza_adaugare_elev_nou_cu_varsta_invalida
    IS
    BEGIN
        adaugare.nou_elev('incepator','elev','nou',1);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    
    
    PROCEDURE testeaza_adaugare_elev_nou_cu_statut_invalid
    IS
    BEGIN
        adaugare.nou_elev('statutinvalid','elev','nou',7);
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE testeaza_adaugare_spectacol_cu_capacitate_invalida
    IS
    BEGIN
        adaugare.nou_spectacol('Trandafirii', -2,'2023-03-21');
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE testeaza_adaugare_spectacol_cu_data_invalida
    IS
    BEGIN
        adaugare.nou_spectacol('Trandafirii', 3,'202322-21');
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END testeaza_adaugare_spectacol_cu_data_invalida;
            
    PROCEDURE testeaza_adaugare_spectacol_cu_data_in_viitor
    IS
    BEGIN
        adaugare.nou_spectacol('Trandafirii', 3,'2023-09-21');
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
     PROCEDURE testeaza_adaugare_spectacol_corect
    IS
        v_spectacol_nume NUMBER;
    BEGIN
        SELECT count(*)
        INTO v_spectacol_nume
        FROM spectacole
        WHERE nume_spectacol = 'NOU';
        
        IF v_spectacol_nume > 0 THEN
            DELETE FROM spectacole
            WHERE nume_spectacol = 'NOU';
        END IF;
        
        adaugare.nou_spectacol('NOU',3,'2023-2-21');
    
         dbms_output.put_line('S-a adaugat spectacolul');
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_adaugare_elev_la_spectacol_unde_nu_mai_are_loc
    IS
    BEGIN
        DELETE FROM elevi_spectacol WHERE spectacole_id_spectacol = 29;
        adaugare.elev_la_spectacol(10,'Ghioceii');
        adaugare.elev_la_spectacol(11,'Ghioceii');
        adaugare.elev_la_spectacol(12,'Ghioceii');
        adaugare.elev_la_spectacol(13,'Ghioceii');
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END testeaza_adaugare_elev_la_spectacol_unde_nu_mai_are_loc;
    
    PROCEDURE testeaza_adaugare_elev_la_spectacol_inexistent
    IS
    BEGIN
        adaugare.elev_la_spectacol(13,'aaa');
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_adaugare_elev_inexistent_la_spectacol
    IS
    BEGIN
        adaugare.elev_la_spectacol(9999,'Dansand printre stele');
        EXCEPTION
         WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END;
END teste_adaugari;

select * from grupe;

CREATE OR REPLACE PACKAGE testare_vizualizari IS
    PROCEDURE testeaza_afisare_elevi;
    PROCEDURE testeaza_afisare_elevi_din_grupa_5;
    PROCEDURE testeaza_afisare_elevi_din_grupa_invalida;
    PROCEDURE testeaza_afisare_grupe_din_sala_invalida;
    PROCEDURE testeaza_afisare_pianistul_grupei_1;
    PROCEDURE testeaza_afisare_pianist_grupa_invalida;
    PROCEDURE testeaza_afisare_spectacole_la_care_nu_au_fost_introdusi_elevi;
    PROCEDURE testeaza_afisare_grupe_in_care_mai_incap_elevi;
END;
/
CREATE OR REPLACE PACKAGE BODY testare_vizualizari IS
    PROCEDURE testeaza_afisare_elevi
    IS
    BEGIN
        vizualizari.afiseaza_elevi;
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_afisare_elevi_din_grupa_5
    IS
    BEGIN
        vizualizari.afiseaza_elevi_din_anumita_grupa(5);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_afisare_elevi_din_grupa_invalida
    IS
    BEGIN
        vizualizari.afiseaza_elevi_din_anumita_grupa(99999);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_afisare_grupe_din_sala_invalida
    IS
    BEGIN
        vizualizari.afiseaza_grupele_asignate_unei_anumite_sali(9999);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_afisare_pianistul_grupei_1
    IS
    BEGIN
        vizualizari.afiseaza_pianistul_unei_grupe(1);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_afisare_pianist_grupa_invalida
    IS
    BEGIN
        vizualizari.afiseaza_pianistul_unei_grupe(999);
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_afisare_spectacole_la_care_nu_au_fost_introdusi_elevi
    IS
    BEGIN
        vizualizari.afiseaza_spectacolele_la_care_nu_au_fost_introdusi_elevi;
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE testeaza_afisare_grupe_in_care_mai_incap_elevi
    IS
    BEGIN
        vizualizari.afiseaza_grupe_in_care_mai_incap_elevi;
         EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
END;
SET SERVEROUTPUT ON;
EXECUTE testare_vizualizari.testeaza_afisare_grupe_in_care_mai_incap_elevi;
EXECUTE vizualizari.afiseaza_elevi_din_anumita_grupa(5);
EXECUTE vizualizari.afiseaza_elevi_din_anumita_grupa(99999);
EXECUTE vizualizari.afiseaza_grupele_asignate_unei_anumite_sali(9999);
EXECUTE vizualizari.afiseaza_pianistul_unei_grupe(1);
EXECUTE vizualizari.afiseaza_pianistul_unei_grupe(999);
EXECUTE vizualizari.afiseaza_spectacolele_la_care_nu_au_fost_introdusi_elevi;
EXECUTE vizualizari.afiseaza_grupe_in_care_mai_incap_elevi;


--tranzactie
CREATE OR REPLACE PACKAGE avansare_elevi IS
g_trigger_invoked BOOLEAN := FALSE;
  PROCEDURE modifica(p_id_elev elevi.id_elev%TYPE); 
END avansare_elevi;
/
CREATE OR REPLACE PACKAGE BODY avansare_elevi IS

    FUNCTION urmatoarul_statut
        (statut_curent elevi.statut%TYPE)
        RETURN elevi.statut%TYPE
        IS
            v_statut_nou elevi.statut%TYPE;
            statut_inexistent EXCEPTION;
            nu_mai_poate_avansa EXCEPTION;
            
        BEGIN
            IF statut_curent = 'incepator' THEN
                v_statut_nou := 'mediu';
            ELSIF statut_curent = 'mediu' THEN
                v_statut_nou := 'avansat';
            ELSIF statut_curent = 'avansat' THEN
                v_statut_nou := 'profesionist';
            ELSIF statut_curent = 'profesionist' THEN
                RAISE nu_mai_poate_avansa;
            ELSE 
                RAISE statut_inexistent;
            END IF;
            RETURN v_statut_nou;
            EXCEPTION
                when statut_inexistent THEN
                    RAISE_APPLICATION_ERROR(-20006, 'Statut invalid');
                WHEN nu_mai_poate_avansa THEN
                    RAISE_APPLICATION_ERROR(-20010, 'Elevul nu mai poate avansa');
                when others THEN    
                    dbms_output.put_line('Error: ' || SQLERRM);
    END urmatoarul_statut;

    PROCEDURE modifica
        (p_id_elev elevi.id_elev%TYPE)
        IS
            v_statut_nou elevi.statut%TYPE;
            v_statut_vechi elevi.statut%TYPE;
                
            TYPE date_table_type IS TABLE OF elevi.grupe_id_grupa%TYPE
                INDEX BY BINARY_INTEGER;
            data_table date_table_type;
            
            TYPE typ_spect_rec IS RECORD (
                id_grp grupe.id_grupa%TYPE);
            TYPE typ_spect IS REF CURSOR RETURN typ_spect_rec;
            
            
            grp typ_spect;
            indx NUMBER := 0;
            v_flag BOOLEAN;
            
            v_curent NUMBER;
            v_grupa_gasita BOOLEAN := false;
            
            inca_nu_avanseaza EXCEPTION;
            nu_exista_grupe_cu_acest_statut EXCEPTION;
            
            v_row_s elevi_spectacol%ROWTYPE;
    
    CURSOR c_spect IS
        SELECT * FROM elevi_spectacol
        WHERE elevi_id_elev = p_id_elev;
            
        BEGIN 
            verificari.verifica_daca_exista_elev(p_id_elev);
            
            SELECT statut
            INTO v_statut_vechi
            FROM elevi
            WHERE id_elev = p_id_elev;
            
            v_statut_nou := urmatoarul_statut(v_statut_vechi);
                       
            OPEN grp 
                FOR SELECT id_grupa
                FROM grupe
                WHERE statut = v_statut_nou;
            LOOP
                FETCH grp INTO data_table(indx);
                EXIT WHEN grp%NOTFOUND;
                indx := indx + 1;
            END LOOP;
            CLOSE grp;
                  
            v_curent := data_table.first;
            SAVEPOINT start_modifica;
             actualizari.modifica_statut_elev(p_id_elev, v_statut_nou); 
            WHILE v_curent <= data_table.last and v_grupa_gasita = false LOOP
                verifica_daca_incape_elev_in_grupa(data_table(v_curent), v_flag);
                IF v_flag = false THEN
                        
                    OPEN c_spect;
                        
                    LOOP    
                        FETCH c_spect INTO v_row_s;
                        EXIT when c_spect%NOTFOUND;
                        adaugare.elev_spect_istoric(p_id_elev, v_row_s.elevi_id_grupa, v_row_s.spectacole_id_spectacol);
                    END LOOP;
    
                    stergeri.sterge_spectacolele_la_care_a_participat_un_elev(p_id_elev);
                        
                    v_grupa_gasita := true;
                        
                    actualizari.modifica_elev_statut_grupa_sala(p_id_elev, data_table(v_curent), v_statut_nou);
                        
                    END IF;
                    v_curent := data_table.next(v_curent);
                END LOOP;
                IF v_grupa_gasita = false THEN    
                    ROLLBACK to start_modifica;
                    RAISE inca_nu_avanseaza;
                END IF;
                commit;
            EXCEPTION 
                    WHEN inca_nu_avanseaza THEN
                        rollback;
                        RAISE_APPLICATION_ERROR(-20007, 'Inca nu se poate muta elevul, se va astepta pana se elibereaza un loc');
                    WHEN nu_exista_grupe_cu_acest_statut THEN
                        rollback;
                        RAISE_APPLICATION_ERROR(-20008, 'Nu s-au gasit grupe cu acel statut');
                    when others THEN    
                        rollback;
                        dbms_output.put_line('Error: ' || SQLERRM);
                    
    END modifica;
    
END avansare_elevi;

--teste tranzactie
CREATE OR REPLACE PACKAGE teste_tranzactii IS
    PROCEDURE testeaza_tranzactie_avansare_elev_reusita_cu_succes;
    PROCEDURE revino_la_datele_de_dinainte_de_tranzactie_pentru_retestare;
    PROCEDURE testeaza_tranzactie_cu_elev_deja_profesionist;
    PROCEDURE testeaza_avansare_elev_care_nu_mai_are_loc_in_grupa_avansata;
END;
/

CREATE OR REPLACE PACKAGE BODY teste_tranzactii IS
    PROCEDURE testeaza_avansare_elev_care_nu_mai_are_loc_in_grupa_avansata
    IS
    BEGIN
        adaugare.elev_la_spectacol(33, 'Dansand printre stele');
        adaugare.elev_la_spectacol(33, 'Cinderella');
        
        dbms_output.put_line('Elevul inainte de tranzactie : ');
        vizualizari.afiseaza_elev(33);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev(33);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev_din_istoric(33);
        
        
        avansare_elevi.modifica(33);
        
        dbms_output.put_line('Elevul dupa tranzactie : ');
        vizualizari.afiseaza_elev(33);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev(33);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev_din_istoric(33);
    EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Elevul dupa ce a esuat tranzactia');
                vizualizari.afiseaza_elev(34);
                vizualizari.afiseaza_spectacole_la_care_a_participat_elev(34);
                vizualizari.afiseaza_spectacole_la_care_a_participat_elev_din_istoric(34);
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    
    PROCEDURE testeaza_tranzactie_avansare_elev_reusita_cu_succes
    IS
    BEGIN
        --se avanseaza elevul cu id-ul 34 care e incepator si e in grupa 1
        --el ar trebui avansat in unele din grupele 3 sau 4 cu statut mediu
        --dar 3 e plina, asa ca il va adauga in 4
        --spectacolele lui trebuie scoase din elevi_spectacol si adaugate la istoric 
        --(trebuie pastrata o evidenta concreta a elevilor care au participat la spectacole dupa schimbarea statutului
        --in caz ca se va tine cont de spectacolele la care au participat la avansarea lor)
        
        adaugare.elev_la_spectacol(34, 'Dansand printre stele');
        adaugare.elev_la_spectacol(34, 'Cinderella');
        
        dbms_output.put_line('Elevul inainte de tranzactie : ');
        vizualizari.afiseaza_elev(34);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev(34);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev_din_istoric(34);
        
        
        avansare_elevi.modifica(34);
        
        dbms_output.put_line('Elevul dupa tranzactie : ');
        vizualizari.afiseaza_elev(34);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev(34);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev_din_istoric(34);
        
        EXCEPTION
         WHEN OTHERS THEN
                
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE revino_la_datele_de_dinainte_de_tranzactie_pentru_retestare
    IS
    BEGIN
        DELETE FROM elevi_spectacol_istoric
        WHERE id_elev = 34;
        
        actualizari.modifica_elev_statut_grupa_sala(34,1,'incepator');
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
        
    END;
    
    PROCEDURE testeaza_tranzactie_cu_elev_deja_profesionist
    IS
    BEGIN
        adaugare.elev_la_spectacol(17, 'Dansand printre stele');
        adaugare.elev_la_spectacol(17, 'Cinderella');
        
        dbms_output.put_line('Elevul inainte de tranzactie : ');
        vizualizari.afiseaza_elev(17);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev(17);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev_din_istoric(17);
        
        
        avansare_elevi.modifica(17);
        
        dbms_output.put_line('Elevul dupa tranzactie : ');
        vizualizari.afiseaza_elev(17);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev(17);
        vizualizari.afiseaza_spectacole_la_care_a_participat_elev_din_istoric(17);
    END;
END;

SET SERVEROUTPUT ON;
EXECUTE teste_tranzactii.testeaza_tranzactie_avansare_elev_reusita_cu_succes;
EXECUTE teste_tranzactii.revino_la_datele_de_dinainte_de_tranzactie_pentru_retestare;
EXECUTE teste_tranzactii.testeaza_tranzactie_cu_elev_deja_profesionist;
EXECUTE teste_tranzactii.testeaza_avansare_elev_care_nu_mai_are_loc_in_grupa_avansata;



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