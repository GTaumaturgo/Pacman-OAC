#include <bits/stdc++.h>
#include <iomanip>
#include <string>
using namespace std;



int main(){

	int n = 1200;
	for (int i = 0; i < n; ++i)
	{
		char aux[10];
		cin >> aux;
		printf("0x%s",aux);
		if(i != n-1)
			printf(", ");
	}


}