
package proiectpoo;

import java.util.ArrayList;

public class MusicDepartment extends Department{
    public MusicDepartment(String name, Integer ID, ArrayList<Item> produse, ArrayList<Customer> cl, ArrayList<Customer> obs ) {
          super(name, ID, produse, cl, obs);
    }

    @Override
    void accept(ShoppingCart sp) {
        sp.visit(this);
    }
    
}
