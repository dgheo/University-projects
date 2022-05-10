
package proiectpoo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

public class WishList extends ItemList {
    private Strategy strategy;
    ArrayList<Item> id_element = new ArrayList<Item>();//string cu itemi adaugati in ordinea inserarii (nesortat) folosit la StrategyC
    public WishList() {
    }
    
    public boolean add(Item element) {
        ItemIterator it = new ItemIterator();
        if (super.getn() == 0) {
            it.add(element);
            id_element.add(element);
            return true;
        }
        while (it.hasNext()) {
            Item item = it.getCurrent();
            if ((this.compare((Object) item, (Object) element) > 0) || this.compare((Object) item, (Object) element) == 0) {             
                it.add(element);
                id_element.add(element);
                return true;
            }  
            if (this.compare((Object) item, (Object) element) < 0) {
                if(it.hasNext() == false ){
                    it.addLast(element); 
                    id_element.add(element);
                    return true;
                }
            } 
            it.next(); 
            if(it.hasNext() == false ){
                it.add(element);
                id_element.add(element);
                    return true;
                }
            }
        return false;
    }

    @Override
    public boolean addAll(Collection<? extends Item> c) {
        Iterator<? extends Item> it = c.iterator();
        while (it.hasNext()) {
            boolean ret = this.add(it.next());
            if (ret == false)
                return false;
        }
        return true;
    }

    @Override
    public Item remove(int index) {
        if (super.getn() == 0) {
            return null;
        }
        ItemIterator it = new ItemIterator();
        while (it.hasNext()) {
            int pos = it.nextIndex();
            if (pos == index) {
                Item item = it.getCurrent();
                it.remove();
                return item;
            }
            it.next();
        }
        return null;
    }

    @Override
    public boolean remove(Item item) {
        if (super.getn() == 0) {
            return false;
        }
        ItemIterator it = new ItemIterator();
        Item item4 = it.getCurrent();
        while (it.hasNext()) {
            Item item2 = it.getCurrent();
            if (item2.getID().equals(item.getID())) {
                Double TotalPrice = this.getTotalPrice() + item.getprice();
                it.remove(item);
                id_element.remove(item);
                return true;
            }
            it.next();
        }
        return false;
    }


    @Override
    public boolean removeAll(Collection<? extends Item> c) {
        Iterator<? extends Item> it = c.iterator();
        while (it.hasNext()) {
            boolean ret = this.remove(it.next());
            if (ret == false)
                return false;
        }
        return true;
    }

    @Override
    public Double getTotalPrice() {
        ItemIterator it = new ItemIterator();
        double totalPrice = 0;
        while(it.hasNext()) {
            totalPrice += it.next().getprice();
        }
        return totalPrice;
    }

    public int compare(Object o, Object o1) {
        Item t = (Item) o;
        Item t1 = (Item) o1;
        int ret = super.NameComparator.compare(t, t1);
        return ret;
    }

    public void executeStrategy(){
        
       strategy.execute(this);
    
    }
}