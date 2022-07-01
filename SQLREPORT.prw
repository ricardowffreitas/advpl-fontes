#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

User Function SQLREPORT()

Private oReport := Nil
Private oSection1 := Nil  //Primeira Sessao
Private cAlias  //private pode ser acessada nas static  
//Pergunta / Filtro / SX1 
//Private cPerg := "TRFOR" 
//Exibir filtros do relatório 
//pergunta os campos no configurador 
//Pergunte(cPerg,.T.)
ReportDef()
oReport:PrintDialog()
Return 

Static Function  ReportDef()

//oReport := TReport():New("PROD","Relatório - Lista de Produtos", /*cPerg*/, {|oReport| PrintReport(oReport)}, "Relatório de Produtos")
oReport := TReport():New("REPORTPROD","Relatório - Lista de Produtos", ,{|oReport| PrintReport(oReport)}, "Relatório de Produtos")
oReport:SetLandscape(.T.)  // significa que o relatório será em paisagem 
//TrSection serve para controle da seção do relatório, neste caso , teremos somente uma 
//Sessão do relatório
oSection1 := TRSection():New( oReport , "PRODUTOS")
//Itens do relatorio 
TRCell():New( oSection1, "CODIGO",          cAlias)
TRCell():New( oSection1, "DESCRICAO",       cAlias)
TRCell():New( oSection1, "TIPO",            cAlias)
TRCell():New( oSection1, "UNIDADE",         cAlias)
TRCell():New( oSection1, "NCM",             cAlias)
TRCell():New( oSection1, "CODIGOGRUPO",     cAlias)
TRCell():New( oSection1, "DESCRICAOGRUPO",  cAlias)

Return 

Static Function PrintReport(oReport)

Local cAlias := GetNextAlias() //Pegando um nome automatico para oa Alias /Nome reservado para armazenar os dados em arquiuvo
oSection1:BeginQuery()

    BeginSql Alias CALIAS
        //query 
        B1_COD CODIGO,
        B1_DESC DESCRICAO,
        B1_TIPO TIPO,
        B1_UM UNIDADE,
        B1_POSIPI NCM,
        B1_GRUPO CODIGOGRUPO,
        ISNULL(BM_DESC, 'SEMGRUPO') DESCRICAOGRUPO 
        //FROM SB1990 SB1
        FROM %table:SB1% SB1        
        //LEFT JOIN SBM990 ON SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_ = ' '
        LEFT JOIN %table:SBM%  SBM ON SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.%notDel%

        //WHERE SB1.D_E_L_E_T_ = ''   
        WHERE SB1.%notDel%


    EndSql
    
oSection1:EndQuery() //fim da query 
//oSection2:SetParentQuery()
//oSection2:SetParentFilter({|cForLoja| (cAlias) -> A2_LOJA},{ || (cAlias) -> A2_COD + (cAlias)-> A2_LOJA})
//impressao
oSection1:Print()
//O alias utilizado para execução da Query e fechado
(cAlias)->(DbCloseArea())

Return


