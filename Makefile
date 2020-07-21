all:
	g++ petBnB.cpp bd/queries.cpp bd/conexao.cpp -Wall -std=c++17 -lpqxx -lpq -g -o petBnB

rm:
	rm petBnB

run:
	./petBnB
