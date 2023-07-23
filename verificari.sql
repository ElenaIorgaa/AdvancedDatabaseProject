CREATE OR REPLACE PACKAGE verificari IS
    PROCEDURE verifica_daca_exista_elev(p_id_elev IN elevi.id_elev%TYPE);
    PROCEDURE verifica_daca_exista_deja_spectacol_cu_acest_nume(p_nume IN spectacole.nume_spectacol%TYPE);
    PROCEDURE verifica_daca_capacitatea_e_corecta(p_capacitate IN spectacole.capacitate%TYPE);
    PROCEDURE verifica_daca_exista_sala(p_id_sala IN sali.id_sala%TYPE);
    PROCEDURE verifica_daca_exista_instructor(p_id_instructor IN instructori.id_instructor%TYPE);
    PROCEDURE verifica_daca_exista_pianist(p_id_pianist IN pianisti.id_pianist%TYPE);
    PROCEDURE verifica_daca_exsita_grupa(p_id_grupa IN grupe.id_grupa%TYPE);
    PROCEDURE verifica_daca_grupa_are_nevoie_de_instructor(p_id_grupa IN grupe.id_grupa%TYPE);
    PROCEDURE verifica_daca_grupa_are_nevoie_de_pianist(p_id_grupa IN grupe.id_grupa%TYPE);
    PROCEDURE verifica_daca_statutul_corespunde_grupei(p_id_grupa IN grupe.id_grupa%TYPE, statt IN grupe.statut%TYPE);
    PROCEDURE verifica_daca_exista_spectacol_cu_acest_nume(p_nume IN spectacole.nume_spectacol%TYPE);
    PROCEDURE verifica_daca_statutul_e_valid(p_statut IN elevi.statut%TYPE);
