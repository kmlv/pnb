set more off

cd D:\Drive\DataPNB\Rawdata\RawdataInterna\ExamenB18_2018
import excel "Resultados - PRONABEC2018.xlsx", sheet("Sheet 1") firstrow ///
allstring clear

rename MODALIDAD mod
rename MATEMÁTICA mate
rename LECTURA lect
rename REDACCIÓN redac
rename COMUNICACIÓN comu
rename ESCALADOMATEMÁTICA e_mate
rename ESCALADOCOMUNICACIÓ e_comu
rename PUNTAJEFINAL puntaje
rename MÉRITOTOTAL merito_tot
rename MÉRITOMODALIDAD merito_mod

destring mate lect redac comu e_mate e_comu puntaje merito_tot merito_mod, ///
replace

replace mod=rtrim(mod)

*Crear grupos de dummies
gen ordinaria = 0
replace ordinaria = 1 if mod=="BECA 18 ORDINARIA 2018"
gen albergue = 0
replace albergue = 1 if mod=="BECA ALBERGUE 2018"
gen cna = 0
replace cna = 1 if mod=="BECA CNA 2018"
gen eib = 0
replace eib = 1 if mod=="BECA EIB 2018"
gen ffaa = 0
replace ffaa = 1 if mod=="BECA FFAA 2018"
gen huallaga = 0
replace huallaga = 1 if mod=="BECA HUALLAGA 2018"
gen repared = 0
replace repared = 1 if mod=="BECA REPARED 2018"
gen vraem = 0
replace vraem = 1 if mod=="BECA VRAEM 2018"

cd D:\Drive\DataPNB\ProcessedData\ExamenBeca18
save ExamenBeca18.dta, replace

//Distribuciones puntajes

*Varios graficos segun modalidad
tw (kdensity puntaje, kernel(tri)), by(mod) // puntaje e_mate e_comu
//ep tri

*En un mismo grafico
global Y puntaje //puntaje e_mate e_comu
global K ep //ep tri
kdensity $Y if mod=="BECA 18 ORDINARIA 2018", addplot(kdensity $Y ///
if mod=="BECA ALBERGUE 2018", kernel($K) || kdensity $Y if ///
mod=="BECA CNA 2018", kernel($K) || kdensity $Y if mod=="BECA EIB 2018", ///
kernel($K) || kdensity $Y if mod=="BECA FFAA 2018", kernel($K) || ///
kdensity $Y if mod=="BECA HUALLAGA 2018", kernel($K) || kdensity $Y if ///
mod=="BECA REPARED 2018", kernel($K) || kdensity $Y if ///
mod=="BECA VRAEM 2018", kernel($K)) kernel($K) legend(ring(0) pos(2) ///
label(1 "BECA 18 ORDINARIA") label(2 "BECA ALBERGUE") label(3 "BECA CNA") ///
label(4 "BECA EIB") label(5 "BECA FFAA") label(6 "BECA HUALLAGA") ///
label(7 "BECA REPARED") label(8 "BECA VRAEM"))


//Diferencia de medias

global X ordinaria albergue cna eib ffaa huallaga repared vraem

*TTest
foreach var in $X {
dis "`var'"
ttest puntaje, by(`var') unequal
}

*Lo mismo puede hacerse para matematica y comunicacion
