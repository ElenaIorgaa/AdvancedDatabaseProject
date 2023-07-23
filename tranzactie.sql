
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

select * from elevi;
select * from grupe;