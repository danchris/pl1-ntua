fun solver (_,[]) = print("Error: Empty file\n")
  | solver (n,xi) = 
let
  fun isPrime(n): bool =
    let 
      fun noDivisorsAbove(m) =
        if n mod m = 0 then false
        else if m*m >= n then true
        else noDivisorsAbove(m+1)
    in
      noDivisorsAbove(2)
    end

  fun listPrime [] = []
    | listPrime ((a,b)::ys) = 
    if isPrime(a) then (a,b)::listPrime(ys)
    else listPrime(ys)

  fun max((x,b),(y,z)) = if x > y then (x,b) else (y,z)

  fun goodMax [] = (0,0)
	| goodMax [(a,b)] = (a,b)
	| goodMax ((a,b)::xs) = 
	let 
		val (y,z) = goodMax(xs); 
	in 
		max((a,b),(y,z)) 
	end

  val (maxPrime,prime) = goodMax(listPrime(xi));
  val (maxVillage,maxx) = goodMax(xi);
    
  fun gcd (a:IntInf.int, 0) = a
    | gcd (0, b) = b
    | gcd (a:IntInf.int,b) = 
        if (a<b) then gcd (a, (b mod a))
        else gcd (b, (a mod b))
  
  fun findlcm ([],_) = 0
    | findlcm ([(a:IntInf.int,b)],e) = if (a<>e) then a else 0
    | findlcm ((a:IntInf.int,b)::xs,e) = 
        if (a <> e) then (a*findlcm(xs,e) div gcd(a,findlcm(xs,e)))
        else findlcm(xs,e)
  
  val listLcm:IntInf.int =  findlcm(xi,0);

  fun result [] = (0,0)
    | result ((a:IntInf.int,b)::xs) = 
        if (maxPrime <> 0) then 
            let 
              val primeLcm = findlcm((a,b)::xs,maxPrime);
            in
          if (primeLcm < listLcm) then (primeLcm,prime)
          else (listLcm,0)
            end
          else 
            let 
              val maxLcm = findlcm((a,b)::xs,maxVillage);
            in
              if(maxLcm < listLcm) then (maxLcm,maxx)
              else (listLcm,0)
            end

  fun printRes (k:IntInf.int,l) = print(IntInf.toString(k) ^ " " ^ Int.toString(l) ^ "\n")
  in
    printRes (result xi)
  end

fun parse file =
let
  (* A function to read an integer from specified input. *)
  fun readInt input = 
    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    (* Open input file. *)
  val inStream = TextIO.openIn file

  (* Read an integer (number of countries) and consume newline. *)
  val n = readInt inStream
  val _ = TextIO.inputLine inStream

  (* A function to read N integers from the open file. *)
  fun readInts 0 acc = rev acc (* Replace with 'rev acc' for proper order. *)
    | readInts i acc = readInts (i - 1) ((IntInf.fromInt(readInt inStream),(n-i+1)) :: acc)
  
  val xi = readInts n [];

in
  (n, xi)
end

(* Dummy solver & requested interface. *)

(*fun agora fileName = parse fileName*)
fun agora fileName = solver(parse fileName)
