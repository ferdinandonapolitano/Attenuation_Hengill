#!/bin/bash

#prima applichi questa piccola shell per mettere tutto in odine secondo la prima colonna
#il risultato sono tanti file con una selezione della prima colonna

#rm modPollino3D_UTM.ord.txt
#for i in {540000..640000..5000}
#do
#echo $i
#grep $i modPollino3D_UTM.txt > temp.$i.txt
#done

#qui invece ordini ogni singolo file ottenuto in precedenza per la y, ottenendo il file *.ord.txt
#il nome del file va cambiato manualmente

for j in {4360000..4480000..5000}
do
echo $j
grep $j temp.630000.txt >> temp.630000.ord.txt
done

for j in {4360000..4480000..5000}
do
echo $j
grep $j temp.635000.txt >> temp.635000.ord.txt
done

for j in {4360000..4480000..5000}
do
echo $j
grep $j temp.640000.txt >> temp.640000.ord.txt
done

#alla fine fai un cat di tutti i file *.ord.txt e ottieni il nuovo modello dove cambia prima la profondità (3 colon), poi Y (seconda) e poi x (prima)
