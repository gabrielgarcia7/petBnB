/*
Projeto – Animais Domésticos e Exóticos
Contrato temporário de itens e serviços para animais de estimação

Caio Augusto Duarte Basso – 10801173
Gabriel Garcia Lorencetti – 10691891
Giovana Daniele da Silva – 10692224
Luíza Pereira Pinto Machado – 7564426
*/

// Aqui consta toda a parte de estabelecimento de conexão com o banco.

// Optou-se por utilizar o libpqxx, a API oficial para conexão de aplicações
//C++ com banco de dados PostgreSQL.

// Como o código fonte do libpqxx está disponível sob licença BSD, é permitido
//baixá-lo, repassá-lo a outras pessoas, alterá-lo, vendê-lo, incluí-lo em seu
//próprio código, compartilhar suas alterações com qualquer outra pessoa que
//desejar e, é claro, fazer o trabalho de BD. Não há nenhum custo incluso no uso.

// Mais informações podem ser encontradas no seguinte link: <https://pqxx.org/>

#include "conexao.h"

bool conexaoBD::estabelecerConex(){
    // Manipulando arquivo de login. É mantido em um arquivo separado para não
    //ser exposto (uma vez que, por conter login e senha do BD, é um arquivo
    //sensível)
    ifstream input("bd/login.txt");

    // Caso o arquivo de credenciais não possa ser aberto, a aplicação não
	//inicializará, pois não haverá conexão com o banco de dados.
	if(!input){
        return false;
    }
    else{
        // Trazendo as credenciais existentes no arquivo ao programa
    	vector<string> credenciais;
    	while(!input.eof()){
    		string linha;

    		getline(input, linha);

    		credenciais.push_back(linha);
        }

        // Parte específica para conexão com postgres: linha que estabelece a
    	//conexão ao banco de dados
    	string str_conexao("host=localhost port=5432 dbname=petBnB user=" +
    					    credenciais[0] + " password=" + credenciais[1]);

        con = new pqxx::connection(str_conexao.c_str());

        if(con && con->is_open()) return true;
        else return false;
    }
}

// Método responsável por executar, de fato, as queries
pqxx::result conexaoBD::consulta(string comandoSQL){
    pqxx::work wrk(*con);

    pqxx::result res = wrk.exec(comandoSQL);

    wrk.commit();

    return res;
}
