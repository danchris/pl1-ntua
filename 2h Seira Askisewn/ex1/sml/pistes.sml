(*
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
*)
fun pistes file=
let
  fun contains (_,[],_) = false
    | contains (_,_,true) = true
    | contains (key:int,(a:int)::cs, prev:bool) = 
    let
      val ret = if (key = a) then true else false
    in
      contains (key,cs,ret)
    end

  fun numberOfKeyInList (_,[]) = 0
    | numberOfKeyInList (key: int ,(other:int) ::cs) = 
    if (key = other) then 1 + numberOfKeyInList(key,cs)
    else numberOfKeyInList (key,cs)
    
  fun createKeyList ([],_) = []
    | createKeyList ((k::cs) ,checked:int list) =
      if (contains (k,checked,false)) then createKeyList(cs,checked)
      else
        (k,numberOfKeyInList(k,cs)+1)::createKeyList(cs,checked @ [k])
  
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
            val finalKi = createKeyList (kiList,[])
            val finalRi = createKeyList (riList,[])

            val all = (n-i+1,ki,ri,si,finalKi,finalRi)
            
                 in
                   scanner (i-1) (all::acc)
    end
    val ret = scanner n []

      in
        (n,ret)
      end

  val (n,allPistes) = parse file
  val pistesAvailable = (List.tl allPistes)
  val initNOwn = length(#6 (List.hd allPistes))
  val init = ((List.hd allPistes), pistesAvailable, initNOwn)

    

  fun containsTuple (_,[],ret) = ret
    | containsTuple (key:int,l,ret) =
    let
      val (a,b) = List.hd l
      val c = if (key = a) then true else false
    in
      if c then containsTuple(key,List.tl l, (a,b))
      else containsTuple(key,List.tl l,ret)
    end
  
  fun canPlay ([],_,_) = false
    | canPlay (_,_,false) = false
    | canPlay (_,[],prev:bool) = prev:bool
    | canPlay (ownList, needList, prev) =
    let
      val (k,n) = List.hd needList
      val (tK,tN) = containsTuple(k,ownList,(0,0))
      val ret:bool = if (tK = 0) then false
                else
                    if (n<tN) then true
                    else false
    in
      canPlay (List.tl needList, ownList, ret)
    end

                              


  fun giveMePistes (_ ,[],_) = []
    | giveMePistes ((cid:int,cki:int,cri:int,csi:int,ckn,cke), ((id:int,ki:int,ri:int,si:int,kn,ke)::cs), nOwn:int) =
    if (length(kn) > nOwn) then giveMePistes ((cid,cki,cri,csi,ckn,cke), cs,
    nOwn)
    else (id,ki,ri,si,kn,ke)::giveMePistes ((cid,cki,cri,csi,ckn,cke), cs,
    nOwn)





  (*val other  = giveMePistes init*)
(* 
  (*
  fun solver [] [] max = max
    | solver ((cId,cKi,cRi,cSi,cKn,cKe,cL)::cs) ((id,ki,ri,si,kn,ke,l)::ns) max = 
    let
  fun playPista 
  in
  end

  *)
  *)
  val l = [(1,1),(2,1)]
  val t = (0,0)
in
  canPlay([(1,2),(2,1)],[(1,1)],true)
(* allPistes*)
 (* numberOfKeyInList (1,[1,2,3,1,1])*)
 (*   init*)
end
