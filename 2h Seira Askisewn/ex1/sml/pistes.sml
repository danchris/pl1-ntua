fun pistes file =
let

    (* check if a pista exists in visited *)
  fun existsInList (_,[],prev:bool) = prev
    | existsInList (id:int,l:int list,prev:bool) = 
    if (id = List.hd l) then existsInList(id,List.tl l,true)
    else existsInList (id,List.tl l,prev)
  
    (* search if a key contains in simple int list *)
  fun contains (_,[],_) = false
    | contains (_,_,true) = true
    | contains (key:int,(a:int)::cs, prev:bool) = 
    let
      val ret = if (key = a) then true else false
    in
      contains (key,cs,ret)
    end

    (* returns the number of times of a key in int list *)
  fun numberOfKeyInList (_,[]) = 0
    | numberOfKeyInList (key: int ,(other:int) ::cs) = 
    if (key = other) then 1 + numberOfKeyInList(key,cs)
    else numberOfKeyInList (key,cs)
    

 (* creates a list from tuples (key,number) *)
  fun createKeyList ([],_) = []
    | createKeyList ((k::cs) ,checked:int list) =
    let
      val check = contains(k,checked,false)
    in
    if (check) then createKeyList(cs,checked)
      else (
          let
              val newC =  k::checked 
              val number = numberOfKeyInList(k,(k::cs))
          in
            (k,number)::createKeyList(cs,[k]@newC)
            end
            )
    end
      (* reader *)
  fun parse file = 
      let
        fun readInt input =
          Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input) 
        val stream = TextIO.openIn file
        val n = readInt stream
        val n = n + 1
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
    

  (* check if key contained in tuple key list *)
  fun containsTuple (_,[],ret) = ret
    | containsTuple (key:int,l,ret) =
    let
      val (a,b) = List.hd l
      val c = if (key = a) then true else false
    in
      if c then containsTuple(key,List.tl l, (a,b))
      else containsTuple(key,List.tl l,ret)
    end
  



  (* if add = 0 then remove keys from list or add = 1 add keys used in play
  * pista*) 
  fun addOrRemoveKeys (_,[],_,retL) = retL
    | addOrRemoveKeys ([],_,_,retL) = retL
    | addOrRemoveKeys (keysOwn, otherL, add,retL) =  
    let
      val (myK,myN) = if (add = 0) then List.hd keysOwn else List.hd otherL
      val (tmpK,tmpN) = if (add = 0) then containsTuple(myK,otherL,(0,0)) else containsTuple(myK,keysOwn,(0,0))
      val (newK,newN) = if (add = 0) then (myK,myN-tmpN) else (myK,myN+tmpN)
      val newRetL = retL @ (if (newN = 0 ) then [] else [(newK,newN)] )
    in
      if (add = 0) then addOrRemoveKeys(List.tl keysOwn,otherL,add,newRetL)
      else addOrRemoveKeys(keysOwn,List.tl otherL,add,newRetL)
    end


    (* return a list with available pistes based on visited *)
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
  
    (* returns true if can play pista or false if can not play *)
  fun canPlay ([],_,true) = true
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

  fun returnFinalPistes (_,[]) = []
    | returnFinalPistes (keysOwn,(id:int,ki:int,ri:int,si:int,kn,ke)::cs) =
  let
    val ret = canPlay(kn,keysOwn,true)
  in
    if ret then (id,ki,ri,si,kn,ke)::returnFinalPistes(keysOwn,cs)
    else returnFinalPistes(keysOwn,cs)
  end

  fun giveMePistesToPlay (keysOwn,visited) = 
    let
      val notVisitYet = returnAvailablePistes (allPistes,visited)
      val finalPistes = returnFinalPistes(keysOwn,notVisitYet)
    in
      finalPistes
    end


  (* play pista and return a new state *)
  fun playPista ((cid:int,cki:int,cri:int,csi:int,ckn,cke),(id:int,ki:int,ri:int,si:int,kn,ke),keysOwn,stars) =
  let
    val rm = if (kn = []) then keysOwn else addOrRemoveKeys(keysOwn,kn,0,[])
    val add = if (rm = []) then ke else addOrRemoveKeys(rm,ke,1,rm)
  in
    (add,si+stars)
  end


  fun returnNextStates(_,[],retL,best) = (retL,best)
    | returnNextStates (currState:( (int*int*int*int*((int*int)list) *((int*int)list)) * ((int*int)list) *(int) *(int list) ) ,pistesCanPlay,retL,best) = 
  let
    val currPista:(int*int*int*int*(int*int)list *(int*int)list)  = #1 currState
    val pistaToPlay:(int*int*int*int*(int*int)list *(int*int)list)  = List.hd pistesCanPlay
    val keysOwn:(int*int) list = #2 currState
    val currStars:int = #3 currState
    val visited:int list = #4 currState
    val id:int = #1 pistaToPlay
    val (newKeys:(int*int)list,newStars:int) = playPista(currPista,pistaToPlay,keysOwn,currStars)
    val newBest:int = if (newStars > best) then newStars else best
    val newV:int list = visited @ [id]
    val newRetL = [(pistaToPlay,newKeys,newStars,newV)] @ retL   
  in

    returnNextStates(currState,List.tl pistesCanPlay,newRetL,newBest)
  end



  (*solver*)
  fun solver ([],best:int) = best
    | solver (openSet,best:int) =
    let
      val currState:( (int*int*int*int*((int*int)list) *((int*int)list)) * ((int*int)list) *(int) *(int list) )  = List.hd openSet
      val currPista:(int*int*int*int*(int*int)list *(int*int)list) = #1 currState
      val keysOwn:(int*int) list = #2 currState
      val stars:int = #3 currState
      val visited:int list = #4 currState
      val pistesCanPlay = giveMePistesToPlay(keysOwn,visited)
      val (nextStates,nextBest) = returnNextStates(currState,pistesCanPlay,[],best)
      val newOpen = rev(nextStates) @ (List.tl openSet) 
  in
      solver (newOpen, nextBest)
    end
  val initPista:(int*int*int*int*(int*int)list *(int*int)list) = List.hd allPistes
  val initKeys:(int*int)list = #6 initPista
  val initStars:int = #4 initPista
  val visited:int list = [(#1 initPista)]
  val init:((int*int*int*int*(int*int)list *(int*int)list)*(int*int)list*int*(int list) ) = (initPista, initKeys, initStars, visited)
  val openSet = [init]
  val solution = solver(openSet,initStars)
in
  print(Int.toString(solution) ^"\n")
end
