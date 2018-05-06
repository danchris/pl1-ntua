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

    public int getNumberOwn(){
        return numberOwn;
    }

    public void setPista(Pista newPista) {
        this.currPista = newPista;
    }

    public void setKeysOwn(HashMap<Integer,Integer> newKeys){
        this.keysOwn = newKeys;
    }

    public void setTotalStars(long newStars){
        this.totalStars = newStars;
    }

    public void setNumberOwn(int newNumber){
        this.numberOwn = newNumber;
    }

    public Pista giveMeNextPista(ArrayList<Pista> availablePistes){

        Pista ret = null;

      //  Collections.sort(availablePistes);
        for (Pista it : availablePistes) {

            HashMap<Integer,Integer> myK = this.keysOwn;
            HashMap<Integer,Integer> tmp = it.getNeeded();

            int flag = 0;
            for (Map.Entry<Integer,Integer> entry : tmp.entrySet()){

                int key = entry.getKey();
                int value = entry.getValue();

                if (myK.containsKey(key)) {
                    int tmpValue = myK.get(key);

                    if (value <= tmpValue) {
                        flag += value;
                    }
                }
                else break;
            }


            if (flag == it.getNumberOfNeeded()) {
                ret = it;
                break;
            }

        }

        return ret;

    }

    public void playPista (Pista toPlay){

        HashMap<Integer,Integer> pK = toPlay.getNeeded();
        HashMap<Integer,Integer> pE = toPlay.getEarnings();
        HashMap<Integer,Integer> myK = this.keysOwn;
        long s = toPlay.getStars();
        int n = toPlay.getNumberOfNeeded();


        for (Map.Entry<Integer,Integer> entry : pK.entrySet()){

            int key = entry.getKey();
            int value = entry.getValue();
            int newV = myK.get(key);

            if (newV == value) {
                myK.remove(key);
            }
            else myK.put(key, Math.abs(newV-value));
        }

        for (Map.Entry<Integer,Integer> entry : pE.entrySet()){

            int key = entry.getKey();
            int value = entry.getValue();

            if (myK.containsKey(key)){
                int newV = myK.put(key, myK.get(key) + value);
            }
            else myK.put(key,value);
        }

        this.totalStars += s;
        this.numberOwn = Math.abs(numberOwn - n);
        this.currPista = toPlay;
        this.keysOwn = myK;
        return ;

    }

}

public class Pistes {


    public static void printAllPistes(ArrayList<Pista> allPistes) {

        System.out.println("--------Time to print all pistes ------------");
        for (Pista p : allPistes) {
            System.out.print("Id = " + p.getID());
            System.out.print(" sunolika thelw " + p.getNumberOfNeeded() + " ta opoia einai ");
            printHashMap(p.getNeeded());
            System.out.print(" kai sou dinw  " + p.getNumberOfEarnings() + " ta opoia einai " );
            printHashMap(p.getEarnings());
            System.out.println(" stars " + p.getStars());
        }

        System.out.println("--------End to print all pistes ------------");
    }
    public static void printHashMap(HashMap<Integer,Integer> map){


        if (map.isEmpty()) {
            System.out.print("Map is Empty ");
            return ;
        }
        for (Map.Entry<Integer,Integer> entry : map.entrySet()){
            int key = entry.getKey();
            int value = entry.getValue();
            System.out.print("Key = " + key + " Value =  " + value + " " );
        }
        System.out.print(" ");
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

        if (l.isEmpty()) return null;

        Collections.sort(l);

        for (Pista p : l){
            if (p.getNumberOfNeeded() <= keyNumber) {
                ret.add(p);
            }
            else break;
        }

        if (ret.isEmpty()) return null;

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

            //Collections.sort(allPistes);                    //Gia na exw sthn arxh thn 0


            Pista curr = allPistes.get(0);                  //Arxh
            allPistes.remove(0);                            //Afairw thn arxh

            Player myPlayer = new Player(curr, curr.getEarnings(), curr.getStars(),curr.getNumberOfEarnings());

            ArrayList<Pista> tmpAvailable = null;

            while( ( ! myPlayer.getKeysOwn().isEmpty()) && (! allPistes.isEmpty())) {

                tmpAvailable = giveMeAllPistesAvailable(allPistes, myPlayer.getKeysOwn().size());

                if (tmpAvailable == null) break;            // An dn mporw na paiksw se kamia pista logo oti dn exw ariithmo kleidiwn
                curr = myPlayer.giveMeNextPista(tmpAvailable);
                if (curr == null) break;                    // An dn exw ton swsto sundiasmo kleidiwn

                myPlayer.playPista(curr);                   //paizw thn pista

                allPistes.remove(curr);                     //Afairw apo tin lista authn pou molis epaiksa
            }

            System.out.println(myPlayer.getTotalStars());

        }
        catch(IOException e){
            e.printStackTrace();
        }
    }

}
