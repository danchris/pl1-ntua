(***************************************************************************
  Project     : Programming Languages 1 - Assignment 1 - Exercise 1
  Author(s)   : <Author name> (<author mail>)
  Date        : April 08, 2013
  Description : Teh S3cret Pl4n
  -----------
  School of ECE, National Technical University of Athens.
*)

(* Input parse code by Stavros Aronis, modified by Nick Korasidis. *)
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
	fun readInts 0 acc = acc (* Replace with 'rev acc' for proper order. *)
	  | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
   	(n, readInts n [])
    end

(* Dummy solver & requested interface. *)
fun solve (n, sizelist) = (42, 42)
fun countries fileName = solve (parse fileName)
			 
(* Uncomment the following lines ONLY for MLton submissions.
val _ =
    let
        val (a, b) = countries (hd (CommandLine.arguments()))
    in
        print(Int.toString a ^ " " ^ Int.toString b ^ "\n") 
    end
*)
