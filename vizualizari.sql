CREATE OR REPLACE PACKAGE vizualizari IS
    PROCEDURE afiseaza_elevi;
    PROCEDURE afiseaza_elevi_din_anumita_grupa(p_id_grupa grupe.id_grupa%TYPE);
    PROCEDURE afiseaza_grupele_asignate_unei_anumite_sali(p_id_sala sali.id_sala%TYPE);
    PROCEDURE afiseaza_pianistul_unei_grupe(p_id_grupa grupe.id_grupa%TYPE);
    PROCEDURE afiseaza_spectacolele_la_care_nu_au_fost_introdusi_elevi;
    PROCEDURE afiseaza_grupe_in_care_mai_incap_elevi;
    PROCEDURE afiseaza_elev(p_id_elev elevi.id_elev%TYPE);
    PROCEDURE afiseaza_spectacole_la_care_a_participat_elev(p_id_elev elevi.id_elev%TYPE);
    PROCEDURE afiseaza_spectacole_la_care_a_participat_elev_din_istoric(p_id_elev elevi.id_elev%TYPE);
END;
/
CREATE OR REPLACE PACKAGE BODY vizualizari IS   
    PROCEDURE afiseaza_spectacole_la_care_a_participat_elev(p_id_elev elevi.id_elev%TYPE)
    IS
        CURSOR c IS
            SELECT id_spectacol
            FROM elevi_spectacol_istoric
            WHERE id_elev = p_id_elev;
        v_id_spectacol spectacole.id_spectacol%TYPE;
    BEGIN
        verificari.verifica_daca_exista_elev(p_id_elev);
        dbms_output.put_line('Spectacolele din istoric la care a participat elevul: ');
        OPEN c;
        LOOP
            FETCH c INTO v_id_spectacol;
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line(v_id_spectacol);
        END LOOP;
        CLOSE c;
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE afiseaza_spectacole_la_care_a_participat_elev_din_istoric(p_id_elev elevi.id_elev%TYPE)
    IS
        CURSOR c IS
            SELECT spectacole_id_spectacol
            FROM elevi_spectacol
            WHERE elevi_id_elev = p_id_elev;
        v_id_spectacol spectacole.id_spectacol%TYPE;
    BEGIN
        verificari.verifica_daca_exista_elev(p_id_elev);
        dbms_output.put_line('Spectacolele la care a participat elevul: ');
        OPEN c;
        LOOP
            FETCH c INTO v_id_spectacol;
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line(v_id_spectacol);
        END LOOP;
        
        CLOSE c;
        
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE afiseaza_elev(p_id_elev elevi.id_elev%TYPE)
    IS  
        v_elev elevi%ROWTYPE;
    BEGIN
        verificari.verifica_daca_exista_elev(p_id_elev);
        
        SELECT * 
        INTO v_elev
        FROM elevi
        WHERE id_elev = p_id_elev;
        
        dbms_output.put_line('Elevul cu id-ul '||p_id_elev||' este :' || v_elev.nume||' '||v_elev.prenume||' aflat in grupa '||v_elev.grupe_id_grupa||'cu statutul de ' || v_elev.statut||' cu varsta de '||v_elev.varsta);
    
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;

    PROCEDURE afiseaza_grupe_in_care_mai_incap_elevi
    IS
        CURSOR c IS
            SELECT * FROM grupe;
        v_row grupe%ROWTYPE;
        v_capacitate sali.capacitate%TYPE;
        v_nr_elevi NUMBER;  
        v_e NUMBER;
    BEGIN
        OPEN c;
        LOOP
            FETCH c INTO v_row;
            EXIT WHEN c%NOTFOUND;
            
            SELECT capacitate
            INTO v_capacitate
            FROM sali
            WHERE id_sala = v_row.sali_id_sala;
            
            SELECT COUNT(*)
            INTO v_nr_elevi
            FROM elevi
            WHERE grupe_id_grupa = v_row.id_grupa;
            
            IF v_nr_elevi < v_capacitate THEN
                v_e := v_capacitate - v_nr_elevi;
                dbms_output.put_line('In grupa '||v_row.id_grupa||' mai incap '||v_e||' elevi.');
            END IF;
            
        END LOOP;
            
    END;

    PROCEDURE afiseaza_spectacolele_la_care_nu_au_fost_introdusi_elevi
    IS
        CURSOR c IS
            SELECT * FROM spectacole;
        v_nr_elevi NUMBER;
        v_nr_elevi_istoric NUMBER;
        v_row spectacole%ROWTYPE;
        v_flag BOOLEAN := false;
    BEGIN 
        OPEN c;
        LOOP
            FETCH c INTO v_row;
            EXIT WHEN c%NOTFOUND;
            
            SELECT count(*) INTO v_nr_elevi
            FROM elevi_spectacol
            WHERE spectacole_id_spectacol = v_row.id_spectacol;
            
            SELECT count(*) INTO v_nr_elevi_istoric
            FROM elevi_spectacol_istoric    
            WHERE id_spectacol = v_row.id_spectacol;
            
            v_nr_elevi := v_nr_elevi + v_nr_elevi_istoric;
            IF v_nr_elevi = 0 THEN
                v_flag := true;
                dbms_output.put_line('Spectacolul '||v_row.nume_spectacol||' nu are niciun elev introdus');
            END IF;   
        END LOOP;
        CLOSE c;
        IF v_flag = false THEN
            dbms_output.put_line('Nu sau gasit spectacole la care sa nu fi fost introdus niciun elev ');
        END IF;
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END; 
    
    PROCEDURE afiseaza_pianistul_unei_grupe
        (p_id_grupa grupe.id_grupa%TYPE)
    IS 
        CURSOR c IS
            SELECT *
            FROM pianisti
            WHERE grupe_id_grupa = p_id_grupa;
        v_row pianisti%ROWTYPE;
    BEGIN 
        dbms_output.put_line('Pianistul grupei '||p_id_grupa||' este: ');
        verificari.verifica_daca_exsita_grupa(p_id_grupa);
        OPEN c;
        LOOP
            FETCH c INTO v_row;
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line(v_row.nume||' '||v_row.prenume);
        END LOOP;
            
    END;

    PROCEDURE afiseaza_elevi
    IS
        CURSOR c IS
            SELECT *
            FROM elevi;
        v_elev elevi%ROWTYPE;
    BEGIN
    
        OPEN c;
        LOOP
            FETCH c INTO v_elev;
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line('Elevul : '||v_elev.nume||' '||v_elev.prenume||' cu varsta '||v_elev.varsta||' cu statutul '||v_elev.statut||' este in grupa '||v_elev.grupe_id_grupa);
        END LOOP;
        CLOSE c;
    END;
    
    PROCEDURE afiseaza_elevi_din_anumita_grupa
        (p_id_grupa grupe.id_grupa%TYPE)
    IS
        CURSOR c IS
            SELECT *
            FROM elevi
            WHERE grupe_id_grupa = p_id_grupa;
        v_elev elevi%ROWTYPE;
    BEGIN
        verificari.verifica_daca_exsita_grupa(p_id_grupa);
        OPEN c;
        dbms_output.put_line('Elevii grupei '||p_id_grupa||' sunt: ');
        LOOP
            FETCH c INTO v_elev;
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line('Elevul : '||v_elev.nume||' '||v_elev.prenume||' cu varsta '||v_elev.varsta||' cu statutul '||v_elev.statut);
        END LOOP;
        IF c%ROWCOUNT = 0 THEN
            dbms_output.put_line('Nu sunt elevi in aceasta grupa ');
        END IF;
        CLOSE c;
        
         EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;
    
    PROCEDURE afiseaza_grupele_asignate_unei_anumite_sali
        (p_id_sala sali.id_sala%TYPE)
    IS 
        CURSOR c IS
        SELECT * 
        from grupe 
        WHERE sali_id_sala = p_id_sala;
        v_row grupe%ROWTYPE;
    BEGIN
        verificari.verifica_daca_exista_sala(p_id_sala);
        dbms_output.put_line('Grupele asignate salii '||v_row.sali_id_sala||' sunt: ');
        OPEN c;
        LOOP
            FETCH c INTO v_row;
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line('Grupa '||v_row.id_grupa);
        END LOOP;
         IF c%ROWCOUNT = 0 THEN
            dbms_output.put_line('Nu s-au gasit grupe ');
        END IF;
        CLOSE c;
        EXCEPTION
         WHEN OTHERS THEN
                dbms_output.put_line('Error: ' || SQLERRM);
    END;     
END;