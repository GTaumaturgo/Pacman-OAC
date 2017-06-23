#include <bits/stdc++.h>
#include <iomanip>
#include <string>
using namespace std;


// Esse programa só funciona com arquivos com dimensões menores
// que 255x255
int main(){

	ifstream in; 
	ofstream out;
	string nome_bmp;
	string nome_bin;
	vector<string> nomes;
	nomes.push_back("pacman");
	nomes.push_back("preto");
	nomes.push_back("comida");
	nomes.push_back("comida-grande");
	nomes.push_back("fantasma-azul");
	nomes.push_back("fantasma-laranja");
	nomes.push_back("fantasma-rosa");
	nomes.push_back("fantasma-vermelho");
	nomes.push_back("canto1");
	nomes.push_back("canto2");
	nomes.push_back("canto3");
	nomes.push_back("canto4");
	nomes.push_back("horizontal");
	nomes.push_back("vertical");
	for(auto nome: nomes){

		nome_bin = nome + ".bin";
		nome_bmp = nome + ".bmp";

		in.open(nome_bmp,ifstream::binary);
		out.open(nome_bin,ofstream::binary);

		in.seekg(18,in.beg);
		char largura;
		char altura;
		in.read(&largura,1);
		in.seekg(22,in.beg);
		in.read(&altura,1);
		unsigned char acc;
		// acc = largura;
		// out << acc;
		// acc = altura;
		// out << acc;	
		unsigned char aux;
		in.seekg(54,in.beg);
		for (int i = altura-1; i > -1; --i)
		{                                   // NUMERO DE 0S QUE APARECEM NO MEIO
			in.seekg(54 + (largura*i*3) + ((4 - (largura % 4)) % 4) * i,in.beg);
			for (int j = 0; j < largura; ++j)
			{
				acc = 0;		 		
				in >> aux;
				aux = aux/64;
				acc += aux << 6;
				in >> aux;
				aux = aux/32;
				aux = aux << 3;
				acc += aux;
				in >> aux;
				aux = aux/32;
				acc += aux;
				out << acc;
			}
		}

		in.close();
		out.close();

	}
}