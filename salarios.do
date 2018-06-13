clear all
set more off

global X "2017 2012 2007 2004"

foreach year in $X {

cd "D:\Drive\DataPNB\Rawdata\RawdataExterna\ENAHO\BASES\\`year'\Modulo03"
use "enaho01a-`year'-300", clear

cd "D:\Drive\DataPNB\Rawdata\RawdataExterna\ENAHO\BASES\\`year'\Modulo05"
merge 1:1 conglome vivienda hogar codperso using "enaho01a-`year'-500", keep(3)
drop _merge

*SALARIO PROMEDIO LABORAL TOTAL

if `year'!=2004 {

generate ingbruhd = i524e1 if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==3 | p507==4 | p507==6 | p507==7) & i524e1>0 & i524b1>=0
}
else {

generate ingbruhd = i524d1 if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==3 | p507==4 | p507==6 | p507==7) & i524d1>0 & i524b1>=0
}

generate pagesphd = d529t if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==3 | p507==4 | p507==6 | p507==7)

generate ingindhd = i530a if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==1 | p507==2)

generate ingauthd = d536 if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==1 | p507==2)

if `year'!=2004 {

generate insedlhd = i538e1 if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==1 | p507==4 | p507==6 | p507==7) & ((p514==1 | (p514==2 & (p5151==1 ///
	| p5152==1 | p5153==1 | p5154==1 | p5155==1 | p5156==1 | p5157==1 ///
	| p5158==1 | p5159==1 | p51510==1 | p51511==1)) & (p5371==1 | p5372==1 ///
	| p5373==1 | p5374==1 | p5375==1 | p5376==1 | p53710==1	| p53711==1)))
}
else {

generate insedlhd = i538d1 if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==1 | p507==4 | p507==6 | p507==7) & ((p514==1 | (p514==2 & (p5151==1 ///
	| p5152==1 | p5153==1 | p5154==1 | p5155==1 | p5156==1 | p5157==1 ///
	| p5158==1 | p5159==1 | p51510==1 | p51511==1)) & (p5371==1 | p5372==1 ///
	| p5373==1 | p5374==1 | p5375==1 | p5376==1 | p53710==1	| p53711==1)))
}

generate paesechd = d540t if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==1 | p507==4 | p507==6 | p507==7) & ((p514==1 | (p514==2 & (p5151==1 ///
	| p5152==1 | p5153==1 | p5154==1 | p5155==1 | p5156==1 | p5157==1 ///
	| p5158==1 | p5159==1 | p51510==1 | p51511==1)) & (p5371==1 | p5372==1 ///
	| p5373==1 | p5374==1 | p5375==1 | p5376==1 | p53710==1	| p53711==1)))

generate ingseihd = i541a if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==1 | p507==4 | p507==6 | p507==7) & ((p514==1 | (p514==2 & (p5151==1 ///
	| p5152==1 | p5153==1 | p5154==1 | p5155==1 | p5156==1 | p5157==1 ///
	| p5158==1 | p5159==1 | p51510==1 | p51511==1)) & (p5376==1 | p5377==1	///
	| p5378==1)))

generate isecauhd = d543 if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	(p507==1 | p507==4 | p507==6 | p507==7) & ((p514==1 | (p514==2 & (p5151==1 ///
	| p5152==1 | p5153==1 | p5154==1 | p5155==1 | p5156==1 | p5157==1 ///
	| p5158==1 | p5159==1 | p51510==1 | p51511==1)) & (p5376==1 | p5377==1	///
	| p5378==1)))

generate ingexthd = d544t if p204==1 & (p203!=8 & p203!=9) & p208a>=14 & ///
	((p507==3 | p507==4 | p507==6 | p507==7) | (p517==3 | p517==4 | p517==6 ///
	| p517==7))

egen salario = rowtotal(ingbruhd pagesphd ingindhd ingauthd insedlhd paesechd ///
	ingseihd isecauhd ingexthd), missing
label variable salario "Salario anualizado/deflactado total"

*GRUPOS DE EDUCACION

*Secundaria o menos
generate secundaria = 1 if p301a==1 | p301a==2 | p301a==3 | p301a==4 | ///
	p301a==5 | p301a==6 | p301a==12
label variable secundaria "Secundaria"

*Superior Privada Universitaria
generate supprivuni = 1 if p301d==1 & (p301a==9 | p301a==10	| p301a==11)
label variable supprivuni "Superior Publica"

*Superior Privada No Universitaria
generate supprivnouni = 1 if p301d==1 & (p301a==7 | p301a==8)
label variable supprivnouni "Superior Privada"

