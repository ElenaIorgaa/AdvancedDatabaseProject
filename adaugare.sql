CREATE OR REPLACE PACKAGE adaugare IS
    PROCEDURE elev_la_spectacol (v_id_elev elevi.id_elev%TYPE, v_nume_spectacol spectacole.nume_spectacol%TYPE);
    PROCEDURE nou_spectacol(nume spectacole.nume_spectacol%TYPE, capac spectacole.capacitate%TYPE, dat VARCHAR2);
    PROCEDURE nou_elev(p_statut elevi.statut%TYPE, p_nume elevi.nume%TYPE, p_prenume elevi.prenume%TYPE, p_varsta elevi.varsta%TYPE);
    PROCEDURE nou_instructor(p_nume instructori.nume%TYPE, p_prenume instructori.prenume%TYPE, p_statut instructori.statut%TYPE, 
                            p_experienta instructori.experienta%TYPE, p_id_grupa instructori.grupe_id_grupa%TYPE);
    PROCEDURE nou_pianist(p_nume pianisti.nume%TYPE, p_prenume pianisti.prenume%TYPE, p_statut pianisti.statut%TYPE, 
                            p_experienta pianisti.experienta%TYPE, p_id_grupa pianisti.grupe_id_grupa%TYPE);
    PROCEDURE nou_grupa(p_statut grupe.statut%TYPE, p_id_sala sali.id_sala%TYPE);
    PROCEDURE nou_sala(p_dimensiune sali.dimensiune%TYPE, p_capacitate sali.capacitate%TYPE);
    PROCEDURE elev_spect_istoric(p_id_elev elevi.id_elev%TYPE, p_id_grupa grupe.id_grupa%TYPE, p_id_spectacol spectacole.id_spectacol%TYPE);
    PROCEDURE add_elev_to_grupa(p_nume IN elevi.nume%TYPE,
                                p_prenume IN elevi.prenume%TYPE,
                                p_varsta IN elevi.varsta%TYPE,
                                p_id_grupa IN elevi.grupe_id_grupa%TYPE);
END adaugare;
/

CREATE OR REPLACE PACKAGE BODY adaugare IS
    statut_invalid EXCEPTION;
    PRAGMA EXCEPTION_INIT(statut_invalid, -20082);


    PROCEDURE add_elev_to_grupa
(p_nume IN elevi.nume%TYPE,
p_prenume IN elevi.prenume%TYPE,
p_varsta IN elevi.varsta%TYPE,
p_id_grupa IN elevi.grupe_id_grupa%TYPE)
IS
        v_id_sala sali.id_sala%TYPE;
    v_statut elevi.statut%TYPE;
BEGIN
    verificari.verifica_daca_exsita_grupa(p_id_grupa);
    SELECT sali_id_sala
    INTO v_id_sala
    FROM grupe
    WHERE id_grupa = p_id_grupa;
    
    SELECT statut
    INTO v_statut
    FROM grupe
    WHERE id_grupa = p_id_grupa;

    INSERT INTO elevi(statut, nume, prenume, varsta, grupe_id_grupa, grupe_sali_id_sala)
    VALUES (v_statut, p_nume, p_prenume, p_varsta, p_id_grupa, v_id_sala);
    
    EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    
