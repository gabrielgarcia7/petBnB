# petBnB
Projeto de contrato temporário de itens e serviços para animais de estimação.<br><br>

<h3>Desenvolvedores</h3>
<ul>
  <li>Caio Augusto Duarte Basso</li>
  <li>Gabriel Garcia Lorencetti</li>
  <li>Giovana Daniele da Silva</li>
  <li>Luíza Pereira Pinto Machado</li>
</ul><br>
  
<h3>Descrição</h3>
<p>O projeto tinha por objetivo o oferecimento de algumas variedades de contratos temporários de produtos e serviços destinados aos animais (por intermédio, é claro, de seus apaixonados donos), sendo elas os serviços de adestramento, passeio e hospedagem e, ainda, a possibilidade do aluguel de itens
(como brinquedos ou acessórios), de forma a prover diversão e cuidado aos bichinhos.<p>
<p>Na aplicação desenvolvida utilizou-se o SGBD relacional PostgreSQL versão 12.2, além da linguagem C++17. De forma a possibilitar a conexão entre a aplicação e a base de dados, fez-se uso da API <em>libpqxx</em> , tida como oficial para conexão de aplicações C++ com banco de dados PostgreSQL.<p>
<p>A aplicação foi desenvolvida, testada e executada no sistema operacional Linux Mint 19.3 Tricia, com compilador g++ versão 7.5.0. <strong>Algumas funções utilizadas podem não funcionar para usuários de Windows e Mac.</strong></p><br>

<h3>Instalações</h3>
<p>As seguintes diretivas foram executadas no terminal de forma a prover todas as dependências necessárias à aplicação. Vale ressaltar que tanto o compilador g++ como o psql e o pgadmin haviam sido previamente instalados na máquina (logo, suas instalações não constam a seguir).</p>

```
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

$ eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

$ brew install xmlto

$ brew install libpqxx
```

<br><h3>Execução</h3>
  <p>Para compilar:</p>
  
  ```
  $ make all
  ```
  
  <p>Para executar:</p>
  
  ```
  $ make run
  ```
  
  <br><h3>Modelagem</h3>
  <ul>
  <li><a href="//github.com/giovanadanieles/petBnB/raw/master/modelagem/DER.png" target="_blank">Diagrama Entidade Relacionamento (DER)</a>;</li>
  <li><a href="//github.com/giovanadanieles/petBnB/raw/master/modelagem/MR.png" target="_blank">Modelo Relacionar (MR)</a>.</li> 
  </ul>
