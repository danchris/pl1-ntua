import java.io.*;
import java.util.*;
import java.lang.*;


class Pista{

    int id;
    HashMap<Integer,Integer> needed;
    HashMap<Integer,Integer> earnings;
    long stars;
    int numberNeeded;
    int numberEarnings;

    public Pista(int id, HashMap<Integer,Integer> needed, HashMap<Integer,Integer> earnings, long stars, int numberNeeded, int numberEarnings){
        this.id = id;
        this.needed = needed;
        this.earnings = earnings;
        this.stars = stars;
        this.numberNeeded = numberNeeded;
        this.numberEarnings = numberEarnings;
    }

    public int getID(){
        return id;
    }

    public HashMap<Integer,Integer> getNeeded(){
        return needed;
    }

    public HashMap<Integer,Integer> getEarnings(){
        return earnings;
    }

    public int getNumberOfNeeded(){
        return numberNeeded;
    }

    public int getNumberOfEarnings(){
        return numberEarnings;
    }

    public long getStars(){
        return stars;
    }

}

class State {

    Pista currPista;
    long currStars;
    HashMap<Integer,Integer> keysOwn;
    ArrayList<Pista> pistes;
    int numberOwn;

    public State(Pista currPista, HashMap<Integer,Integer> keysOwn, ArrayList<Pista> pistes,long currStars, int numberOwn){
        this.currPista = currPista;
        this.keysOwn = keysOwn;
        this.currStars = currStars;
        this.pistes = pistes;
        this.numberOwn = numberOwn;
    }

    public long getCurrStars(){
        return currStars;
    }

    public Pista getCurrPista(){
        return currPista;
    }

    public HashMap<Integer,Integer> getKeysOwn(){
        return keysOwn;
    }

    public ArrayList<Pista> getPistes(){
        return pistes;
    }

    public int getNumberOwn(){
        return numberOwn;
    }

    public void setPista(Pista newPista) {
        this.currPista = newPista;
    }

    public void setKeysOwn(HashMap<Integer,Integer> newKeys){
        this.keysOwn = newKeys;
    }

    public void setCurrStars(long newStars){
        this.currStars = newStars;
    }

    public void setNumberOwn(int newNumber){
        this.numberOwn = newNumber;
    }

    public void setPistes(ArrayList<Pista> pistes){
        this.pistes = pistes;
    }

}

public class Pistes {

    public static ArrayList<Pista> getNewPistes(State curr){

        ArrayList<Pista> l = new ArrayList<Pista>(curr.pistes);
        ArrayList<Pista> newL = new ArrayList<Pista>();

        if (l.isEmpty()) return newL;


        for (Pista p : l){
            if (p.getNumberOfNeeded() <= curr.numberOwn) {
                HashMap<Integer,Integer> pistaNeeds = p.getNeeded();
                HashMap<Integer,Integer> myKeys = curr.keysOwn;

                int flag = 0;

                for (Map.Entry<Integer,Integer> entry : pistaNeeds.entrySet()){
                    int key = entry.getKey();
                    int value = entry.getValue();

                    if (myKeys.containsKey(key) && value <= myKeys.get(key)) flag += value;
                }
                if (flag == p.getNumberOfNeeded()) newL.add(p);
            }
        }

        return newL;
    }

    public static State playPista(State curr, Pista toPlay){

        HashMap<Integer,Integer> pistaNeeds = toPlay.getNeeded();
        HashMap<Integer,Integer> pistaEarnings = toPlay.getEarnings();
        HashMap<Integer,Integer> myKeys = new HashMap<Integer,Integer>(curr.getKeysOwn());
        long pistaStars = toPlay.getStars();
        int numberOfNeeded = toPlay.getNumberOfNeeded();


        if(myKeys.isEmpty()) myKeys = new HashMap<Integer,Integer>();
        for (Map.Entry<Integer,Integer> entry : pistaNeeds.entrySet()){

            int key = entry.getKey();
            int value = entry.getValue();
            int newV = myKeys.get(key);

            if (newV == value) {
                myKeys.remove(key);
            }
            else myKeys.put(key, Math.abs(newV-value));
        }

        for (Map.Entry<Integer,Integer> entry : pistaEarnings.entrySet()){

            int key = entry.getKey();
            int value = entry.getValue();

            if (myKeys.containsKey(key)){
                int newV = myKeys.put(key, myKeys.get(key) + value);
            }
            else myKeys.put(key,value);
        }

        ArrayList<Pista> tmp = new ArrayList<Pista>(curr.getPistes());
        tmp.remove(toPlay);
        long newStars = curr.getCurrStars() + toPlay.getStars();
        State ret = new State(toPlay,myKeys,tmp, newStars, myKeys.size());

        return ret;


    }


    public static void main (String[] args){
        try{

            BufferedReader reader = new BufferedReader(new FileReader(args[0]));
            String line = reader.readLine();
            int N = Integer.parseInt(line);
            int counter = 0;
            ArrayList<Pista> allPistes = new ArrayList<Pista>();

            line = reader.readLine();
            while(line != null && !(line.matches("\\s*"))) {

                String[] splitted = line.split(" ");
                int curN = splitted.length, kneeded = Integer.parseInt(splitted[0]), kearnings = Integer.parseInt(splitted[1]);
                long curStars = Long.parseLong(splitted[2]);
                HashMap<Integer,Integer> curNeeded = new HashMap<Integer,Integer>();
                HashMap<Integer,Integer> curEarnings = new HashMap<Integer,Integer>();
                int j = 3;

                for(int i = 0; i < kneeded; i++){
                    int tmp = Integer.parseInt(splitted[j]);
                    if(curNeeded.containsKey(tmp)) {
                        curNeeded.put(tmp, curNeeded.get(tmp) + 1);
                    }
                    else curNeeded.put(tmp,1);
                    j++;
                }


                for(int i = 0; i < kearnings; i++){
                    int tmp = Integer.parseInt(splitted[j]);
                    if(curEarnings.containsKey(tmp)) {
                        curEarnings.put(tmp, curEarnings.get(tmp) + 1);
                    }
                    else curEarnings.put(tmp,1);
                    j++;
                }

                Pista newPista = new Pista(counter++,curNeeded,curEarnings,curStars, kneeded, kearnings);
                allPistes.add(newPista);
                line = reader.readLine();
            }

            ArrayList<State> open = new ArrayList<State>();
            ArrayList<Pista> l = new ArrayList<Pista>();
            Pista root = allPistes.remove(0);
            State curr = new State(root,root.getEarnings(),allPistes,root.getStars(),root.getEarnings().size());
            open.add(curr);
            long max = -1;

            while(!open.isEmpty()){
                curr = open.remove(0);
                l = getNewPistes(curr);
                for (Pista it : l){
                    State newState = playPista(curr,it);
                    open.add(0,newState);
                    if (newState.getCurrStars() > max) max = newState.getCurrStars();
                }
            }

            System.out.println(max);


        }
        catch(IOException e){
            e.printStackTrace();
        }
    }

}