END;
   
   
    PROCEDURE elev_spect_istoric
        ( p_id_elev elevi.id_elev%TYPE, 
        p_id_grupa grupe.id_grupa%TYPE,
        p_id_spectacol spectacole.id_spectacol%TYPE)
    IS
    BEGIN
        INSERT INTO elevi_spectacol_istoric(id_elev, id_grupa, id_spectacol)
        VALUES(p_id_elev, p_id_grupa, p_id_spectacol);
        
    END;
    
    
    PROCEDURE nou_sala(p_dimensiune sali.dimensiune%TYPE, p_capacitate sali.capacitate%TYPE)
    IS
        capacitate_invalida EXCEPTION;
        dimensiune_invalida EXCEPTION;
    BEGIN
        IF p_dimensiune < 10 THEN 
            RAISE dimensiune_invalida;
        END IF;
        IF p_capacitate < 0 OR p_capacitate > 10 THEN
            RAISE capacitate_invalida;
        END IF;
        
        INSERT INTO SALI(dimensiune, capacitate)
        VALUES(p_dimensiune, p_capacitate);
        
        EXCEPTION
            when dimensiune_invalida then
                RAISE_APPLICATION_ERROR(-20057, 'Dimensiune invalida');
            when capacitate_invalida then
                RAISE_APPLICATION_ERROR(-20052, 'Capacitate invalida');
            WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    
    PROCEDURE nou_grupa(p_statut grupe.statut%TYPE, p_id_sala sali.id_sala%TYPE)
    IS
    BEGIN
        IF p_statut = 'incepator' OR p_statut = 'mediu' OR p_statut = 'avansat' OR p_statut = 'profesionist' THEN
            verificari.verifica_daca_exista_sala(p_id_sala);
            INSERT INTO grupe(statut, sali_id_sala)
            VALUES (p_statut, p_id_sala);
        ELSE
            RAISE statut_invalid;
        END IF;
        
        EXCEPTION
        when statut_invalid then
            RAISE_APPLICATION_ERROR(-20082, 'Statut invalid');
        WHEN OTHERS THEN
                    dbms_output.put_line('Error: ' || SQLERRM);   
    END;    
    
    PROCEDURE nou_pianist(p_nume pianisti.nume%TYPE, p_prenume pianisti.prenume%TYPE, p_statut pianisti.statut%TYPE, 
                            p_experienta pianisti.experienta%TYPE, p_id_grupa pianisti.grupe_id_grupa%TYPE)
    IS  
        experienta_invalida EXCEPTION;
        v_id_sala grupe.sali_id_sala%TYPE;
    BEGIN
        verificari.verifica_daca_grupa_are_nevoie_de_pianist(p_id_grupa);
        IF p_statut = 'incepator' OR p_statut = 'mediu' OR p_statut = 'avansat' OR p_statut = 'profesionist' THEN
            verificari.verifica_daca_exsita_grupa(p_id_grupa);
            IF p_experienta > 0 THEN
                verificari.verifica_daca_statutul_corespunde_grupei(p_id_grupa,p_statut);
                SELECT sali_id_sala
                INTO v_id_sala
                FROM grupe
                WHERE id_grupa = p_id_grupa;
                
                INSERT INTO pianisti(nume, prenume, statut, experienta, grupe_id_grupa, grupe_sali_id_sala)
                VALUES(p_nume,p_prenume, p_statut, p_experienta, p_id_grupa, v_id_sala);
            ELSE
                RAISE experienta_invalida;
            END IF;
        ELSE
            RAISE statut_invalid;
        END IF;
    EXCEPTION
        WHEN experienta_invalida then
            RAISE_APPLICATION_ERROR(-20076, 'Experienta introdusa este invalida');
        when statut_invalid then
            RAISE_APPLICATION_ERROR(-20082, 'Statut invalid');
        WHEN OTHERS THEN
                    dbms_output.put_line('Error: ' || SQLERRM);   
    END;
    
    
    PROCEDURE nou_instructor(p_nume instructori.nume%TYPE, p_prenume instructori.prenume%TYPE, p_statut instructori.statut%TYPE, 
                            p_experienta instructori.experienta%TYPE, p_id_grupa instructori.grupe_id_grupa%TYPE)
    IS  
        experienta_invalida EXCEPTION;
        v_id_sala grupe.sali_id_sala%TYPE;
    BEGIN
        verificari.verifica_daca_grupa_are_nevoie_de_instructor(p_id_grupa);
        IF p_statut = 'incepator' OR p_statut = 'mediu' OR p_statut = 'avansat' OR p_statut = 'profesionist' THEN
            verificari.verifica_daca_exsita_grupa(p_id_grupa);
            IF p_experienta > 0 THEN
                verificari.verifica_daca_statutul_corespunde_grupei(p_id_grupa,p_statut);
                SELECT sali_id_sala
                INTO v_id_sala
                FROM grupe
                WHERE id_grupa = p_id_grupa;
                
                INSERT INTO instructori(nume, prenume, statut, experienta, grupe_id_grupa, grupe_sali_id_sala)
                VALUES(p_nume,p_prenume, p_statut, p_experienta, p_id_grupa, v_id_sala);
            ELSE
                RAISE experienta_invalida;
            END IF;
        ELSE
            RAISE statut_invalid;
        END IF;
    EXCEPTION
        WHEN experienta_invalida then
            RAISE_APPLICATION_ERROR(-20076, 'Experienta introdusa este invalida');
        when statut_invalid then
            RAISE_APPLICATION_ERROR(-20082, 'Statut invalid');
        WHEN OTHERS THEN
                    dbms_output.put_line('Error: ' || SQLERRM);   
    END;


    PROCEDURE nou_elev
        (p_statut elevi.statut%TYPE, 
        p_nume elevi.nume%TYPE, 
        p_prenume elevi.prenume%TYPE, 
        p_varsta elevi.varsta%TYPE)
    IS
        varsta_invalida EXCEPTION;  
        CURSOR c IS
            SELECT id_grupa
            FROM grupe
            WHERE statut = p_statut;
        v_flag BOOLEAN;
        v_id_grupa grupe.id_grupa%TYPE;
        v_grupa_gasita BOOLEAN := false;
        v_id_sala sali.id_sala%TYPE;
    BEGIN
     IF p_statut = 'incepator' OR p_statut = 'mediu' OR p_statut = 'avansat' OR p_statut = 'profesionist' THEN
        IF p_varsta >= 4 AND p_varsta <= 30 THEN
            OPEN c;
            LOOP
                FETCH c INTO v_id_grupa;
                EXIT WHEN c%NOTFOUND OR v_grupa_gasita = true;
                dbms_output.put_line('Eu trimit '||v_id_grupa);
                verifica_daca_incape_elev_in_grupa(v_id_grupa, v_flag);
                    IF v_flag = false THEN
                        v_grupa_gasita := true;
                        
                        SELECT sali_id_sala 
                        INTO v_id_sala
                        FROM grupe
                        WHERE id_grupa = v_id_grupa;
                        
                        dbms_output.put_line('INCERC SA IL INTRODUC IN grupa '||v_id_grupa);
                        INSERT INTO elevi(statut,nume, prenume, varsta, grupe_id_grupa, grupe_sali_id_sala)
                        VALUES (p_statut, p_nume, p_prenume, p_varsta, v_id_grupa, v_id_sala);
                        COMMIT;
                        
                    END IF;
            END LOOP;
            CLOSE c;
        ELSE
            RAISE varsta_invalida;
        END IF;
        ELSE
            RAISE statut_invalid;
    END IF;
    EXCEPTION
        when varsta_invalida THEN
            RAISE_APPLICATION_ERROR(-20081, 'Varsta introdusa nu este valida');
        when statut_invalid then
            RAISE_APPLICATION_ERROR(-20082, 'Statut invalid');
        WHEN OTHERS THEN
                    dbms_output.put_line('Error: ' || SQLERRM);   
    END;

    PROCEDURE elev_la_spectacol (
            v_id_elev elevi.id_elev%TYPE,
            v_nume_spectacol spectacole.nume_spectacol%TYPE
        )
    IS
        v_id_spectacol spectacole.id_spectacol%TYPE;
         v_id_grupa grupe.id_grupa%TYPE;
        v_id_sala sali.id_sala%TYPE;

        TYPE typ_spect_rec IS RECORD (
            id_spectacol spectacole.id_spectacol%TYPE
        );
        TYPE typ_spect IS REF CURSOR RETURN typ_spect_rec;
        spect typ_spect;

        TYPE typ_grup_rec IS RECORD (
            id_grupa elevi.grupe_id_grupa%TYPE,
           id_sala grupe.sali_id_sala%TYPE
        );
        TYPE typ_grup IS REF CURSOR RETURN typ_grup_rec;
        grup typ_grup;

        nu_exista_spectacol EXCEPTION;
        nu_exista_elev EXCEPTION;
    BEGIN
        OPEN spect FOR
            SELECT id_spectacol
            FROM spectacole
            WHERE nume_spectacol = v_nume_spectacol;
            
        FETCH spect INTO v_id_spectacol;
        
        IF spect%ROWCOUNT = 0 THEN
            CLOSE spect; -- Close the cursor if no data found
            RAISE nu_exista_spectacol;
        END IF;
        
        OPEN grup FOR
            SELECT grupe_id_grupa, grupe_sali_id_sala
            FROM elevi
            WHERE id_elev = v_id_elev;
            
        FETCH grup INTO v_id_grupa, v_id_sala;
        
        IF grup%ROWCOUNT = 0 THEN
            CLOSE grup; -- Close the cursor if no data found
            RAISE nu_exista_elev;
        END IF;
        
    INSERT INTO elevi_spectacol (elevi_id_elev, elevi_id_grupa, elevi_id_sala, spectacole_id_spectacol)
    VALUES (v_id_elev, v_id_grupa, v_id_sala, v_id_spectacol);
    dbms_output.put_line('adaugat');
    COMMIT;

    EXCEPTION
        WHEN nu_exista_spectacol THEN
            RAISE_APPLICATION_ERROR(-20001, 'Nu exista spectacol cu acest nume');
        WHEN nu_exista_elev THEN
            RAISE_APPLICATION_ERROR(-20003, 'Nu exista elevul pe care incercati sa il adaugati');
        WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
    END elev_la_spectacol;
    
    PROCEDURE nou_spectacol
        (nume IN spectacole.nume_spectacol%TYPE,
        capac IN spectacole.capacitate%TYPE,
        dat IN VARCHAR2)
    IS
        v_date spectacole.data_spectacol%type;
    BEGIN 
        dbms_output.put_line('incerc data '||TO_DATE(dat, 'YYYY-MM-DD'));
        v_date := TO_DATE(dat, 'YYYY-MM-DD');
        
        
        verificari.verifica_daca_exista_deja_spectacol_cu_acest_nume(nume);
        verificari.verifica_daca_capacitatea_e_corecta(capac);
        
        INSERT INTO spectacole(nume_spectacol, capacitate,data_spectacol)
        VALUES(nume, capac, v_date);
        
        EXCEPTION

            WHEN VALUE_ERROR THEN
                RAISE_APPLICATION_ERROR(-20094, 'Input value is not a valid date');
            WHEN OTHERS THEN
                IF SQLCODE = -1861 THEN
                    RAISE_APPLICATION_ERROR(-20001, 'Data introdusa este invalida.');
                ELSE
                    dbms_output.put_line('Error: ' || SQLERRM);   
                END IF;
    END;
END adaugare;
