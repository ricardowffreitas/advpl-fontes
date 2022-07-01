#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"                                                      

//Protheus-Construindo um relatorio ADVPL em 5 minutos
User Function SQLEXCEL()
Local cAlias := GetNextAlias() //Declarei meu ALIAS

Private aCabec := {} //ARRAY DO CABEALHO
Private aDados := {} //ARRAY QUE ARMAZENAR OS DADOS

//COMECO A MINHA CONSULTA SQL
BeginSql Alias cAlias
		SELECT B1_COD, B1_DESC, B2_LOCAL, B2_QATU FROM  %table:SB2%  SB2
		INNER JOIN  %table:SB1%  SB1 ON SB2.B2_COD = B1_COD AND B2_FILIAL = B1_FILIAL AND SB1.%notdel%  
		WHERE SB2.%notdel%  

EndSql //FINALIZO A MINHA QUERY
	
//CABECALHO
aCabec := {"CODIGO","DESCRICAO","LOCAL","QUANTIDADE ATUAL"}

While !(cAlias)->(Eof())

	aAdd(aDados,{B1_COD,B1_DESC, B2_LOCAL, B2_QATU})
	
	(cAlias)->(dbSkip()) //PASSAR PARA O PROXIMO REGISTRO                                     
enddo

//JOGO TODO CONTEDO DO ARRAY PARA O EXCEL
DlgtoExcel({{"ARRAY","Relatorio saldo fisico de produtos por armazem", aCabec, aDados}})
	                                          
(cAlias)->(dbClosearea())	

return


