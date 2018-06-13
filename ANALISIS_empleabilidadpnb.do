set more off
cd "D:\Drive\DataPNB\Rawdata\EncuestaPnbInsercion"

import excel "11052018 Base de datos muestral - Encuesta Beca 18 2017-I.xlsx", ///
sheet("Hoja1") firstrow allstring clear

//Nombres variables
rename DNI dni
rename MODALIDAD modalidad
rename GENERO genero
rename REGIÓNDEESTUDIO reg_estudio
rename SEMESTREDEEGRESO sem_egreso
rename FECHADEFIN fechafin
rename INGRESESUAPELLIDOPATERNO apellido_p
rename INGRESESUAPELLIDOMATERNO apellido_m
rename INGRESESUSNOMBRES nombres
rename INGRESESUCELULAR celular
rename INGRESESUCORREOELECTRÓNICO email
rename SELECCIONESUREGIÓNDERESIDENC reg_resid
rename SELECCIONELOSIDIOMASEXTRANJER idioma_aleman
rename O idioma_chino
rename P idioma_frances
rename Q idioma_ingles
rename R idioma_italiano
rename S idioma_portugues
rename DEACUERDOALACARRERAESTUDIA especialidad
rename HACULMINADOSUSESTUDIOSCOMOB termino_estudios
rename SELECCIONELAFECHAAPROXIMADA fecha_termino_estudios
rename SELECCIONEELCUADRODEMÉRITOS merito_cat
rename SELECCIONEELTIPODEINSTITUCIÓ tipo_ie
rename HAOBTENIDOSUTÍTULOTÉCNICO titulo_tecnico
rename HAOBTENIDOELGRADODEBACHILL bachiller
rename HAOBTENIDOSUTÍTULOPROFESION titulo_pro
rename DURANTESUSESTUDIOSCOMOBECARI asist_oficina_cat
rename AC bolsa_trabajo_cat
rename HAREALIZADOPRÁCTICASPREPROF practicas
rename ALGUNADELASPRÁCTICASFUECON practica_conseguida
rename CUÁNTOSMESESDEPRÁCTICASREAL meses_practicas
rename DESDELAFINALIZACIÓNDESUSEST empleo_cat
rename INSERCIÓNLABORAL insercion
rename AI exp_laboral
rename SELECCIONELAFECHAENQUEINICI fecha_primer_empleo
rename VALIDACIÓNDEFECHAS valid_fechas
rename ENQUÉREGIÓNSEUBICAUBICÓLA reg_primer_empresa
rename CÓMOCONSIGUIÓSUPRIMEREMPLEO consiguio_primer_empleo
rename AQUÉSECTORPERTENECÍAPERTENE sector_primera_empresa
rename AQUÉACTIVIDADECONÓMICACORRE actividad_primera_empresa
rename CUÁLESELNOMBREDELAEMPRESA nombre_primera_empresa
rename INDIQUEELNOMBREDELPUESTOESP puesto_primer_empleo
rename CUÁLFUEESSUINGRESOMENSUAL ingreso_primer_empleo
rename ENLAACTIVIDADQUEREALIZABARE beneficios_primer_empleo
rename SIENTEQUELAACTIVIDADQUEREA skill_mismatch_primer
rename AU degree_mismatch_primer
rename SELECCIONEELTIPODEPRIMEREMP tipo_primer_empleo
rename LAINSTITUCIÓNEMPRESADONDEUS ruc_primera_empresa
rename ENSUPRIMEREMPLEOTRASFINALI rhonorarios_primer_empleo
rename ENSUPRIMEREMPRENDIMIENTOON boleta_primer_emprendimiento
rename ACTUALMENTESEENCUENTRAEMPLEA empleado
rename ESELEMPLEOOEMPRENDIMIENTOAC mismo_empleo
rename BB fecha_empleo_actual
rename ENQUÉREGIÓNSEUBICALAINSTI reg_empresa_actual
rename CÓMOCONSIGUIÓSUEMPLEOACTUAL consiguio_empleo_actual
rename AQUÉSECTORPERTENECELAEMPRE sector_empresa_actual
rename BF actividad_empresa_actual
rename BG nombre_empresa_actual
rename BH puesto_empleo_actual
rename CUÁLESSUINGRESOMENSUALPROM ingreso_empleo_actual
rename ENLAACTIVIDADQUEREALIZAACTU beneficios_empleo_actual
rename SIENTEQUESUEMPLEOOEMPRENDI skill_mismatch_actual
rename BL degree_mismatch_actual
rename BM meses_exp_laboral
rename SELECCIONEELTIPODEEMPLEOQUE tipo_empleo_actual
rename BO ruc_empresa_actual
rename ENSUACTIVIDADACTUALUSTEDEM rhonorarios_empleo_actual
rename BQ boleta_emprendimiento_actual
rename ENLAACTUALIDADSEENCUENTRAA busqueda_empleo
rename CUÁLESELMOTIVOPRINCIPALPOR motivo_nobusca

//Creacion de variables

*Variables de interes: insercion, empleo, empleado
replace insercion="1" if insercion=="INSERTADO AL MERCADO LABORAL"
replace insercion="0" if insercion=="NO INSERTADO AL MERCADO LABORAL"

