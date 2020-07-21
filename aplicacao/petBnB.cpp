/*
Projeto – Animais Domésticos e Exóticos
Contrato temporário de itens e serviços para animais de estimação

Caio Augusto Duarte Basso – 10801173
Gabriel Garcia Lorencetti – 10691891
Giovana Daniele da Silva – 10692224
Luíza Pereira Pinto Machado – 7564426
*/

#include "bd/queries.h"
#include "bd/conexao.h"

#include <thread>
#include <chrono>
#include <unistd.h>

#define ERROR 404

using namespace std;

conexaoBD* petBnB = new conexaoBD;

void printMenu(){
	cout << "O que deseja?" << endl << endl;

	cout << "1. Cadastrar um novo pet;" << endl;
	cout << "2. Consultar pets atualmente cadastrados;" << endl;
	cout << "3. Exibir o ranking de comerciantes mais bem avaliados em um dado bairro;" << endl;
	cout << "4. Sair."<< endl << endl;

	cout << "Escolha uma das opções acima, bastando digitar o número da mesma a seguir: ";
}

// Aqui foi desenvolvido um CRUD básico, baseado no usuário logado.
void fluxoMenu(char op, pair<string, string> user){
	switch(op){
		case '1':
			// Cadastra um novo pet ao usuário logado.
			cadastrarPet(petBnB, user.second);
		break;

		case '2':
			// Consulta os pets que o usuário logado possui.
			consultarPet(petBnB, user.second);
		break;

		case '3':
			rankingPassBairro(petBnB);
		break;

		default:
			if((op - '0') != 4) cout << endl << "Escolha uma opção válida!" << endl << endl;
			else cout << endl << endl << "Até mais!" << endl;
		break;
	}

	if((op - '0') != 4){
		std::this_thread::sleep_for(std::chrono::milliseconds(500));

		cout << endl << endl << "Pressione qualquer tecla para deixar esta tela e voltar ao menu principal." << endl;

		cin.ignore();

		cout << "\033[2J\033[1;1H";
	}
}


// Vamos considerar, somente no contexto dessa simples aplicação,
//que o usuário "default" é o dono de pet; desta forma, nos preo-
//cuparemos unicamente com o CRUD dos pets;
int main(int argc, char* const argv[]){

	//Menu
	cout << "------------------------------------   petBnb   ------------------------------------" << endl;

	// Cria a conexão com o banco de dados;
	if(!petBnB->estabelecerConex()){
		cout << endl << "Não foi possível abrir o arquivo de credenciais." <<
		endl << "Impossível conectar com o banco de dados." << endl;

		delete petBnB;

		return ERROR;
	}
	else{
		// Aqui um um login primitivo foi desenvolvido. Nenhum tipo de criptografia
		//foi desenvolvida, por questões de tempo.
		// Além disso, muito provavelmente a função getpass() não funcionará em
		//usuários mac ou windows.
		string email;
		char* senha;
		pair<string, string> user;

		do{
			cout << "E-mail: ";
			cin >> email;

			senha = getpass("Senha: ");
		} while(!loginDonoPet(petBnB, email, senha, &user));


		cout << "\033[2J\033[1;1H";
		cout << "Bem-vindo(a), " << user.first << "!" << endl << endl;

		char op;

		do{
			printMenu();

			cin >> op;

			fluxoMenu(op, user);

		} while((op - '0') != 4);

		delete petBnB;

		return 0;
	}
}
