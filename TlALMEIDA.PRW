#include "protheus.ch"
#include "colors.ch"
#include "topconn.ch"  
#include "rwmake.ch"
#include "TbiConn.ch"

// Francisco Valdeni 
// 2.3 Requerimento 3: Previs鉶 de Or鏰mento de Despesas


*-----------------------
User Function TlAlmeida()
*-----------------------
Private oDlg
Private cSolic := space(6)
Private oSolic 
Private cProdut := space(15)
Private oProdut 
Private nValor := 0
Private oValor
Private oFilPag 
Private cFilPag := Space(06)
Private lCheck1 := .F.
Private oCheck1
Private oSequen  
Private nSequen := space(4)
Private oTotal  
Private nTotal:= Space(04)


Private aObjects  	:= {}
Private aInfo     	:= {}
Private aPosGet   	:= {}
Private aPosObj   	:= {}
Private aCol        := {}
Private aHead		:= {}	
Private oProd

//Private oFolder


*-----------------------------------------------
Prepare Environment Empresa "30" Filial "3001001"
*-----------------------------------------------


aSizeAut 	 := MsAdvSize()

aAdd(aObjects,{100,050,.T.,.F.})
aAdd(aObjects,{100,050,.T.,.F.})
aAdd(aObjects,{100,050,.T.,.T.})

aInfo 	:= {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSizeAut[3]-aSizeAut[1]),315,{{004,024,240,370}} )



DEFINE MSDIALOG oDlg FROM 0,0 TO 420,700 PIXEL TITLE 'Rateio por Nota de Debito'
//bloco 01
oGroup:= tGroup():New(05,08,024,345,'',oDlg,,,.T.)
    @ 012,010 SAY OemToAnsi("Solicitacao") SIZE 50,10 OF oDlg PIXEL
	@ 009,050 MSGET oSolic  VAR cSolic PICTURE "@" When .T. VALID .T.	SIZE 60,10 OF oDlg  PIXEL
    
    @ 012,180 SAY OemToAnsi ('Produto')  SIZE 030,010   OF oDlg PIXEL  
    @ 009, 230 MSGET oProdut VAR cProdut PICTURE "@" When .T. VALID .T.	SIZE 60,10 OF oDlg  PIXEL

    
//bloco 02
oGroup:= tGroup():New(024,08,160,345,'',oDlg,,,.T.)
    CriaGet()

//bloco 03
oGroup:= tGroup():New(165,08,205,345,'',oDlg,,,.T.)
    @ 175,270 SAY OemToAnsi("Total %") SIZE 50,10 OF oDlg PIXEL
	@ 171,290 MSGET oTotal  VAR nTotal PICTURE "@E 99.99" When .T. VALID .T.	SIZE 40,10 OF oDlg  PIXEL

    @ 180,135 BUTTON 'CONFIRMAR'  SIZE 060,010   OF oDlg PIXEL  ACTION {|| Alert("Teste")}
	

    

 ACTIVATE MSDIALOG oDlg CENTERED 


return 

*----------------
RESET ENVIRONMENT
*----------------

ACTIVATE MSDIALOG oDlg CENTERED




Return NIL

*-----------------------------
Static Function CriaGet()
*-----------------------------
Local nSuperior    	:= 025     				      					// Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= 010          									// Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= 150//aPosObj[3,1]//aPosObj[3,3]-(aPosObj[3,1]+15)	// Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= 340//aPosObj[3,4]-(aPosObj[3,2]+04)	// Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
//Local nOpc         	:= 0 //GD_INSERT+GD_DELETE+GD_UPDATE 	// GD_INSERT+GD_DELETE+GD_UPDATE				 								// Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk      	:= Nil														// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""														// Nome dos campos do tipo caracter que utilizarao incremento automatico.Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do segundo campo>+..."
Local nFreeze      	:= Nil														// Campos estaticos na GetDados.
Local nMax         	:= 999														// Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk     	:= Nil														// Funcao executada na validacao do campo
Local cSuperApagar 	:= Nil														// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk     	:= .T.	





	/*01*/AADD(aHead,{"Sequencia"					    ,"Z0E_SEQUE"  		,"@!"				    ,07 ,0,	".T."		,"没"	,"C",""			,"V"} )
    /*02*/AADD(aHead,{"Filial Pagamento"				,"Z0E_FILPAG"  		,"@!"				    ,06 ,0,	".T."		,"没"	,"C","Z2"		,"V"} )
	/*03*/AADD(aHead,{"Natureza Pgto"         			,"Z0E_NATUPAG"  	,"@!"	                ,55 ,0,	".F."		,"没"	,"C",""			,"V"} )
	/*04*/AADD(aHead,{"Natureza Receb"			        ,"Z0E_NATUREC"  	,"@!"	                ,12 ,4,	".T."		,"没"	,"N",""			,"V"} )
    /*05*/AADD(aHead,{"Cont Pgto"           			,"Z0E_CONTPAG"  	,"@!"	                ,01 ,0,	".T."		,"没"	,"C",""			,"V"} )
    /*06*/AADD(aHead,{"Cont Recebimento"           		,"Z0E_CONTREC"  	,"@!"	                ,01 ,0,	".T."		,"没"	,"C",""			,"V"} )
    /*07*/AADD(aHead,{"Percentual"           			,"Z0E_PERCENT"  	,"@E 99.99"	            ,01 ,0,	".T."		,"没"	,"C",""			,"V"} )



	AADD(aCol,Array(Len(aHead)+1))
	nLin := Len(aCol)
	aCol[nLin,01]	:= SPACE(07)		
    aCol[nLin,02]	:= SPACE(06)
	aCol[nLin,03]	:= SPACE(55)
    aCol[nLin,04]	:= 0
    aCol[nLin,05]	:= SPACE(01)
	aCol[nLin,Len(aHead)+1] := .F. 

oProd:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,/*nOpc*/,.T.,cTudoOK,cIniCpos,,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,,aHead,aCol)                                   
oProd:oBrowse:nAt := 1
oProd:oBrowse:refresh()
oProd:oBrowse:setfocus()


Return
