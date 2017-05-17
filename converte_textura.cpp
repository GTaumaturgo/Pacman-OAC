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
	printf("Digite o nome arquivo que quer gerar o .bin\n");
	cin >> nome_bmp;

	nome_bin = nome_bmp + ".bin";
	nome_bmp = nome_bmp + ".bmp";

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
		in.seekg(54 + (largura*i*3) + ((4 - (largura % 4)) % 4) * (i),in.beg);
		for (int j = 0; j < largura; ++j)
		{
			acc = 0;		 		
			in >> aux;
			aux = aux/32;
			aux = (char)aux;
			acc += aux;
			in >> aux;
			aux = aux/32;
			aux = (char)aux;
			aux = aux << 3;
			acc += aux;
			in >> aux;
			aux = aux/64;
			aux = (char)aux;
			acc += aux << 6;
			out << acc;
		}
	}

	in.close();
	out.close();

}