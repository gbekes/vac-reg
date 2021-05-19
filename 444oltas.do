* oltas teszt
* v2 based on second 444 piece (they renamed vars...)


** 444 data download from 
*https://444.hu/2021/05/19/van-aki-nem-hagyja-annyiban-hogy-az-oltas-utan-negativ-az-antitesttesztje

* cd "your library"
clear
import delimited "data-CwyqI.csv", varnames(1) encoding(UTF-8) 


rename v9 hatar  
rename oltás oltas 
rename v3 dose

* cleaning
replace érték = "1000" if inlist(érték, "maximum" "max", "maximum", "nagyon erős")
destring érték, ignore(","  ">" "<") generate(ertek0) force
destring hatar , ignore(","  ">" "<" "≤" ) generate(hatarertek0) force
replace oltas="AstraZeneca" if oltas=="Astrazeneca"
replace oltas="Pfizer/Moderna" if oltas=="Pfizer" | oltas=="Moderna"
replace oltas="Szputnyik" if oltas=="Szputnyik "

encode oltas, gen (type)
destring kor, replace force 
gen female=nem=="nő"
destring nap , gen (days) force

* variables
gen ratio=ertek0 / hatarertek0
gen effective=ratio>=1
tab type
table type, c(mean ratio)
table type, c(median ratio)
hist days
lpoly effective days, noscat
egen days2=cut(days), at(0,20,40,60,500) /*bc non linear pattern*/


* unconditional LPM model, Pfizer/Moderna is base type 
reg effective ib(2).type 
* Conditional LPM model, Pfizer/Moderna is base type 
reg effective ib(2).type kor female i.days2##i.dose