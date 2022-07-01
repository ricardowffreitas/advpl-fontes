#INCLUDE "PROTHEUS.CH"

USER FUNCTION ssExecFonte()

    LOCAL cNomeFonte    := ""  //variavel que irá receber o nome do fonte digitado 
    LOCAL aFonte        := {}  //Array que irá armazenar os dados da função retornada pelo GetApoInfo()
    LOCAL aPergs        := {}  //Array que armazena as perguntas do ParamBox()

//adiciona elementos no array de perguntas 
    aAdd( aPergs , {1, "Nome do fonte ", space(10), "", "", "", "", 40, .T.} ) 
 
//If que valida o OK do parambox() e passa o conteudo do parametro para a variavel
    IF ParamBox(aPergs, "DIGITAR NOME DO ARQUIVO .PRW" )
        cNomeFonte := ALLTRIM( MV_PAR01 )
    ELSE
        RETURN
    ENDIF

//Caso o usuário digite o U_ ou () no nome do fonte, retira esses caracteres
    cNomeFonte := StrTran( cNomeFonte , "U_" , "" )
    cNomeFonte := StrTran( cNomeFonte , "()" , "" )
//Valida se o fonte existe no rpo
    aFonte := GETAPOINFO( cNomeFonte + ".prw" )

//Valida se retornou os dados do fonte do rpo
    IF !LEN( aFonte )
        MsgAlert( DECODEUTF8( "Fonte não encontrado no RPO" ) , "ops!" )
        RETURN u_ExecFonte()
    ENDIF

//complementa a variavel e executa macro substituição chamando a rotina
    cNomeFonte := "U_"+cNomefonte+"()"
    &cNomeFonte

RETURN
