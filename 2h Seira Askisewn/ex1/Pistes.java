import java.io.*;
import java.util.*;
import java.lang.*;


class Pista implements Comparable<Pista>{

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


    @Override
    public int compareTo(Pista p){

        int tN = p.getNumberOfNeeded();
        int tE = p.getNumberOfEarnings();
        long tS = p.getStars();
        int ret = 0;

        if (tN > this.getNumberOfNeeded()) ret = -1;
        else if (tN < this.getNumberOfNeeded()) ret = 1;
        else ret = 0;

        if (ret == 0) {
            if (tE > this.getNumberOfEarnings()) ret = 1;
            else if (tE < this.getNumberOfEarnings()) ret = -1;
            else ret = 0;
        }

        if (ret == 0) {
            if (tS > this.getStars()) ret = 1;
            else if (tS < this.getStars()) ret = -1;
            else ret = 0;
        }

        return ret;
    }


}

class Player {

    Pista currPista;
    HashMap<Integer,Integer> keysOwn;
    long totalStars;
    int numberOwn;

    public Player(Pista currPista, HashMap<Integer,Integer> keysOwn, long totalStars, int numberOwn){
        this.currPista = currPista;
        this.keysOwn = keysOwn;
        this.totalStars = totalStars;
        this.numberOwn = numberOwn;
    }

    public long getTotalStars(){
        return totalStars;
    }

    public Pista getCurrPista(){
        return currPista;
    }

    public HashMap<Integer,Integer> getKeysOwn(){
        return keysOwn;
    }
/*
    public Pista giveMeNextPista(ArrayList<Pista> availablePistes){

        for (Pista it : restPistes) {
            ArrayList<Integer> itNeeded = it.getNeeded();
            ArrayList<Integer> common = new ArrayList<Integer>(itNeeded);
            common.retainAll(this.getNeeded());
            System.out.println("The common collection is : " + common);
        }

        return it;

    }
*/
}

public class Pistes {

    public static void printHashMap(HashMap<Integer,Integer> map){


        if (map.isEmpty()) System.out.print("Map is Empty ");
        for (Map.Entry<Integer,Integer> entry : map.entrySet()){
            int key = entry.getKey();
            int value = entry.getValue();
            System.out.print("Key = " + key + " Value =  " + value + " " );
        }
    }
    public static void printArrayList(ArrayList<Integer> l){
        System.out.println("Tha tupwsw ena arraylist me kleidia");

        for (int it : l){
            System.out.print(it + "  " );
        }

        System.out.print("\n");
    }

    public static ArrayList<Pista> giveMeAllPistesAvailable(ArrayList<Pista> l, int keyNumber){

        ArrayList<Pista> ret = new ArrayList<Pista>();
        for (Pista p : l){
            if (p.getNumberOfNeeded() <= keyNumber) {
                ret.add(p);
            }
        }

        return ret;
    }

    public static void main (String[] args){
        try{

            BufferedReader reader = new BufferedReader(new FileReader(args[0]));
            String line = reader.readLine();
            int N = Integer.parseInt(line);
            int counter = 0;
            ArrayList<Pista> allPistes = new ArrayList<Pista>();

            System.out.println(N);
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

            Collections.sort(allPistes);
            for (Pista p : allPistes) {
                System.out.print("Id = " + p.getID());
                System.out.print(" sunolika thelw " + p.getNumberOfNeeded() + " ta opoia einai ");
                printHashMap(p.getNeeded());
                System.out.print(" kai sou dinw  " + p.getNumberOfEarnings() + " ta opoia einai " );
                printHashMap(p.getEarnings());
                System.out.println(" stars " + p.getStars());
            }

        //    Collections.sort(allPistes);

/*
            Pista start = allPistes.get(0);
            allPistes.remove(0);
            ArrayList<Integer> startKeys = start.getEarnings();
            long startStars = start.getStars();

            Player myPlayer = new Player(start, startKeys, startStars);

            System.out.println("Eimai o player kai ksekinaw apo thn Pista " + start.getID() + " kai molis kerdisa " + startKeys.size() + " kai sunolika asteria exw " + startStars);

            printArrayList(startKeys);

            ArrayList<Pista> tmpAvailable = allPistes;
            while( ! myPlayer.getKeysOwn().isEmpty() ) {
                tmpAvailable = giveMeAllPistesAvailable(tmpAvailable, myPlayer.getKeysOwn().size());
                Collections.sort(tmpAvailable);
            }
*/
        }
        catch(IOException e){
            e.printStackTrace();
        }
    }

}
