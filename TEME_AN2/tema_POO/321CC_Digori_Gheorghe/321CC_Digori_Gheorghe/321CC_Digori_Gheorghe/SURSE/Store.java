
package proiectpoo;


import java.util.ArrayList;
import java.util.ListIterator;


public class Store {
    private static Store store = null;
    String name;
    ArrayList<Customer> clienti = new ArrayList<Customer>();;
    ArrayList<Department> dep =  new ArrayList<Department>();
   
    public Store(String name, ArrayList<Customer> clienti, ArrayList<Department> dep){
        this.name = name;
        this.dep = dep;
        this.clienti = clienti;
    }

    public static Store getInstance() {
        if(store == null) {
            store = new Store();
        }
        return store;
    }

    private Store() {
    }

    

    void enter(Customer c){
    clienti.add(c);
        
    }
    void exit(Customer c){
    clienti.remove(c);
    }
    ShoppingCart getShopingCart(Double p){
        return new ShoppingCart(p) ;
        
    }
    ArrayList<Customer> getCustomers(){
        return clienti;
        
    }
    ArrayList<Department> getDepartments(){
        return dep;
        
    }
    void addDepartment(Department d){
    dep.add(d);
    }
    Department getDepartment(Integer x){
        ListIterator it = dep.listIterator() ;
        while (it.hasNext()) {
            Department dep2 = (Department) it.next();
            if (dep2.getId() == x) {
                return dep2;
            }
        }
        return null;
    }
            
}
