
package proiectpoo;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.ListIterator;

class ShoppingCart extends ItemList implements Visitor {
    private Double budget;

    
    public Double getBuget() {
        return this.budget;
    }
    
    public void setBudget(Double budget) {
        this.budget = budget;
    }
    
    public ShoppingCart(Double budget){
        this.budget = budget;
    }


    @Override
    public void visit(BookDepartment bookDepartment) {
        ItemIterator it = new ItemIterator();
        while (it.hasNext()) {
            Item item = it.next();
            ArrayList<Item> itList = bookDepartment.getProduse();
            boolean ret = itList.contains(item);
            ListIterator it2 = itList.listIterator();
            while (it2.hasNext()) {
                if (item.equals(it2.next())) {
                    Double newPrice = item.getprice() - 0.1*item.getprice();
                    this.setBudget(this.getBuget() + 0.1*item.getprice());
                    item.setprice(newPrice);   
                }
            }
        }
        
    }

    @Override
    public void visit(MusicDepartment musicDepartment) {
        ItemIterator it = new ItemIterator();
        Double totalPrice = 0.;
        while (it.hasNext()) {
            Item item = it.getCurrent();
            ArrayList<Item> itList = musicDepartment.getProduse();
            boolean ret = itList.contains(item);
            if (ret == true) {
                totalPrice += it.getCurrent().getprice();
            }
            it.next();
        }
        this.setBudget(this.getBuget() + 0.1*totalPrice);
    }

    @Override
    public void visit(SoftwareDepartment softwareDepartment) {
        Double totalPrice = this.getTotalPrice();
        ArrayList<Item> itList = softwareDepartment.getProduse();
        ListIterator<Item> it = itList.listIterator();
        int ok = 0;
        while (it.hasNext()) {
            if (totalPrice + it.next().getprice() <= this.getBuget()) {
                ok = 1;
            }
        }
        if (ok != 1) {
            ItemIterator it2 = new ItemIterator();
            while (it2.hasNext()) {
               Item item = it2.next();
                boolean ret = itList.contains(item);
                if (ret == true) {
                    Double newPrice = item.getprice() - 0.2*item.getprice();
                    this.setBudget(this.getBuget() + 0.2*item.getprice());
                    item.setprice(newPrice);
                }
            }
        }
    }

    @Override
    public void visit(VideoDepartment videoDepartment) {
        Double bigest_price  = 0.;
        ArrayList<Item> itList = videoDepartment.getProduse();
        ListIterator<Item> it = itList.listIterator();
        while(it.hasNext()){
            Item item = it.next();
            if(bigest_price < item.getprice()){
                bigest_price = item.getprice();
            }
        }
        Double totalPrice = 0.;
        ItemIterator it2 = new ItemIterator();
        while (it2.hasNext()) {
            Item item = it2.next();
            boolean ret = itList.contains(item);
            if (ret == true) {
                totalPrice += item.getprice();
            }
        }
        if(bigest_price < totalPrice){
            it2 = new ItemIterator();
            while (it2.hasNext()) {
                Item item = it2.next();
                boolean ret = itList.contains(item);
                if (ret == true) {
                    Double price = item.getprice() - 0.15*item.getprice();
                    item.setprice(price);
                    this.setBudget(this.getBuget() + 0.15*item.getprice());
                }
            }
        }
        Double newBudget = this.getBuget() + totalPrice*0.05;
        this.setBudget(newBudget);
    }

    public boolean add(Item element) {
        if (this.getBuget() >= element.getprice() ) {
            this.setBudget(this.getBuget() - element.getprice());
             ItemIterator it = new ItemIterator();
             if (super.getn() == 0) {
                it.add(element);
                return true;
            }
            while (it.hasNext()) {
                Item item = it.getCurrent();
                if ((this.compare((Object) item, (Object) element) > 0) || this.compare((Object) item, (Object) element) == 0) {             
                    it.add(element);
                    return true;
                }   
                if (this.compare((Object) item, (Object) element) < 0) {
                    if(it.hasNext() == false ){
                        it.addLast(element);
                        return true;
                    }
               } 
                it.next(); 
                if(it.hasNext() == false ){
                        it.add(element);
                        return true;
                    }
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
                this.setBudget(this.getBuget() + item.getprice());
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
                this.setBudget(this.getBuget() + item.getprice());
                it.remove(item);
                
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
        int ret = super.PriceComparator.compare(t,t1);
        if(ret == 0){
            return super.NameComparator.compare(t, t1);
        } 
        return ret;
    }




}