END verificari;
/
CREATE OR REPLACE PACKAGE BODY verificari IS
    PROCEDURE verifica_daca_statutul_e_valid(p_statut IN elevi.statut%TYPE)
    IS
        statut_incorect EXCEPTION;
    BEGIN
        IF p_statut != 'incepator' and p_statut != 'mediu' and p_statut != 'avansat' and p_statut != 'profesionist' THEN
            RAISE statut_incorect;
        END IF;
        EXCEPTION
            WHEN statut_incorect THEN
                RAISE_APPLICATION_ERROR(-20008, 'Statutul este incorect');
    END;
    
    PROCEDURE verifica_daca_statutul_corespunde_grupei(p_id_grupa IN grupe.id_grupa%TYPE, statt IN grupe.statut%TYPE)
    IS
        v_statut grupe.statut%TYPE;
        nu_corespunde EXCEPTION;    
    BEGIN
        SELECT statut
        INTO v_statut
        FROM grupe
        WHERE id_grupa = p_id_grupa;
        
        IF statt != v_statut THEN
            RAISE nu_corespunde;
        END IF;
        
        EXCEPTION
            WHEN nu_corespunde THEN
                RAISE_APPLICATION_ERROR(-20069, 'Statutul cadrului didactic nu corespunde grupei');
    END;

    PROCEDURE verifica_daca_grupa_are_nevoie_de_pianist(p_id_grupa IN grupe.id_grupa%TYPE)
    IS
        nu_are_nevoie EXCEPTION;
        v_count_instructor NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count_instructor
        FROM pianisti
        WHERE grupe_id_grupa = p_id_grupa;
        
        IF v_count_instructor > 0 THEN
            RAISE nu_are_nevoie;
        END IF;
        
        EXCEPTION
            WHEN nu_are_nevoie THEN
                RAISE_APPLICATION_ERROR(-20035, 'Grupa are deja un pianist');
    END;

    PROCEDURE verifica_daca_grupa_are_nevoie_de_instructor(p_id_grupa IN grupe.id_grupa%TYPE)
    IS
        nu_are_nevoie EXCEPTION;
        v_count_instructor NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count_instructor
        FROM instructori
        WHERE grupe_id_grupa = p_id_grupa;
        
        IF v_count_instructor > 0 THEN
            RAISE nu_are_nevoie;
        END IF;
        
        EXCEPTION
            WHEN nu_are_nevoie THEN
                RAISE_APPLICATION_ERROR(-20036, 'Grupa are deja un instructor');
    END;

    PROCEDURE verifica_daca_exsita_grupa
        (p_id_grupa IN grupe.id_grupa%TYPE)
    IS
        v_nr_grupe NUMBER;   
        nu_exista_grupa EXCEPTION;
    BEGIN
        SELECT count(*)
        INTO v_nr_grupe
        FROM grupe
        WHERE id_grupa = p_id_grupa;
        
        IF v_nr_grupe = 0 THEN
            RAISE nu_exista_grupa;
        END IF;
        
        EXCEPTION
            when nu_exista_grupa then
                RAISE_APPLICATION_ERROR(-20049,'Nu exista grupa');
            when others THEN    
                        dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE verifica_daca_exista_instructor
        (p_id_instructor IN instructori.id_instructor%TYPE)
    IS
        v_nr_instructori NUMBER;   
        nu_exista_instructor EXCEPTION;
    BEGIN
        SELECT count(*)
        INTO v_nr_instructori
        FROM instructori
        WHERE id_instructor = p_id_instructor;
        
        IF v_nr_instructori = 0 THEN
            RAISE nu_exista_instructor;
        END IF;
        
        EXCEPTION
            when nu_exista_instructor then
                RAISE_APPLICATION_ERROR(-20050,'Nu exista instructor');
            when others THEN    
                        dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE verifica_daca_exista_pianist
        (p_id_pianist IN pianisti.id_pianist%TYPE)
    IS
        v_nr_pianisti NUMBER;   
        nu_exista_pianist EXCEPTION;
    BEGIN
        SELECT count(*)
        INTO v_nr_pianisti
        FROM pianisti
        WHERE id_pianist = p_id_pianist;
        
        IF v_nr_pianisti = 0 THEN
            RAISE nu_exista_pianist;
        END IF;
        
        EXCEPTION
            when nu_exista_pianist then
                RAISE_APPLICATION_ERROR(-20051,'Nu exista pianist');
            when others THEN    
                        dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE verifica_daca_exista_sala
        (p_id_sala IN sali.id_sala%TYPE)
    IS
        v_nr_sali NUMBER;   
        nu_exista_sala EXCEPTION;
    BEGIN
        SELECT count(*)
        INTO v_nr_sali
        FROM sali
        WHERE id_sala = p_id_sala;
        
        IF v_nr_sali = 0 THEN
            RAISE nu_exista_sala;
        END IF;
        
        EXCEPTION
            when nu_exista_sala then
                RAISE_APPLICATION_ERROR(-20058,'Nu exista sala');
            when others THEN    
                        dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE verifica_daca_exista_elev
        (p_id_elev IN elevi.id_elev%TYPE)
        IS
        CURSOR c IS
            SELECT nume
            FROM elevi
            WHERE id_elev = p_id_elev;
        v_nume elevi.nume%TYPE;
        inexistent EXCEPTION;
        BEGIN 
        OPEN c;
        FETCH c INTO v_nume;
        IF c%ROWCOUNT = 0 THEN
            RAISE inexistent;
        END IF;
        EXCEPTION
            WHEN inexistent THEN
                RAISE_APPLICATION_ERROR(-20003,'Nu exista elev');
    END verifica_daca_exista_elev;
    
    PROCEDURE verifica_daca_exista_spectacol_cu_acest_nume
    (p_nume IN spectacole.nume_spectacol%TYPE)
    IS
        v_nr_spectacole_cu_acest_nume NUMBER;
        spectacol_nu_exista EXCEPTION;
    BEGIN
        SELECT COUNT(*)
        INTO v_nr_spectacole_cu_acest_nume
        FROM spectacole
        WHERE nume_spectacol = p_nume;
        
        IF v_nr_spectacole_cu_acest_nume = 0 THEN
            RAISE spectacol_nu_exista;
        END IF; 
        EXCEPTION
            WHEN spectacol_nu_exista then
                RAISE_APPLICATION_ERROR(-20013, 'Nu exista un astfel de spectacol');
            when others THEN    
                        dbms_output.put_line('Error: ' || SQLERRM);
    END verifica_daca_exista_spectacol_cu_acest_nume;
    
    PROCEDURE verifica_daca_exista_deja_spectacol_cu_acest_nume
    (p_nume IN spectacole.nume_spectacol%TYPE)
    IS
        v_nr_spectacole_cu_acest_nume NUMBER;
        spectacol_deja_exista EXCEPTION;
    BEGIN
        SELECT COUNT(*)
        INTO v_nr_spectacole_cu_acest_nume
        FROM spectacole
        WHERE nume_spectacol = p_nume;
        
        IF v_nr_spectacole_cu_acest_nume > 0 THEN
            RAISE spectacol_deja_exista;
        END IF; 
        EXCEPTION
            WHEN spectacol_deja_exista then
                RAISE_APPLICATION_ERROR(-20009, 'Deja exista un spectacol cu acest nume');
            when others THEN    
                        dbms_output.put_line('Error: ' || SQLERRM);
    END verifica_daca_exista_deja_spectacol_cu_acest_nume;
    
    PROCEDURE verifica_daca_capacitatea_e_corecta
    (p_capacitate IN spectacole.capacitate%TYPE)
    IS
        capacitate_invalida EXCEPTION;
        v_number_value NUMBER;
    BEGIN 
        v_number_value := TO_NUMBER(p_capacitate);
        IF p_capacitate < 1 OR p_capacitate > 30 THEN
            RAISE capacitate_invalida;
        END IF;
        EXCEPTION
            WHEN VALUE_ERROR THEN
                RAISE_APPLICATION_ERROR(-20070, 'Capacitatea nu este un numar valid');
            WHEN capacitate_invalida THEN
                RAISE_APPLICATION_ERROR(-20070, 'Capacitatea nu este un numar valid');
    END;
    
END verificari;