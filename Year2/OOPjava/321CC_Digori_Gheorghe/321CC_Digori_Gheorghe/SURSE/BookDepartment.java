package proiectpoo;


import proiectpoo.*;
import proiectpoo.Customer;
import java.util.ArrayList;

public class BookDepartment extends Department {
    

    public BookDepartment(String name, Integer ID, ArrayList<Item> produse, ArrayList<Customer> cl, ArrayList<Customer> obs ) {
          super(name, ID, produse, cl, obs);
    }
    @Override
    void accept(ShoppingCart sp) {
        sp.visit(this);
        }
    
}
