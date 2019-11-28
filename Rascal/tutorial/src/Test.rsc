module Test

import IO;
import Set;
import List;
import Relation;
import String;
import analysis::graphs::Graph;

public void exercise6(){

	list[str] eu = ["Austria", "Belgium", "Bulgaria", "Czech Republic",
	"Cyprus", "Denmark", "Estonia", "Finland", "France", "Germany",
	"Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania",
	"Luxembourg", "Malta", "The Netherlands", "Poland",
	"Portugal", "Romania", "Slovenia", "Slovakia", "Spain",
	"Sweden", "United Kingdom"];


	println("The name contains the letter s");
	set[str] filtered = {country | str country <- eu, /s/i := country };
	println(filtered);

	println("The name contains (at least) two e’s");
	filtered = {country | str country <- eu, size([ match | /<match:e>/ := country]) >= 2 };
	println(filtered);
	
	println("The name contains exactly two e’s");
	filtered = {country | str country <- eu, size([ match | /<match:e>/ := country]) == 2 };
	println(filtered);
		
	println("The name contains no n and also no e");
	filtered = {country | str country <- eu, /n|e/i !:= country };
	println(filtered);
	
	println("The name contains any letter at least twice");
	filtered = {country | str country <- eu, /<x:\w>.*<x>/i := country };
	println(filtered);
	
	println("The name contains an a: the first a in the name is replaced by an o ");
	filtered = { "<begin>o<end>" | str country <- eu, /<begin:[^a]*>a<end:.*>/i := country};
	println(filtered);
	
}

public void exercise7(){
	int upperLimit = 100;
	
	println("Compute the relationship between the natural numbers up to 100 and their divisors. Optionally make the upper limit a parameter.");
	list[int] computeDividends(int x) = [ N | int N <- [1 .. (x+1)] , x % N == 0 ];
	rel[int, int] numDivisorsRel = { <N, D> | int N <- [1 .. (upperLimit+1)], D <- [1..N+1], N%D == 0};
	println(numDivisorsRel);
	
	println("Compute which numbers have the most divisors.");
	map[int, set[int]] divisors = Relation::index(numDivisorsRel);	
	int mostDivisors = 0;
	for(int N <- [1 .. (upperLimit+1)]) {
		int size = Set::size(divisors[N]);
		mostDivisors = mostDivisors < size ? size : mostDivisors;
	}
	
	list[int] numMostDivisors = [N | N <- [1 .. (upperLimit+1)], Set::size(divisors[N]) == mostDivisors];
	println(numMostDivisors);
	
	println("Compute the list of prime numbers (up to 100) in ascending order.");
	list[int] primeNumbers = [ N | N <- [1 .. (upperLimit+1)], Set::size(divisors[N]) == 2];
	println(primeNumbers);
}

public void exercise8(){
	Graph[str] G = {<"A","B">, <"A","D">, <"B","D">, <"B","E">, <"C","B">, <"C","E">, <"C","F">, <"E","D">, <"E","F">};
	set[str] gElements = carrier(G);
	println("a. How many components does the system consist of?");
	println(size(gElements));
	println("b. How many dependencies are there between the components?");
	println(size(G));
	println("c. Which components are not used by any component?");
	println({ S.father | tuple[str father, str child] S <- G, size(predecessors(G, S.father)) == 0});	
	println("d. Which components are needed (directly or indirectly) for A?");
	println((G+)["A"]);
	println("e. Which components are not used (directly or indirectly) by C?");
	println(gElements - (G*)["C"]);
	println("f. How often is each component used?");
	//println((S : size(invert(G)[S]) | S <- gElements));
	println((S : size(predecessors(G, S)) | S <- gElements));
}
