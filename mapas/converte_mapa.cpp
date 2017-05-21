//Esse arquivo vai conveter os mapas.txt para mapas.bin,
//e mapas.texture,dessa forma, será mais fácil mapear texturas na tela e
//Passar o mapa para a memória, será também mais rápido.
//acredito que desempenho será um problema nesse trabalho.
#include <bits/stdc++.h>
#include <iomanip>
#include <string>
using namespace std;

char largura;
char altura;
char mapa[40][40];

char getTextura(int i, int j){

	if(i > 0 and i < altura - 1 and mapa[i-1][j] == 'W' and mapa[i+1][j] == 'W')
		return '0'; // parede vertical
	if(j > 0 and j < largura - 1 and mapa[i][j-1] == 'W' and mapa[i][j+1] == 'W')
		return '1'; // parede horizontal
	if(i > 0 and j < largura - 1 and mapa[i-1][j] == 'W' and mapa[i][j+1] == 'W')
		return '2'; // parede curva cima-direita 
	if(j > 0 and i < altura - 1 and mapa[i+1][j] == 'W' and mapa[i][j-1] == 'W')
		return '3'; // parede curva baixo-esquerda
	if(i < altura - 1 and j < largura - 1 and mapa[i+1][j] == 'W' and mapa[i][j+1] == 'W')
		return '4'; // parede curva baixo-direita
	if(i > 0 and j > 0 and mapa[i-1][j] == 'W' and mapa[i][j-1] == 'W')
		return '5'; // parede curva cima-esquerda
	return '6'; // parede sozinha

}



int main(){
	string nome_txt;
	string nome_bin;
	string nome_texture;
	char aux[100];
	printf("Digite o nome arquivo que quer gerar os .bin e .texture\n");
	cin >> nome_txt;
	nome_bin = nome_txt + ".bin";
	nome_texture = nome_txt + ".texture";
	nome_txt = nome_txt + ".txt";

	ofstream bin;
	bin.open(nome_bin,ofstream::binary);
	ofstream texture;
	texture.open(nome_texture,ofstream::binary);	

	ifstream txt; 
	txt.open(nome_txt);

	txt >> aux;
	largura = stoi(aux);
	// bin << largura;
	// texture << largura;
	txt >> aux;
	altura = stoi(aux);
	// bin << altura;
	// texture << altura;

	

	
	char x;
	for (int i = 0; i < altura; ++i)
	{
		txt.read(&x,1);
		for (int j = 0; j < largura; ++j)
		{
			txt.read(&x,1);
			mapa[i][j] = x;
			bin << x;
		}
	}
	

	for (int i = 0; i < altura; ++i)
	{
		for (int j = 0; j < largura; ++j)
		{	
			// printf("%c",mapa[i][j]);
			if(mapa[i][j] == 'E')
				texture << 'E';
			else if(mapa[i][j] == 'F'){
				texture << 'F';
			}
			else if(mapa[i][j] == 'B'){
				texture << 'B';
			}
			else if(mapa[i][j] == 'P')
				texture << 'P';
			else if(mapa[i][j] == 'A')
				texture << 'A';
			else if(mapa[i][j] == 'R')
				texture << 'R';
			else if(mapa[i][j] == 'L')
				texture << 'L';
			else if(mapa[i][j] == 'V')
				texture << 'V';
			else if(mapa[i][j] == 'W'){
				char t = getTextura(i,j);
				texture << t;
			}
		}
		// printf("\n");
	}

	txt.close();
	bin.close();
	texture.close();


	return 0;
}