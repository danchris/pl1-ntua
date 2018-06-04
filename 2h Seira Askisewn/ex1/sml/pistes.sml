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


    

  fun containsTuple (_,[],ret) = ret
    | containsTuple (key:int,l,ret) =
    let
      val (a,b) = List.hd l
      val c = if (key = a) then true else false
    in
      if c then containsTuple(key,List.tl l, (a,b))
      else containsTuple(key,List.tl l,ret)
    end
  


  fun canPlay ([],_,true) = true
    | canPlay ([],[],false) = false
    | canPlay (_,_,false) = false
    | canPlay (pistaL,ownL,flag) = 
  let
    val (k,n) = List.hd pistaL
    val f = containsTuple(k,ownL,(0,0))
  in
    if (f = (0,0)) then canPlay(List.tl pistaL,ownL,false)
    else 
      let
        val tmpN = #2 f
      in
        if (tmpN>=n) then (canPlay(List.tl pistaL,ownL,true))
        else canPlay(List.tl pistaL,ownL,false)
      end
  end

  (* State = (currPista,availablePistes,keysOwn,stars)
  *  currPista = (id,nKeysN,nKeysE,stars,KeysNeed,KeysEar)
  *  availablePistes = list of pistes
  *  keysOwn list of tuples (key,number)
  *
  * *)

  
  fun addOrRemoveKeys ([],_,_) = []
    | addOrRemoveKeys (_,[],_) = []
    | addOrRemoveKeys (keysOwn, otherL, add) =  
    let
      val (myK,myN) = List.hd otherL
      val (tmpK,tmpN) = containsTuple(myK,keysOwn,(0,0))
      val (newK,newN) = if (add = 0) then (myK,myN-tmpN) else (myK,myN+tmpN)
    in
        (newK,newN)::addOrRemoveKeys(keysOwn,List.tl otherL,add)
    end

  fun existsInList (_,[],prev:bool) = prev
    | existsInList (id:int,l:int list,prev:bool) = 
    if (id = List.hd l) then existsInList(id,List.tl l,true)
    else existsInList (id,List.tl l,prev)

  fun returnAvailablePistes ([],[]) = []
    | returnAvailablePistes ([],_) = []
    | returnAvailablePistes ((id:int,ki:int,ri:int,si:int,kn,ke)::cs,[]) = (id:int,ki:int,ri:int,si:int,kn,ke)::cs
    | returnAvailablePistes ((id:int,ki:int,ri:int,si:int,kn,ke)::cs,visited) = 
  let
    val t:bool = existsInList(id,visited,false)
  in
    if t then returnAvailablePistes(cs,visited)
    else (id,ki,ri,si,kn,ke)::returnAvailablePistes(cs,visited)
  end 
  
  fun giveMePistesfromAvailable (_,[],_,_) = []
    | giveMePistesfromAvailable ((cid:int,cki:int,cri:int,csi:int,ckn,cke), ((id:int,ki:int,ri:int,si:int,kn,ke)::cs), keysOwn,_) =
    if (canPlay(kn,keysOwn,true)) then
        if (ki > length(keysOwn)) then 
                                giveMePistesfromAvailable((cid,cki,cri,csi,ckn,cke),cs,keysOwn,~1)
                            else 
                              (id,ki,ri,si,kn,ke)::giveMePistesfromAvailable((cid,cki,cri,csi,ckn,cke),cs,keysOwn,~1)
        else
                            giveMePistesfromAvailable((cid,cki,cri,csi,ckn,cke),cs,keysOwn,~1)


  fun playPista ((cid:int,cki:int,cri:int,csi:int,ckn,cke),(id:int,ki:int,ri:int,si:int,kn,ke),keysOwn,stars) =
  let
    val rm = addOrRemoveKeys(keysOwn,kn,0)
    val add = addOrRemoveKeys(rm,ke,1)
  in
    ((id,ki,ri,si,kn,ke),add,si+stars)
  end

  fun helper (_,[],_,_,_,retL,best) = (retL,best)
    | helper (pista,listOfPistes,keys,stars,visited,retL,best) =  
  let
    val p = List.hd listOfPistes
    val id = #1 p
    val newV = [id]@visited
    val (nextCurr,newKeys,newStars) = playPista(pista,List.hd
    listOfPistes,keys,stars)
    val newBest = if (newStars > best) then newStars else best
    val newRetL = (nextCurr,listOfPistes,newKeys,newStars,newV)::retL
  in
    helper(pista,(List.tl listOfPistes),keys,stars,visited,newRetL,newBest)
  end
 

  fun solver ([],best) = []
    | solver (openSet,best) =
    let
      val currState = List.hd openSet
      val currPista = #1 currState
      val pistesList = #2 currState
      val keysOwn = #3 currState
      val stars = #4 currState
      val visited = #5 currState
      val tmpL = returnAvailablePistes(pistesList,visited)
      val actualList = giveMePistesfromAvailable(currPista,tmpL,keysOwn,~1)
      val (retListsOfStates,tmpBest) = helper(currPista,actualList,keysOwn,stars,visited,[],best)
    (*  val newBest = if (tmpBest > best) then tmpBest else best*)
      val newOpen = (List.tl openSet) @ retListsOfStates
      val newH = List.hd newOpen
      val newCurr = #1 newH
      val newId:int = #1 newCurr
    in
      retListsOfStates
    end
  
  val (n,allPistes) = parse file
  
  val initPista = List.hd allPistes
  val initKeys = #6 initPista
  val initStars = #4 initPista
  val initNOwn = #3 initPista
  val visited = [(#1 initPista)]
  val init = (initPista, allPistes, initKeys, initStars, visited)

  val openSet = [init]
  val solution = solver(openSet,initStars)
in
  solution
end
