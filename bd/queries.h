/*
Projeto – Animais Domésticos e Exóticos
Contrato temporário de itens e serviços para animais de estimação

Caio Augusto Duarte Basso – 10801173
Gabriel Garcia Lorencetti – 10691891
Giovana Daniele da Silva – 10692224
Luíza Pereira Pinto Machado – 7564426
*/

#ifndef queries_h
#define queries_h

#include "conexao.h"

#include <ctype.h>

#define MAX_SIZE_PET 25
#define MAX_SIZE_BAIRRO 40

using namespace std;

string printSpaces(pqxx::row::reference, int);

bool loginDonoPet(conexaoBD*, string, char*, pair<string, string>*);
void cadastrarPet(conexaoBD*, string);
void consultarPet(conexaoBD*, string);
void rankingPassBairro(conexaoBD*);

#endif
