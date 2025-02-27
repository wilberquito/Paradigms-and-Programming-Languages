% llista1(?L) 
% llista(L) ==>  L es una llista d'un sol element


%sumatori(+L,?S)
%sumatori(L,X) ==> L es una llista de nombres i el seu sumatori és X


%producte(+L,?P)
%producte(L,P) ==> L es una llista de nombres i el seu producte és X
%nota: per definició, el producte d'un conjunt buit és 1



%llargada(?L,?N)
%llargada(L,N) ==> L es una llista de llargada N



%pertany(?X,?L)
%pertany(X,L) ==> L es una llista que conté l'element X
%es demostra tantes vegades com L contingui X



%comptar(+X,+L,?N)
%comptar(X,L,N) ==> L es una llista que conté l'element X un total de N vegades



%afegirFinal(?X,?L1,?L2)
%afegirFinal(X,L1,L2) ==> L2 és la llista L1 amb X al final



%capgira(?L1,?L2)
%capgira(L1,L2) ==> L2 és la llista L1 capgirada



%parells(+L1,?L2)
%parells(L1,L2) ==> L1 és una llista d'enters, i L2 és la llista L1 conservant només els nombres parells



%concatenar(?L1,?L2,?L3)
%concatenar(L1,L2,L3) ==> L3 és el resultat de concatenar les llistes L1 i L2



%ordenada(+L)
%ordenada(L) ==> L és una llista de nombres ordenada de menor a major



%inserir(+X,+L1,?L2)
%inserir(X,L1,L2) ==> L2 és el resultat d'inserir X a la posició corresponent de la llista de nombres ordenada L1



%ordenar(+L1,?L2)
%ordenar(L1,L2) ==> L2 és la llista de nombres L1 ordenada



%obtenirBool(0Consulta,-resposta) ==> si la consulta es satisfà, resposta és si, altrament resposta és no
obtenirBool(Consulta,si):-call(Consulta),!.
obtenirBool(_,no).

main:-mainAux,!.
main.

mainAux:-
  write('Llista: '),
	read(Llista),
  write(Llista), nl,
  write('Nivell de comprovacions {1,2,3}: '),
	read(Nivell),
  write(Nivell), nl,
	write('Sumatori: '), !, sumatori(Llista,Sum), write(Sum),nl,
  write('Producte: '), !, producte(Llista,Prod),write(Prod),nl,
  write('Llargada: '), !, llargada(Llista,Ll), write(Ll),nl,
  !,Nivell >= 2, 
  X=2, Y=4,
  format('Conte el ~d? ',[X]),!, obtenirBool(pertany(Llista,X),Pertany), write(Pertany), nl,
  format('Quantes vegades conte el ~d? ',[Y]),!, comptar(Y,Llista,Recompte), write(Recompte), nl,
  write('Capgirada: '),!, capgira(Llista,Capgirada), write(Capgirada), nl,
  write('Membres parells: '),!, parells(Llista,Parells), write(Parells), nl,
  !,Nivell>=3,
  write('Esta ordenada? '),!, obtenirBool(ordenada(Llista),Ordenada), write(Ordenada), nl,
  write('Concatena amb ella mateixa: '), !, concatenar(Llista,Llista,Conc), write(Conc),nl,
  write('Concatena amb ella mateixa i ordena: '), !, ordenar(Conc,Ord), write(Ord),nl,
  !.
