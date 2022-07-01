#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"                                                      

//Protheus-Construindo um relatorio ADVPL em 5 minutos
User Function estacfolha()
Local cAlias := GetNextAlias() //Declarei meu ALIAS

Private aCabec := {} //ARRAY DO CABEùALHO
Private aDados := {} //ARRAY QUE ARMAZENARù OS DADOS

//COMECO A MINHA CONSULTA SQL
BeginSql Alias cAlias

		//SELECT B1_COD, B1_DESC, B2_LOCAL, B2_QATU FROM  %table:SB2%  SB2
		//INNER JOIN  %table:SB1%  SB1 ON SB2.B2_COD = B1_COD AND B2_FILIAL = B1_FILIAL AND SB1.%notdel%  
		//WHERE SB2.%notdel%  
        //no parser para case sensitive
        %noparser% 

        SELECT 
        SRA.RA_NOME
        ,SRD.RD_MAT
        ,SRD.RD_PERIODO
        ,SRD.RD_PD
        ,SRD.RD_ROTEIR
        ,SRD.RD_VALOR
        ,CASE 
            WHEN SRD.RD_PD = 'J12' THEN  'LIQUIDO ADIANTAMENTO' 
            WHEN SRD.RD_PD = 'J30' THEN  'LIQUIDO FOLHA'
            ELSE ''
        END AS 'TIPO'
        ,CASE 
            WHEN SRD.RD_PD = 'J12' THEN  CONCAT('CX1 BX.PG.ADT/EST.MAT', SRD.RD_MAT,'REF',SRD.RD_PERIODO)
            WHEN SRD.RD_PD = 'J30' THEN  CONCAT('CX1 BX.PG.FOL/EST.MAT', SRD.RD_MAT,'REF',SRD.RD_PERIODO)
            ELSE 'CX1'
	  END AS 'HISTORICO_PRONTO'
        //FROM %table:SRD% [174.194.0.248].[P12_PRD].[lower(dbo)].[SRD010] SRD (NOLOCK)
        //JOIN %table:SRA% [174.194.0.248].[P12_PRD].[lower(dbo)].[SRA010] SRA
        FROM [174.194.0.248].[P12_PRD].[dbo].[SRD010] SRD (NOLOCK)
        JOIN [174.194.0.248].[P12_PRD].[dbo].[SRA010] SRA


        ON SRA.RA_MAT = SRD.RD_MAT AND SRA.RA_FILIAL = SRD.RD_FILIAL
        WHERE SRD.D_E_L_E_T_ <> '*'
        AND SRD.RD_PERIODO >= '202201'
        AND SRD.RD_PERIODO <= '202312'
        AND SRD.RD_FILIAL IN ('0202','0142')
        AND SRD.RD_PD IN ('J12','J30')
        AND (SRA.RA_NOME LIKE '%RAQUEL LUCIANA%' OR SRA.RA_NOME LIKE '%JOAO RAIMUNDO%')
        ORDER BY SRD.RD_PERIODO 
        COLLATE Latin1_General_CS_AS asc; 

EndSql //FINALIZO A MINHA QUERY
	
//CABECALHO
aCabec := {"NOME","MATRICULA","PERIODO","VERBA","ROTEIRO","VALOR","TIPO","HISTORICO PRONTO"}

While !(cAlias)->(Eof())

	aAdd(aDados,{RA_NOME,RD_MAT,RD_PERIODO,RD_PD,RD_ROTEIR,RD_VALOR,TIPO,HISTORICO_PRONTO})
	
	(cAlias)->(dbSkip()) //PASSAR PARA O PROXIMO REGISTRO                                     
enddo

//JOGO TODO CONTEùDO DO ARRAY PARA O EXCEL
DlgtoExcel({{"ARRAY","Relatorio folha funcionarios estacionamento", aCabec, aDados}})
	                                          
(cAlias)->(dbClosearea())	

return


