/*
Projeto – Animais Domésticos e Exóticos
Contrato temporário de itens e serviços para animais de estimação

Caio Augusto Duarte Basso – 10801173
Gabriel Garcia Lorencetti – 10691891
Giovana Daniele da Silva – 10692224
Luíza Pereira Pinto Machado – 7564426
*/

#include "queries.h"

// Função responsável por validar a data de nascimento do pet fornecida.
bool dataNascValida(string dtNasc){
	// YYYY-MM-DD
	bool bissexto = false;
	int dias[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

	int ano = stoi(dtNasc.substr(0, 4));
	int mes = stoi(dtNasc.substr(5, 2));
	int dia = stoi(dtNasc.substr(8, 2));

	// Primeiro passo: checar corner case - é ano bissexto?
	if(stoi(dtNasc.substr(2, 2)) % 4 == 0) bissexto = true;
	if(bissexto) dias[1] = 29;

	// Segundo passo: verificar se os "-" estão no local correto
	if(dtNasc.at(4) != '-' || dtNasc.at(7) != '-') return false;

	// Terceiro passo: verificar se o ano está no range correto
	if(ano < 1900 ||  ano > 2020)
		return false;

	// Quarto passo: verificar se o mês está no range correto
	if(mes < 1 ||  mes > 12)
		return false;

	// Quinto passo: verificar se o dia está no range correto
	if(dia < 1 || dia > dias[mes - 1])
		return false;

	return true;
}

// Função responsável por indentar as tabelas de resultados.
string printSpaces(pqxx::row::reference r, int size){
	string bSpace, s;

	stringstream strs;
	strs << r;
	s = strs.str();

	for(unsigned int i = 0; i < size - s.size(); i++){
		bSpace += " ";
	}

	return bSpace;
}

// Função responsável por realizar o login do usuário.
bool loginDonoPet(conexaoBD* petBnB, string email, char* senha, pair<string, string>* user){
	pqxx::result res = petBnB->consulta("SELECT U.nome_usuario, U.cpf_usuario FROM usuario U JOIN dono_pet DP ON DP.cpf_dp = U.cpf_usuario WHERE U.email = '" + email + "' AND U.senha = '" + senha + "'");

	if(res.size() < 1){
		cout << endl << "Ou o login e a senha são inválidos, ou o usuário em questão não possui cadastro como dono de pet." <<
			 endl << "Tente novamente." << endl << endl;

		res.clear();

		return false;
	}
	else{
		stringstream nome, cpf;

		nome << res[0][0];
		(*user).first = nome.str();

		cpf << res[0][1];
		(*user).second = cpf.str();

		res.clear();

		return true;
	}
}

// Função responsável por cadastrar um novo pet ao usuário logado.
void cadastrarPet(conexaoBD* petBnB, string cpf){
	vector<string> novoPet;
	string aux;

	cout << endl << endl << "Preencha abaixo os dados do seu pet." << endl << "Campos marcados com (*) não podem ser nulos." << endl << endl;

	cout << "(*) Qual o nome do pet? ";
	getline(cin, aux);
	getline(cin, aux);

	while(aux.empty()){
		cout << endl << "O campo nome não pode ser nulo. Tente novamente: ";
		getline(cin, aux);
	}
	cout << endl;
	novoPet.push_back(aux);

	cout << "(*) Qual a espécie? ";
	getline(cin, aux);

	while(aux.empty()){
		cout << endl << "O campo espécie não pode ser nulo. Tente novamente: ";
		getline(cin, aux);
	}
	cout << endl;
	novoPet.push_back(aux);

	cout << "(*) Data de nascimento (Utilize o formato AAAA-MM-DD.): ";
	getline(cin, aux);

	while(aux.empty() || !dataNascValida(aux)){
		cout << endl << "Data inválida. Atente-se às regras e tente novamente: ";
		getline(cin, aux);
	}
	cout << endl;
	novoPet.push_back(aux);

	cout << "(*) Qual o porte? Digite 1 para P, 2 para M e 3 para G: ";
	getline(cin, aux);

	while((aux != "1" && aux != "2" && aux != "3") || aux.empty()){
		cout << endl << "Porte inválido. As opções válidas são (1) P, (2) M e (3) G. Tente novamente: ";
		getline(cin, aux);
	}
	cout << endl;

	switch(aux[0]){
		case '1':
			novoPet.push_back("P");
		break;

		case '2':
			novoPet.push_back("M");
		break;

		case '3':
			novoPet.push_back("G");
		break;
	}

	cout << "(*) Qual o tipo? Digite 1 para EXÓTICO e 2 para DOMÉSTICO: ";
	getline(cin, aux);

	while((aux != "1" && aux != "2") || aux.empty()){
		cout << endl << "Tipo inválido. As opções válidas são (1) EXÓTICO e (2) DOMÉSTICO. Tente novamente: ";
		getline(cin, aux);
	}

	switch(aux[0]){
		case '1':
			novoPet.push_back("Exótico");
		break;

		case '2':
			novoPet.push_back("Doméstico");
		break;
	}

	int erro = 0;

	if(aux == "1"){
		cout << endl << "(*) Qual o registro IBAMA? ";
		getline(cin, aux);

		while(aux.empty()){
			cout << endl << "O registro IBAMA não pode ser nulo. Tente novamente: ";
			getline(cin, aux);
		}
		novoPet.push_back(aux);

		try{
			pqxx::result res = (petBnB->consulta("INSERT INTO pet (cpf_dono_pet, nome_pet, especie_pet, data_nasc, porte, tipo_pet, registro_ibama) VALUES ('" + cpf + "', '" + novoPet[0] + "', '" + novoPet[1] + "', '" + novoPet[2] + "', '" + novoPet[3] + "', '" + novoPet[4] + "', '" + novoPet[5] + "')"));
		} catch(const exception& e) {
			cout << endl << endl << "Impossível realizar a operação. Tente novamente." << endl;
			erro = 1;
		}
	}
	else{
		try{
			pqxx::result res = (petBnB->consulta("INSERT INTO pet (cpf_dono_pet, nome_pet, especie_pet, data_nasc, porte, tipo_pet) VALUES ('" + cpf + "', '" + novoPet[0] + "', '" + novoPet[1] + "', '" + novoPet[2] + "', '" + novoPet[3] + "', '" + novoPet[4] + "')"));
		} catch(const exception& e){
			cout << endl << "Impossível realizar a operação. Tente novamente." << endl;
			erro = 1;
		}
	}

	if(!erro ) cout << endl << endl << "Inserido com sucesso!" << endl;
}

// Função responsável por retornar todos os pets do usuário logado.
void consultarPet(conexaoBD* petBnB, string cpf){
	pqxx::result res = petBnB->consulta("SELECT * FROM pet WHERE cpf_dono_pet = '" + cpf + "'");

	if(res.size() < 1){
		cout << endl << "Nenhum registro foi encontrado." << endl;
	}
	else{
		cout << endl << endl << "Nome:                    " <<
				"Espécie:                 " <<
				"Data de nascimento:      " <<
				"Porte:                   " <<
				"Tipo:                   " <<
				"Registro IBAMA:         " << endl;

		for(int i = 0; i < res.size(); i++){
			cout << res[i][1] << printSpaces(res[i][1], MAX_SIZE_PET) <<
					res[i][2] << printSpaces(res[i][2], MAX_SIZE_PET) <<
					res[i][3] << printSpaces(res[i][3], MAX_SIZE_PET) <<
					res[i][4] << printSpaces(res[i][4], MAX_SIZE_PET) <<
					res[i][5] << printSpaces(res[i][5], MAX_SIZE_PET) <<
					res[i][6] << printSpaces(res[i][6], MAX_SIZE_PET) << endl;
		}

		cin.ignore();
		res.clear();
	}
}

// Função responsável por, dado um bairro, retornar os passeadores mais bem
//avaliados que trabalhem no mesmo.
void rankingPassBairro(conexaoBD* petBnB){
	string bairro;

	cout << endl << "Para qual bairro você deseja consultar os passeadores mais bem avaliados? ";
	getline(cin, bairro);
	getline(cin, bairro);

	while(bairro.empty()){
		cout << endl << "Você deve fornecer um bairro. Tente novamente: ";
		getline(cin, bairro);
	}

	// Deixando o bairro em maiúsculas
	for (auto & c: bairro) c = toupper(c);

	pqxx::result res = petBnB->consulta("SELECT U.nome_usuario, U.email, ROUND(AVG(PS.nota_pr_s), 2) AS nota_media FROM usuario U, prestacao_servico PS JOIN passeador_bairros PB ON PS.cpf_pr_s = PB.cpf_pb WHERE PS.cpf_pr_s = U.cpf_usuario AND UPPER(PS.tipo_pr_s) = 'PASSEIO' AND UPPER(PB.bairro_pb) = '" + bairro + "' GROUP BY U.nome_usuario, U.email ORDER BY nota_media DESC;");

	if(res.size() < 1){
		cout << endl << "Nenhum registro foi encontrado." << endl;
	}
	else{
		cout << endl << endl << "Nome:                                   " <<
				"E-mail                                  " <<
				"Nota média:                             " << endl;

		for(int i = 0; i < res.size(); i++){
			cout << res[i][0] << printSpaces(res[i][0], MAX_SIZE_BAIRRO) <<
					res[i][1] << printSpaces(res[i][1], MAX_SIZE_BAIRRO) <<
					res[i][2] << printSpaces(res[i][2], MAX_SIZE_BAIRRO) << endl;
		}

		res.clear();
	}
}
