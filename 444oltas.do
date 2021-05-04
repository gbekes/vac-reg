** 444 data
* download from 
*https://444.hu/2021/05/04/az-antitestteszteken-a-pfizer-latvanyos-szamokat-produkal-a-kinai-oltas-utani-negativ-eredmenyekbol-kaptuk-a-legtobbet



* cd "your library"
clear
import delimited "xSvut.csv", varnames(1) encoding(UTF-8) 


* cleaning
destring érték, ignore(","  ">" "<") generate(ertek0) force
replace érték = "1000" if érték=="maximum"
destring határérték , ignore(","  ">" "<" "≤" ) generate(hatarertek0) force
replace oltásfajtája ="AstraZeneca" if oltásfajtája=="Astrazeneca"
replace oltásfajtája ="Pfizer/Moderna" if oltásfajtája=="Pfizer" | oltásfajtája=="Moderna"

encode oltásfajtája, gen (type)

gen female=nem=="nő"
destring elteltnapok , gen (days) force

* variables
gen ratio=ertek0 / hatarertek0
gen effect=ratio>=1
tab type
	table type, c(mean ratio)
	table type, c(median ratio)
	tab days2
	lpoly ratio days, noscat
egen days2=cut(days), at(0,20,40,60,500) /*bc non linear pattern*/

* unconditional and conditional models, Pfizer/Moderna is base type 
reg effect ib(2).type 
reg effect ib(2).type életkor female i.days2