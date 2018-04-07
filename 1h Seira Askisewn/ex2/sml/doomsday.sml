fun doomsday file = 
let

    
  
  val q = Queue.mkQueue () : (char*int*int*int) Queue.queue
  
  fun linelist file = 
  let 
    val instr = TextIO.openIn file
    val str =   TextIO.inputAll instr
  in
    String.tokens (fn x => x = #"\n")str before TextIO.closeIn instr
  end

  val doomsMapList = linelist file
  val doomsMap = Array2.fromList (map explode doomsMapList)
  val n = Array2.nRows(doomsMap)
  val m = Array2.nCols(doomsMap)
  
    fun printMap (doomsMap,i,j) = 
      if (i=n) then print("")
      else 
    let 
      val c = Array2.sub(doomsMap,i,j)
    in
      print (Char.toString(c));
      if ( (j+1) < m) then ( printMap (doomsMap,i,j+1))
      else (print("\n"); printMap(doomsMap,i+1,0))
    end
  
  fun createQueue (doomsMap,i,j) =
    if(i=n) then q
    else
      let 
        val el = Array2.sub(doomsMap,i,j)
  in
    (if(el <> #"X" andalso el <> #".") then 
      let
        val _ = Queue.enqueue(q,(el,i,j,0))
      in 
        true
      end
    else false);
    if ( (j+1) < m) then createQueue (doomsMap,i,j+1)
    else createQueue (doomsMap,i+1,0)
  end
 
 
  fun printList [] = print("\n")
    | printList l =
    let val (a,i,j,dt) = hd l
    in
      print("("^Char.toString(a) ^","^ Int.toString(i) ^","^ Int.toString(j) ^
      ","^Int.toString(dt)^")");
      printList (tl l)
    end
  val q = createQueue (doomsMap,0,0)
  
  fun createList (doomsMap,i,j) =
    if(i=n) then []
    else
      let 
        val el = Array2.sub(doomsMap,i,j)
  in
    if(el <> #"X" andalso el <> #".") then
      if((j+1)<m) then (el,i,j,0)::(createList (doomsMap, i, j+1))
      else (el,i,j,0)::(createList (doomsMap,i+1,0))
      else 
        if((j+1)<m) then createList (doomsMap, i, j+1)
        else createList (doomsMap,i+1,0)
  end
  
  val currentList = createList (doomsMap, 0, 0)


  fun goUp (doomsMap,a,i,j) = 
    (if(i>0) then
      if(Array2.sub(doomsMap,i-1,j) = #".") then 
        let
          val _ = Array2.update(doomsMap,i-1,j,a)
      in 
        1
      end
      else if(Array2.sub(doomsMap,i-1,j) <> #"X" andalso
      Array2.sub(doomsMap,i-1,j) <> a) then 
        let 
          val _ = Array2.update(doomsMap,i-1,j,#"*")
        in
          ~1
        end
        else 0
    else 0
    )

  fun goDown (doomsMap,a,i,j) = 
    (if(i<(n-1)) then
      if(Array2.sub(doomsMap,i+1,j) = #".") then 
        let
          val _ = Array2.update(doomsMap,i+1,j,a)
        in 
          1
        end
      else if(Array2.sub(doomsMap,i+1,j) <> #"X" andalso
      Array2.sub(doomsMap,i+1,j) <> a) then 
        let 
          val _ = Array2.update(doomsMap,i+1,j,#"*")
        in
          ~1
        end
        else 0
    else 0
    )

  fun goRight (doomsMap,a,i,j) =
    (if(j<(m-1)) then
      if(Array2.sub(doomsMap,i,j+1) = #".") then 
        let
          val _ = Array2.update(doomsMap,i,j+1,a)
        in 
          1
        end
      else if(Array2.sub(doomsMap,i,j+1) <> #"X" andalso
      Array2.sub(doomsMap,i,j+1) <> a ) then 
        let 
          val _ = Array2.update(doomsMap,i,j+1,#"*")
        in
          ~1
        end
        else 0
    else 0
    )

  fun goLeft (doomsMap,a,i,j) = 
    (if(j>0) then
      if(Array2.sub(doomsMap,i,j-1) = #".") then 
        let
          val _ = Array2.update(doomsMap,i,j-1,a)
        in 
          1
        end
      else if(Array2.sub(doomsMap,i,j-1) <> #"X" andalso 
      Array2.sub(doomsMap,i,j-1) <> a) then 
        let 
          val _ = Array2.update(doomsMap,i,j-1,#"*")
        in
          ~1
        end
        else 0
    else 0
    )

  fun examNeighbours (doomsMap,a,i,j) = 
    let 
      val up = goUp (doomsMap,a,i,j)
      val down = goDown (doomsMap,a,i,j)
      val right = goRight (doomsMap,a,i,j)
      val left = goLeft (doomsMap,a,i,j)
    in
        (up,down,right,left)
    end

  
  fun solver ([],_) = ([],0,0)
    | solver (((a,i,j,dt)::cs),t)  = 
  let
   
    val (u,d,r,l) = examNeighbours (doomsMap,a,i,j)
    val rU = if (u = 1) then ((Array2.sub(doomsMap,i-1,j),i-1,j,dt+1)::[]) else []
    val rD = if (d = 1) then ((Array2.sub(doomsMap,i+1,j),i+1,j,dt+1)::[]) else []
    val rR = if (r = 1) then ((Array2.sub(doomsMap,i,j+1),i,j+1,dt+1)::[]) else []
    val rL = if (l = 1) then ((Array2.sub(doomsMap,i,j-1),i,j-1,dt+1)::[]) else []
    val newL = cs @ rU @ rD @ rR @ rL
    val flag = if (u = ~1 orelse d = ~1 orelse r = ~1 orelse l = ~1) then 1 else 0
    val flag1 = if (newL = [] ) then 1 
                else if (#4 (hd newL) < dt) then  3
                else if (#4 (hd newL) = dt ) then 2
                else if (#4 (hd newL) > dt) then  0
                else 1
  in
    if (flag=1 andalso flag1=1 ) then (newL,dt+1,~1)
    else if (flag=1) then (newL,dt+1,~2)
    else  solver (newL,dt)
  end


  val (cL,final,e) = solver (currentList,0)
  fun completeMap ([],t:int) = false
    | completeMap ((a,i,j,dt:int)::cs,t:int) =

    if (dt = t) then false
    else
    let 
       val (u,d,r,l) = examNeighbours (doomsMap,a,i,j)
    in
      completeMap (cs,t)
    end
in
  (if (e = 0) then print ("the world is saved\n")
   else print (Int.toString(final) ^ "\n"));
  (if (e = ~2 ) then completeMap (cL,final)
  else true);
  printMap (doomsMap,0,0)
end

