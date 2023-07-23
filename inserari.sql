
BEGIN
   EXECUTE adaugare.nou_sala(350, 10);
   EXECUTE adaugare.nou_sala(450, 10);
   EXECUTE adaugare.nou_sala(450, 10);
   EXECUTE adaugare.nou_sala(500, 10);
   EXECUTE adaugare.nou_sala(500, 10);
   EXECUTE adaugare.nou_sala(550, 10);
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;

BEGIN
   EXECUTE adaugare.nou_grupa('incepatori', 1);
   EXECUTE adaugare.nou_grupa('incepatori', 2);
   EXECUTE adaugare.nou_grupa('mediu', 3);
   EXECUTE adaugare.nou_grupa('mediu', 4);
   EXECUTE adaugare.nou_grupa('avansati', 5);
   EXECUTE adaugare.nou_grupa('avansati', 6);
   EXECUTE adaugare.nou_grupa('profesionisti', 1);
   EXECUTE adaugare.nou_grupa('profesionisti', 2);
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;

BEGIN
   EXECUTE adaugare.nou_instructor('tr1s', 'Alina', 'incepator', 5, 1);
   EXECUTE adaugare.nou_instructor('Abdul', 'Mihai', 'incepator', 5, 2);
   EXECUTE adaugare.nou_instructor('Popescu', 'Mara', 'mediu', 10, 3);
   EXECUTE adaugare.nou_instructor('Cozma', 'Maria', 'mediu', 10, 4);
   EXECUTE adaugare.nou_instructor('Popscu', 'Ion', 'avansat', 15, 5);
   EXECUTE adaugare.nou_instructor('Catinca', 'Teodora', 'avansat', 15, 6);
   EXECUTE adaugare.nou_instructor('Toma', 'Alexandru', 'profesionist', 20, 7);
   EXECUTE adaugare.nou_instructor('Iftim', 'Beatrice', 'profesionist', 20, 8);
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;

BEGIN
   EXECUTE adaugare.nou_pianist('Camaru', 'Andrei', 'incepator', 5, 1);
   EXECUTE adaugare.nou_pianist('Titu', 'Maiorescu', 'incepator', 5, 2);
   EXECUTE adaugare.nou_pianist('Felix', 'Otilia', 'mediu', 10, 3);
   EXECUTE adaugare.nou_pianist('Zeus', 'Mihai', 'mediu', 10, 4);
   EXECUTE adaugare.nou_pianist('Comarn', 'Maria', 'avansat', 15, 5);
   EXECUTE adaugare.nou_pianist('Zamfir', 'Romeo', 'avansat', 15, 6);
   EXECUTE adaugare.nou_pianist('Ciuchina', 'Matei', 'profesionist', 20, 7);
   EXECUTE adaugare.nou_pianist('Aron', 'Delia', 'profesionist', 20, 8);
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;

BEGIN
   EXECUTE adaugare.nou_elev('incepator', 'Toma', 'Darius', 6);
   EXECUTE adaugare.nou_elev('incepator', 'Mihai', 'Alina', 6);
   EXECUTE adaugare.nou_elev('mediu', 'Cozma', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Popescu', 'Camila', 8);
   EXECUTE adaugare.nou_elev('avansat', 'Teodor', 'Maria', 9);
   EXECUTE adaugare.nou_elev('avansat', 'Toporau', 'Cosmina', 10);
   EXECUTE adaugare.nou_elev('profesionist', 'Ungureanu', 'Mihaela', 6);
   EXECUTE adaugare.nou_elev('profesionist', 'Istrate', 'Renata', 6);
   EXECUTE adaugare.nou_elev('mediu', 'Cana', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Tris', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Tor', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Afro', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Mecam', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Tina', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Rin', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Ego', 'Andreea', 8);
   EXECUTE adaugare.nou_elev('mediu', 'Ton', 'Andreea', 8);
   
   EXECUTE adaugare.nou_elev('incepator', 'Dima', 'Darius', 6);
   EXECUTE adaugare.nou_elev('incepator', 'Cazat', 'Irina', 7);
   EXECUTE adaugare.nou_elev('incepator', 'Musca', 'Maria', 5);
   EXECUTE adaugare.nou_elev('incepator', 'Pacala', 'Erica', 8);
   EXECUTE adaugare.nou_elev('incepator', 'Potter', 'Ioana', 5);
   EXECUTE adaugare.nou_elev('incepator', 'Dimirie', 'Lucia', 6);
   EXECUTE adaugare.nou_elev('incepator', 'Cotu', 'Alex', 6);
   EXECUTE adaugare.nou_elev('incepator', 'Lama', 'Emina', 7);
   EXECUTE adaugare.nou_elev('incepator', 'Erm', 'Dana', 8);
   
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;

BEGIN
   EXECUTE adaugare.nou_spectacol('Dansand printre stele', 8, '19-JAN-2021');
   
   EXECUTE adaugare.nou_spectacol('Cinderella', 10, '19-JUN-2021');
   
   EXECUTE adaugare.nou_spectacol('Spargatorul de nuci', 9, '19-JUL-2021');
   
   EXECUTE adaugare.nou_spectacol('Moby Dick', 7, '19-JAN-2021');
   
   EXECUTE adaugare.nou_spectacol('Nopti albe', 10, '23-FEB-2021');
   
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
END;
EXECUTE adaugare.add_elev_to_grupa('elev1','elev1',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev2','elev2',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev3','elev3',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev4','elev4',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev5','elev5',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev6','elev6',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev7','elev7',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev8','elev8',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev9','elev9',7,5);
EXECUTE adaugare.add_elev_to_grupa('elev10','elev10',7,5);

EXECUTE adaugare.add_elev_to_grupa('elev1','elev1',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev2','elev2',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev3','elev3',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev4','elev4',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev5','elev5',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev6','elev6',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev7','elev7',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev8','elev8',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev9','elev9',7,6);
EXECUTE adaugare.add_elev_to_grupa('elev10','elev10',7,6);
