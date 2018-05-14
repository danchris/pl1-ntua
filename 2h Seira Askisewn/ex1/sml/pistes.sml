
fun pistes file=

let

  fun parse file = 
  let
    fun readInt input = 
      Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)

    val stream = TextIO.openIn file
    val n = readInt stream
    val _ = TextIO.inputLine stream

    fun scanner 0 acc = rev acc
      | scanner i acc = 
      let
        val ki = readInt stream
        val ri = readInt stream
        val si = readInt stream

        fun scanRest 0 a = rev a
          | scanRest j a = scanRest (j-1) (readInt stream :: a)

        val kiList = scanRest ki []
        val riList = scanRest ri []
      (*  val rest = scanRest (ki+ri) []  *)
        val all = (n-i+1,ki,ri,si,kiList,riList)
   (*     val all = first @ rest *)
      in
        scanner (i-1) (all::acc)
      end
    val ret = scanner n [];
        
  in
    (n,ret)
  end
 
  val (n,allPistes) = parse file
in
  (n,allPistes)
end
