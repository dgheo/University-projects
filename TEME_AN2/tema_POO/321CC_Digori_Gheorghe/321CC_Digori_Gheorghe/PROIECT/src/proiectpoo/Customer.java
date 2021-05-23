
package proiectpoo;

import java.util.List;


class Customer implements Observer{
    private String nume;
    ShoppingCart shp; 
    WishList wsh;
    private List notify;
    private String strategie;

    public Customer(String nume, ShoppingCart shp, WishList wsh, List notify, String strategie){
        this.nume = nume;
        this.shp = shp;
        this.wsh = wsh;
        this.notify = notify;
        this.strategie = strategie;
    }
    public Customer(String nume){
        this.nume = nume;
    }

    public String getname(){
        return this.nume;   
    }
    public void setname(String name){
        this.nume = nume;
    }
    public String toStringCustomer(){
        return this.nume;
    }

    public List getcollectionn_otify(){
        return this.notify;
    }
    public void setcollection_notify(List notify){
       this.notify = notify;
    }
    public WishList getWishlist(){
        return this.wsh;
    }
    public ShoppingCart getShoppingCart(){
        return this.shp;
    }
    public String getStrategy(){
        return this.strategie;
    }


    @Override
    public void update(Notification n) {
        notify.add(n);
        switch (n.getNotificationType()) {
            case ADD:
                //System.out.println(n.getNotificationType() + ";" + n.getItemID() + ";" + n.getDepID());
                break;
            case REMOVE:
                //System.out.println(n.getNotificationType() + ";" + n.getItemID() + ";" + n.getDepID());                int ID_item = n.getItemID();
                /*ListIterator it = wsh.listIterator();
                while (it.hasNext()) {
                    Item item = (Item) it.next();
                    int ID = item.getID();
                    if (ID == ID_item) {
                        wsh.remove(item);
                        break;
                    }
                }*/
            case MODIFY:
                //System.out.println(n.getNotificationType() + ";" + n.getItemID() + ";" + n.getDepID());                ID_item = n.getItemID();
                /*it = wsh.listIterator();
                while (it.hasNext()) {
                    Item item = (Item) it.next();
                    int ID = item.getID();
                    if (ID == ID_item) {
                        Double budget = shp.getBudget();
                        if (item.getprice() <= budget) {
                            shp.setBudget(budget - item.getprice());
                            wsh.remove(item);
                            shp.add(item);
                        }
                        break;
                    }
                }*/
        }
    }
    
  
}
