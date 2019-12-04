module exercises

import IO;
import Set;
import List;
import Map;
import Relation;
import ListRelation;
import String;
import analysis::graphs::Graph;	
import util::Resources;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import vis::Figure;
import vis::Render;
import vis::KeySym;

public bool ascendingOrderByRelationValue(<&T a, num b>, <&T c, num d>){
	return b < d;
}

public bool descendingOrderByRelationValue(<&T a, num b>, <&T c, num d>){
	return b > d;
}

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
	println((S : size(predecessors(G, S)) | S <- gElements));
}

public void exercise9(){

	Resource jabber = getProject(|project://JabberPoint/|);
	M3 model = createM3FromEclipseProject(|project://JabberPoint/|);	
	set[Declaration] AST = createAstsFromEclipseProject(|project://JabberPoint/|, false);
	
	int javaFilesNumber = 0;
	map[str, int] javaFileLines = ();
	set[str] filesList = {};
	
	visit(jabber) {
		case file(l):
		if (l.extension == "java") {
			filesList += l.uri;
			javaFilesNumber+=1;
			list[str] linesList = readFileLines(l);
			javaFileLines[l.file] = size(linesList);
		}
	}
	
	public int countIfs(Statement method) {
		int count = 0;
		visit(method) {
			case \if(_,_): count+=1;
			case \if(_,_,_): count+=1;
		}
		return count;
	}
	

	println("a. Calculate the number of Java files that make up the project.");
	println(javaFilesNumber);
	
	println("b. Report the number of lines per Java file, in descending order.");
	println(sort(toList(javaFileLines), descendingOrderByRelationValue));
	
	println("c. Sort the classes in the project by the number of methods.");
	lrel[loc, int] methodsPerClass = [<c, size({m | m <- model.containment[c], m.scheme == "java+method" })> | c <- classes(model)];
	println(sort(methodsPerClass, ascendingOrderByRelationValue ));
	
	println("d. Find which class has the most (direct or indirect) subclasses.");
	lrel[loc, int] subclassPerClass = [<c, size({sc | sc <- (toList(model.typeDependency)+)[c], sc.scheme == "java+class" })> | c <- classes(model)];
	println(last(sort(subclassPerClass, ascendingOrderByRelationValue)));
	
	println("e. Find which method has the most if statements.");
	set[loc] myMethods = methods(model);
	lrel[str, Statement] methodContents = [];
	visit(AST) {
		case \method(_, name, _, _, impl): methodContents += <name, impl>;
		case \constructor(name, _, _, impl): methodContents += <name, impl>;
	}
	lrel[str, int] ifOccurences = [<name, countIfs(impl)> | <name, impl> <- methodContents];
	println(last(sort(ifOccurences, ascendingOrderByRelationValue)));
	
}

public void exercise10a(){
	
	list[Figure] boxes = [box(aspectRatio(1.0), fillColor("Red")) | N <- [0..10]];
	render("10a", hcat(boxes, height(50)));
	
}

public void exercise10b(){
	
	bool isSquare = true;
	bool shapeShift(int butnr, map[KeyModifier,bool] modifiers){
		isSquare = !isSquare;
		return true;
	}
	Figure shapeChanger(){
		square = box(shrink(0.2), aspectRatio(1.0), fillColor("Red"), onMouseDown(shapeShift));
		circle = ellipse(shrink(0.2), aspectRatio(1.0), fillColor("Green"),	onMouseDown(shapeShift));
		return computeFigure(Figure() {return isSquare ? square : circle; });
	}
	
	container = box(shapeChanger());
	render("10b", container);	
}

public void exercise10c(){

	map[str, int] jabberSizes = ("AboutBox.java":28, "Accessor":30, "BitmapItem":67,
	"DemoPresentation":50, "JabberPoint":37, "KeyController":44,
	"MenuController":109, "Presentation":107, "Slide":85,
	"SlideItem": 38, "SlideViewerComponent":62,
	"SlideViewerFrame":36, "Style.java":57, "TextItem.java":108,
	"XMLAccessor":112);

	list[Figure] sizesMap = [ box(text(name), area(size), fillColor(arbColor())) | <name, size> <- toList(jabberSizes) ];
	t = treemap(sizesMap);
	render("10c", t);	

}