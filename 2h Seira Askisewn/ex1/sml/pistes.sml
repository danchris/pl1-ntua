(*The stack module is taken from https://github.com/chrisamaphone/compose2015/blob/master/stack.sml *)
signature STACK =
sig
  exception E
  type 'a stack
  val new : 'a stack
  val push : 'a -> 'a stack -> 'a stack
  val pop : 'a stack -> 'a stack
  val top : 'a stack -> 'a
  (* step 2 *)
  val size : 'a stack -> int
end

structure ListStack : STACK =
struct
  exception E
  type 'a stack = 'a list
  val new = []
  fun push x s = x::s
  fun split (h::t) = (h,t)
    | split _ = raise E
  fun pop s = #2(split s)
  fun top s = #1(split s)
    (* *** *)
  fun size l = List.length l
end

(* Run these in the repl:
val emptyStack = ListStack.new;
val stack0 = ListStack.push 0 emptyStack;
*)

(* maintain constant size *)
structure SizedStack : STACK =
struct
  exception E
  type 'a stack = ('a list * int)
  val new = ([], 0)
  fun push x (stack, size) = (x::stack, size + 1)
  fun split (h::t) = (h,t)
    | split _ = raise E
  fun pop (stack, size) = (#2(split stack), size - 1)
  fun top (stack, size) = #1(split stack)
  fun size (stack, sz) = sz
end
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
        val all = (n-i+1,ki,ri,si,kiList,riList, (length riList))
        (*     val all = first @ rest *)
             in
               scanner (i-1) (all::acc)
end
    val ret = scanner n [];

      in
        (n,ret)
      end

  val (n,allPistes) = parse file
  val pistesAvailable = (List.tl allPistes)
  val emptyStack = ListStack.new
  val tmpRoot = ((List.hd allPistes), pistesAvailable)
  val root = ListStack.push tmpRoot emptyStack

  (*val other = (((List.hd allPistes) @ tmp),pistesAvailable)*)
  fun giveMePistes (_ ,[]) = []
    | giveMePistes ((cid:int,cki:int,cri:int,csi:int,ckn:int list,cke:int
    list,nOwn:int ), ((id:int,ki:int,ri:int,si:int,kn:int list,ke:int list,k:int)::cs)) = 
    if ( kn > nOwn ) then giveMePistes ((cid,cki,cri,csi,ckn,cke,nOwn) ,cs)
    else 
       (id,ki,ri,si,kn,ke,k)::giveMePistes ((cid,cki,cri,csi,ckn,cke,nOwn), cs)



  val other  = giveMePistes tmpRoot
  (*
  fun solver [] [] max = max
    | solver ((cId,cKi,cRi,cSi,cKn,cKe,cL)::cs) ((id,ki,ri,si,kn,ke,l)::ns) max = 
    let
  fun playPista 
  in
  end

  *)
in
other 
   (*(n,allPistes)  *)
end