gen empleo=1 if empleo_cat=="HE TENIDO SOLO 1 EMPLEO" | empleo_cat== ///
"HE TENIDO MÁS DE 1 EMPLEO Y/O REALIZADO MÁS DE 1 EMPRENDIMIENTO" | ///
empleo_cat=="HE REALIZADO SOLO 1 EMPRENDIMIENTO"
replace empleo=0 if empleo_cat=="NO HE TENIDO NINGÚN EMPLEO"

replace empleado="1" if empleado=="SÍ"
replace empleado="0" if empleado=="NO"

destring insercion empleado, replace

*Variables explicativas: modalidad, genero, idiomas, fecha_termino_estudios,
*merito, tipo_ie, titulo_tecnico, bachiller, titulo_pro, asist_oficina, bolsa_trabajo,
*practicas, practica_conseguida, meses_practicas, exp_laboral

gen ordinario=0
replace ordinario=1 if modalidad=="BECA ORDINARIO"

gen hombre=1 if genero=="MASCULINO"
replace hombre=0 if genero=="FEMENINO"

gen lima_estudio=0
replace lima_estudio=1 if reg_estudio=="LIMA"

gen lima_resid=0
replace lima_resid=1 if reg_resid=="LIMA"

gen ingles=1 if idioma_ingles=="BUENO" | idioma_ingles=="REGULAR"
replace ingles=0 if idioma_ingles=="NULO" | idioma_ingles=="MALO"

gen dia_encuesta=substr(Marcatemporal,1,2)
gen mes_encuesta=substr(Marcatemporal,4,2)
gen ano_encuesta=substr(Marcatemporal,7,4)
destring dia_encuesta mes_encuesta ano_encuesta, replace
gen fecha_encuesta=mdy(mes_encuesta,dia_encuesta,ano_encuesta)
format fecha_encuesta %d

gen dia_termino=substr(fechafin,1,2)
gen mes_termino=substr(fechafin,4,2)
gen ano_termino=substr(fechafin,7,4)
destring dia_termino mes_termino ano_termino, replace
gen fecha_termino=mdy(mes_termino,dia_termino,ano_termino)
format fecha_termino %d

gen tiempo_termino = fecha_encuesta - fecha_termino

gen merito=1 if merito_cat=="TERCIO SUPERIOR" | merito_cat=="QUINTO SUPERIOR" | ///
merito_cat=="DÉCIMO SUPERIOR"
replace merito=0 if merito_cat=="NO PERTENECÍ A NINGÚN CUADRO DE MÉRITOS O NO LO RECUERDO"

gen univ=1 if tipo_ie=="UNIVERSIDAD"
replace univ=0 if tipo_ie=="INSTITUTO DE EDUCACIÓN SUPERIOR"

gen titulo=0
replace titulo=1 if titulo_tecnico=="SÍ" | bachiller=="SÍ" | titulo_pro=="SÍ"

gen univtitulo = univ * titulo

gen asist_oficina=1 if asist_oficina_cat=="SÍ"
replace asist_oficina=0 if asist_oficina_cat=="NO" | ///
asist_oficina_cat=="NO EXISTÍA OFICINA DE EMPLEABILIDAD O NO SABÍA DE SU EXISTENCIA"

gen bolsa_trabajo=1 if bolsa_trabajo_cat=="SÍ"
replace bolsa_trabajo=0 if bolsa_trabajo_cat=="NO" | ///
bolsa_trabajo_cat=="NO EXISTÍA BOLSA LABORAL O NO SABÍA DE SU EXISTENCIA"

replace practicas="1" if practicas=="SÍ"
replace practicas="0" if practicas=="NO"

replace practica_conseguida="1" if practica_conseguida=="SÍ"
replace practica_conseguida="0" if practica_conseguida=="NO"

gen ext_practicas=0
replace ext_practicas=1 if meses_practicas=="MÁS DE 12 MESES" | ///
meses_practicas=="DE 10 A 12 MESES" | meses_practicas=="DE 7 A 9 MESES"

destring practicas practica_conseguida, replace

label variable ordinario "Modalidad de beca ordinaria"
label variable hombre "Hombre"
label variable lima_estudio "Estudio en Lima"
label variable lima_resid "Reside en Lima"
label variable ingles "Sabe ingles"
label variable tiempo_termino "Tiempo egresado"
label variable merito "Cuadro de merito"
label variable univ "Universidad"
label variable titulo "Titulo academico"
label variable univtitulo "Titulo * Univ"
label variable asist_oficina "Oficina empleabilidad"
label variable bolsa_trabajo "Bolsa de trabajo"
label variable practicas "Practicas preprofesionales"
label variable ext_practicas "Practicas >6 meses"


cd "D:\Drive\DataPNB\ProcessedData\InsercionBeca18"
save beca18_insercion.dta, replace

//Regresion
global X "ordinario hombre lima_estudio lima_resid ingles tiempo_termino merito"
global X "$X univ titulo univtitulo asist_oficina bolsa_trabajo practicas ext_practicas"

probit insercion $X, vce(robust)
est store insercion

estout insercion, ///
 cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.1 ** 0.05 *** 0.01) ///
 legend label varlabels(_cons Constante)
*Agregar especialidad (text analysis)

