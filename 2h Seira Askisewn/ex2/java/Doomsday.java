import java.io.*;
import java.util.*;
import java.lang.*;

class Node{

    int x;
    int y;
    char c;
    int t;

    public Node (int x, int y, char c, int t){
        this.x = x;
        this.y = y;
        this.c = c;
        this.t = t;
    }

    public int getX(){
        return x;
    }

    public int getY(){
        return y;
    }

    public char getC(){
        return c;
    }

    public int getT(){
        return t;
    }

    public void setT(int t){
        this.t = t;
    }

    public int goRight(char[][] map){
        if(map[this.x][this.y+1] == '.'){
            map[this.x][this.y+1] = this.c;
            return 0;
        }
        else if(map[this.x][this.y+1] != 'X' && map[this.x][this.y+1] != this.c){
            map[this.x][this.y+1] = '*';
            return 1;
        }
        return -1;
    }

    public int goLeft(char[][] map){
        if(map[this.x][this.y-1] == '.'){
            map[this.x][this.y-1] = this.c;
            return 0;
        }
        else if(map[this.x][this.y-1] != 'X' && map[this.x][this.y-1] != this.c){
            map[this.x][this.y-1] = '*';
            return 1;
        }
        return -1;
    }

    public int goUp(char[][] map){
        if(map[this.x-1][this.y] == '.'){
            map[this.x-1][this.y] = this.c;
            return 0;
        }
        else if(map[this.x-1][this.y] != 'X' && map[this.x-1][this.y] != this.c){
            map[this.x-1][this.y] = '*';
            return 1;
        }
        return -1;
    }

    public int goDown(char[][] map){
        if(map[this.x+1][this.y] == '.'){
            map[this.x+1][this.y] = this.c;
            return 0;
        }
        else if(map[this.x+1][this.y] != 'X' && map[this.x+1][this.y] != this.c){
            map[this.x+1][this.y] = '*';
            return 1;
        }
        return -1;
    }

}

class Solver{

    ArrayList<Node> myList;
    char[][] map;
    int N;
    int M;
    int t;

    public Solver (char[][] map, ArrayList<Node> myList, int N, int M){
        this.map = map;
        this.myList = myList;
        this.N = N;
        this.M = M;
        this.t = 0;
    }

    public boolean solution(){
        int prevT = 0, end = 0;
        Node curr = null;

        while( !this.myList.isEmpty()){
            curr = this.myList.remove(0);
            if (end == 1 && curr.getT() > prevT) break;

            int right = curr.goRight(map), left = curr.goLeft(map), up = curr.goUp(map), down = curr.goDown(map);

            if (right == 0) {
                Node newNode = new Node(curr.getX(),curr.getY()+1,curr.getC(),curr.getT()+1);
                this.myList.add(newNode);
            }
            else if (right == 1) {
                end = 1;
                t = curr.getT() + 1;
            }
            if (left == 0) {
                Node newNode = new Node(curr.getX(),curr.getY()-1,curr.getC(),curr.getT()+1);
                this.myList.add(newNode);
            }
            else if (left == 1) {
                end = 1;
                t = curr.getT() + 1;
            }

            if (up == 0) {
                Node newNode = new Node(curr.getX()-1,curr.getY(),curr.getC(),curr.getT()+1);
                this.myList.add(newNode);
            }
            else if (up == 1) {
                end = 1;
                t = curr.getT() + 1;
            }

            if (down == 0) {
                Node newNode = new Node(curr.getX()+1,curr.getY(),curr.getC(),curr.getT()+1);
                this.myList.add(newNode);
            }
            else if (down == 1) {
                end = 1;
                t = curr.getT() + 1;
            }

            prevT = curr.getT();
        }

        if (end == 0) return false;
        return true;
    }

    public void printSolution(boolean f){

        if (!f) System.out.println("the world is saved");
        else System.out.println(t);
        for (int i = 1; i < N; i++){
            for (int j = 1; j < M; j++){
                System.out.print(map[i][j]);
            }
            System.out.print('\n');
        }
    }
}
public class Doomsday{


    public static void main (String[] args){
        try {

            int N = 1, M = 1, j = 1;
            BufferedReader reader = new BufferedReader(new FileReader(args[0]));
            String line = reader.readLine();
            ArrayList<Node> myList = new ArrayList<Node>();
            M = line.length()+1;
            char[][] map = new char [1002][1002];

            while( line != null && !(line.matches("\\s*"))){
                for (j = 0; j<line.length(); j++){
                    map[N][j+1] = line.charAt(j);
                    if (map[N][j+1] == '+' || map[N][j+1] == '-'){
                        Node newNode = new Node(N,j+1,map[N][j+1],0);
                        myList.add(newNode);
                    }
                }
                line = reader.readLine();
                N++;
            }

            reader.close();

            for (int i=0; i<=N; i++){
                for(j=0; j<=M; j++){
                    if(i==0 || i==N || j==0 || j==M){
                        map[i][j] = 'X';
                    }
                }
            }

            Solver solver = new Solver(map,myList,N,M);

            solver.printSolution(solver.solution());

        }
        catch (IOException e){
            e.printStackTrace();
        }
    }
}
