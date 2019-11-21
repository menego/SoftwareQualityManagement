module Test

import IO;
import List;
import String;

list[str] eu = ["Austria", "Belgium", "Bulgaria", "Czech Republic",
"Cyprus", "Denmark", "Estonia", "Finland", "France", "Germany",
"Greece", "Hungary", "Ireland", "Italy", "Latvia", "Lithuania",
"Luxembourg", "Malta", "The Netherlands", "Poland",
"Portugal", "Romania", "Slovenia", "Slovakia", "Spain",
"Sweden", "United Kingdom"];

public void namesContainingS(){
	list[str] filtered = [country | str country <- eu, /s/i := country ];
	print(filtered);
}

public void namesContainingAtLeasTwoE(){
	list[str] filtered = [country | str country <- eu, size([ match | /<match:e>/ := country]) >= 2 ];
	print(filtered);
}

public void namesContainingExactlyTwoE(){
	list[str] filtered = [country | str country <- eu, size([ match | /<match:e>/ := country]) == 2 ];
	print(filtered);
}

public void namesContainingNoNAndNoE(){
	list[str] filtered = [country | str country <- eu, /n|e/i !:= country ];
	print(filtered);
}

public void namesContainingAnyLetterAtLeatTwice(){
	list[str] filtered = [country | str country <- eu, /<x:\w>.*<x>/i := country ];
	print(filtered);
}

public void replaceFirstAWithO(){
	// list[str] filtered = [ country | str country <- eu, /a/i := country ]; BUGGED
	for(str country <- eu) {
		if(/A/ := country ) { print(replaceFirst(country, "A", "O")); print(", ");}
		else if(/a/ := country ) { print(replaceFirst(country, "a", "o")); print(", ");}
	}
}
