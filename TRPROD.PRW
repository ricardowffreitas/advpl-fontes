#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"

/* Função principal / Main Function */ 

User Function TRPROD()
//VARIAVEIS

Private oReport := NIL //Notação Hungara
Private oSecCab := NIL 
Private cPerg := "TRPROD" // ficam armazenadas na SK1 
Private cAlias

//Função responsavel por chamar a pergunta criada na função ValidaPerg
//a variavel PRIVATE cPerg, é passada
//Pergunte(cPerg, .T.) // SE TRUE ele chama a pergunta assim que o relatorio é acionado 

//Chamamos as funções que construirão o relatório 

ReportDef()  //montar a estrutura 

oReport:PrintDialog()  // Trazer os dados e printa/imprime na tela ou em arquivo ou na impressora o relatorio 

Return 

/*/{Protheus.doc}  
    (long_description)
    @type  Static Function
    @author user
    @since 12/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/

Static Function  ReportDef()
    

oReport := TReport():New("PROD","Relatório - Produtos", cPerg, {|oReport| PrintReport(oReport)}, "Relatório de Produtos")

oReport:SetLandscape(.T.)  // significa que o relatório será em paisagem 

//TrSection serve para controle da seção do relatório, neste caso , teremos somente uma 
oSection1 := TRSection():New( oReport , "PRODUTOS", {"SQL"})

Return return_var



/* função responsavel por trazer os dados */
Static /*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 12/05/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Function PrintReport(oReport)

cAlias := GetNextAlias()

oSection1:BeginQuery() //Query começa a ser estruturada no relatorio

    BeginSql Alias cAlias
        //SELECT B1_COD, B1_DESC FROM %table:SB1% WHERE %notDel%

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

    ENDSQL


oSection1:EndQuery()  //Fim da query 
oSection1:Print() // É dada a ordem da impressão, visto os filtros selecionados

(cAlias) ->(DbCloseArea())

Return















