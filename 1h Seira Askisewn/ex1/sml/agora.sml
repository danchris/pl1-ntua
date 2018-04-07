fun solver (_,[]) = (0,0)
  | solver (n,xi) = 
let
  fun gcd (a:IntInf.int, 0) = a
    | gcd (0, b:IntInf.int) = b
    | gcd (a:IntInf.int,b:IntInf.int) = 
        if (a<b) then gcd (a, (b mod a))
        else gcd (b, (a mod b))

  fun lcm (a:IntInf.int,b:IntInf.int) = 
  let
    val d = gcd (a,b)
    val k = b div d
  in
    a * k
  end
  
  fun listLCM ([],_) = []
    | listLCM ((a:IntInf.int,b:int)::xs,prev:IntInf.int) = 
    let
      val k:IntInf.int = lcm (a,prev)
    in
      (k,b)::listLCM(xs,k)
    end
    
  val (m:IntInf.int,p) = hd xi;
  val runningLCM = listLCM (xi,m);
  val xiReverse = rev(xi);
  val (z:IntInf.int,w) = hd xiReverse;
  val runningLCMReverse = listLCM(xiReverse,z);

  val (min,village) = List.last runningLCM;
  val r = rev(runningLCMReverse);
  val start = tl (tl r);

  fun result [] [] (_,_) = (0,0)
    | result [] _ (min:IntInf.int,village) = (min,village)
    | result _ [] (min:IntInf.int,village) = (min,village)
    | result ((a:IntInf.int,b)::xs) ((q:IntInf.int,r)::ys) (min:IntInf.int,village) =
    let
      val t = lcm(a,q);
      val (tempM,tempV) = if (t<min) then (t,(b+1)) else (min,village)
    in
      result xs ys (tempM,tempV)
    end

  val (m,v) = result runningLCM start (min,village) 
  in
    (m,if(m=min) then 0 else v)
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
  (n,xi)
end

(* Dummy solver & requested interface. *)

fun agora fileName = solver(parse fileName)
