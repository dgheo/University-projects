
package proiectpoo;

import java.util.ArrayList;

public abstract class Department implements Subject {
    private String name;
    private ArrayList<Item> produse = new ArrayList<Item>();
    private Integer ID;
    private ArrayList<Customer> cl = new ArrayList<Customer>();
    private ArrayList<Customer> obs = new ArrayList<Customer>();
    
    public ArrayList<Item> getProduse() {
        return this.produse;
    }

    public Department(String name, Integer ID, ArrayList<Item> produse, ArrayList<Customer> cl, ArrayList<Customer> obs ) {
        this.ID = ID;
        this.name = name;
        this.produse = produse;
        this.cl = cl;
        this.obs = obs;
    }
    
    void enter(Customer c){
        this.cl.add(c);
    }
    void exit(Customer c){
        this.cl.remove(c);
    }
    
    ArrayList<Customer> getCustomers(){
      return this.cl;  
    }
    
    int getId() {
        return this.ID;
    }
    
    void addItem(Item i){
        this.produse.add(i);
    }
    
    ArrayList<Item> getItems(){
        return this.produse;
    }
    
    @Override
    public void addObserver(Customer c){
        obs.add(c);
        
    }
    
    @Override
    public void removeObserver(Customer c){
        this.obs.remove(c);
    }
    ArrayList<Customer> getObservers(){
        return this.obs;
    }
    
    @Override
    public void notifyAllObservers(Notification n){
        for (Observer o : obs){
            o.update(n);
        }
    }
    
    void accept(ShoppingCart sp){
        
    }
        
    
        
    
}