*Superior Publica Universitaria
generate suppubuni = 1 if p301d==2 & (p301a==9 | p301a==10	| p301a==11)
label variable suppubuni "Superior Universitaria"

*Superior Publica No Universitaria
generate suppubnouni =1 if p301d==2 & (p301a==7 | p301a==8)
label variable suppubnouni "Superior No Universitaria"

*GRUPOS DE EDAD

*De 23 a 25 anos
generate edad23 = 0
replace edad23 = 1 if p208a>=23 & p208a<=25
label variable edad23 "23-25"

*De 26 a 28 anos
generate edad26 = 0
replace edad26 = 1 if p208a>=26 & p208a<=28
label variable edad26 "26-28"

*De 29 a 31 anos
generate edad29 = 0
replace edad29 = 1 if p208a>=29 & p208a<=31
label variable edad29 "29-31"

*De 32 a 34 anos
generate edad32 = 0
replace edad32 = 1 if p208a>=32 & p208a<=34
label variable edad32 "32-34"


//////
*Para anos menores a 2015, tener en cuenta cambio en conglomerados. Debe usarse
*rutina que transforme codigos conglome de 4 digitos a 6 digitos.

cap rename aÑo aNo
cap rename a_o aNo

if `year'!=2017 {
	rename conglome cong
	generate conglome = string(real(cong),"%06.0f")
	order aNo mes conglome vivienda
	drop cong
}

if `year'==2012 {
	rename facpob07 factor07
}

cd "D:\Drive\DataPNB\ProcessedData\ENAHO"
save "salario_`year'", replace	
}
*Corregir el rename a aNo para Stata14.

//////////
*APPEND

cd D:\Drive\DataPNB\ProcessedData\ENAHO
use salario_2017, clear
append using salario_2012 salario_2007 salario_2004, force
/*
keep(ingbruhd pagesphd ///
	ingindhd ingauthd insedlhd paesechd ingseihd isecauhd ingexthd salario ///
	edad23 edad26 edad29 edad32 secundaria supprivuni supprivnouni suppubuni suppubnouni ///
	aNo mes conglome vivienda hogar codperso factor07)
*/
save salarios, replace





////////////////////////////////////////////////////////////////////////////////
*TABLAS

set more off
clear all

cd D:\Drive\DataPNB\ProcessedData\ENAHO
use salarios, clear

global educ "secundaria supprivuni supprivnouni suppubuni suppubnouni"
global edad "edad23 edad26 edad29 edad32"
global X "2004 2007 2012 2017"
global Educ "Secundaria Sup.Priv.Univ Sup.Priv.NoUniv Sup.Pub.Univ Sup.Pub.NoUniv"
global Edad "Edad:23-25 Edad:26-28 Edad:29-31 Edad:32-34"

////////// Esto permitira usar un table de manera mas ordenada
foreach var in $educ {
generate s_`var' = salario * `var'
}
//////////

*Se tiene diferentes edades, grupos de educacion y anos

foreach var in $edad {
tabstat s_secundaria s_supprivuni s_supprivnouni s_suppubuni s_suppubnouni ///
	if `var'==1	[aw=factor07], by(aNo) format(%9.2f) //Crea tabla en Stata
}

putexcel set Salarios_04_17, replace //Crear tabla en Excel

local grupo_edad = 1
foreach var in $edad {
	tabstat s_secundaria s_supprivuni s_supprivnouni s_suppubuni s_suppubnouni ///
	if `var'==1	[aw=factor07], by(aNo) format(%9.2f) save //Crea tabla en Stata
	
	local Cell = char(64 + 1) + string(1 + 6 * (`grupo_edad' - 1))
	local valor `:word `grupo_edad' of $Edad'
	putexcel `Cell' = ("`valor'")
	
	local col = 1
	foreach varname in $Educ {
		local Cell = char(64 + `col' + 1) + string(2 + 6 * (`grupo_edad' - 1))
		putexcel `Cell' = ("`varname'")
		local col = `col' + 1 // Ingresa nombres de columna
	}
		
	local fila = 1
	foreach year in $X {
		local Cell = char(64 + 1) + string(2 + `fila' + 6 * (`grupo_edad' - 1))
		putexcel `Cell' = (`year') // Ingresa nombres de fila
		
		matrix f`fila'_`grupo_edad' = r(Stat`fila')
		
		forval col = 1 (1) 5 {
			local Cell = char(64 + `col' + 1) + string(2 + `fila' + 6 * (`grupo_edad' - 1))
			local valor = f`fila'_`grupo_edad'[1,`col']
			putexcel `Cell' = (`valor') // Ingresa valores a Excel
		}
		local fila = `fila' + 1
	}
	local grupo_edad = `grupo_edad' + 1
}
////////////////////////////////
