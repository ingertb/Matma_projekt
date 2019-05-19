#-----------------------------------------------------------------------
#liczba węzły, łuki, zapotrzebowań oraz ścieżek:
#-----------------------------------------------------------------------
param Vn, integer, >= 2;  #liczba węzły
param En, integer, >= 1;  #liczba łuki
param Dn, integer, >= 1;  #liczba zapotrzebowań 
#-----------------------------------------------------------------------
#***********************************************************************
#-----------------------------------------------------------------------
#Indeksy:
#-----------------------------------------------------------------------
set V, default {1..Vn};
set E, default {1..En};
set D, default {1..Dn};
#-----------------------------------------------------------------------
#***********************************************************************
#-----------------------------------------------------------------------
#Stałe:
#-----------------------------------------------------------------------
param h{D} >= 0;  			    #Rozmiar zapotrzebowań
param K{E} >= 0; 			    #Koszt użyć łuku
param s{D} >= 0;               #węzeł żródłowy 
param t{D} >= 0;               #węzeł docelowy   
param A{E,V}, >= 0, default 0; #rozpoczyna się w węzeł v
param B{E,V}, >= 0, default 0; #kończy się w węzeł v
param W, integer, >= 0, default 9000000; #wystarczająco duża wartość
param kol{E} >= 0, default 5;    #Koszt otwarcia łuku
param Kow{V} >= 0, default 5;  #Koszt otwarcia wierzchołki
param C{E} >= 0, default 8;    #przepływność dostępną na łączu
param G{V} >= 0;				#stopień węzła
#-----------------------------------------------------------------------
#***********************************************************************
#-----------------------------------------------------------------------
#Zmienne:
#-----------------------------------------------------------------------
var x{e in E, d in D} >= 0;    #Wielkość  przepływności  zapotrzebowań na łuku
var y{e in E} >= 0;            #Wielkość przepływności na łuku
var Ue{e in E}, binary;         #Ue = 1 jeśli łącze e jest zainstalowane
var Uw{v in V}, binary;		    #Uw = 1 jeśli węzeł jest zainstalowane
#-----------------------------------------------------------------------
#***********************************************************************
#-----------------------------------------------------------------------
#Funkcja celu:
#-----------------------------------------------------------------------
#minimize z: sum{e in E} (K[e]*y[e] + kol[e]*Ue[e]) + sum{v in V} (Kow[v]*Uw[v]);
minimize z: sum{e in E} (K[e]*y[e]);
#-----------------------------------------------------------------------
#***********************************************************************
#-----------------------------------------------------------------------
#Ograniczenia: bifurcated and non-bifurcated
#-----------------------------------------------------------------------
#Wielkość  przepływności  zapotrzebowań na łuku
s.t. c1{d in D, v in V : v == s[d]} : sum{e in E} (A[e,v]*x[e,d] - B[e,v]*x[e,d]) = h[d];
s.t. c2{d in D, v in V : v != s[d] and v != t[d]} : sum{e in E} (A[e,v]*x[e,d] - B[e,v]*x[e,d]) = 0;
s.t. c3{d in D, v in V : v == t[d]} : sum{e in E} (A[e,v]*x[e,d] - B[e,v]*x[e,d]) = -h[d];
#Wielkość przepływności na łuku
s.t. c4{e in E} : sum{d in D} x[e,d] = y[e];
#pojemność wierzchołków
s.t. c5{e in E} : y[e] <= C[e];
#otwarcie łuków
#s.t. c6{e in E} : y[e] <= W*Ue[e]; 
# otwarcie wierzchołków   						
#s.t. c7{v in V} : sum{e in E} (B[e,v]*Ue[e]) <= G[v]*Uw[v]; 
#-----------------------------------------------------------------------
#***********************************************************************
#-----------------------------------------------------------------------
end;
#-----------------------------------------------------------------------
