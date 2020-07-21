/*
Projeto – Animais Domésticos e Exóticos
Contrato temporário de itens e serviços para animais de estimação

Caio Augusto Duarte Basso – 10801173
Gabriel Garcia Lorencetti – 10691891
Giovana Daniele da Silva – 10692224
Luíza Pereira Pinto Machado – 7564426
*/

#ifndef conexao_h
#define conexao_h

#include <fstream>
#include <vector>
#include <string>
#include <iostream>
#include <any>
#include <pqxx/pqxx>

using namespace std;

// Classe responsável pelo tratamento de conexão com o banco.
class conexaoBD{
    public:
        pqxx::connection* con;

        bool estabelecerConex();
        pqxx::result consulta(string comandoSQL);
};

#endif
