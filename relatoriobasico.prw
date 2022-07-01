#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

User Function REPORTPROD()


Private oReport := NIL
Private oSection1 := NIL
Private oSection2 := NIL
Private cPerg := "TRFOR"

//Perfunta filtro / SX1 / PARAMETROS DO RELATORIO 
ValidPerg()

Pergunte(cPerg, .T.)

ReportDef()
oReport:PrintDialog()


Return
