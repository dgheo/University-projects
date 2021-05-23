
package proiectpoo;

import java.util.Collection;
import java.util.Comparator;
import java.util.ListIterator;
import java.util.NoSuchElementException;
import java.util.logging.Level;
import java.util.logging.Logger;

public abstract class ItemList{
    
    private int n;        // number of elements on list
    private Node pre;     // sentinel before first item
    private Node post;
    
    public void setn (int n) {
        this.n = n;
    }
    
    public void setpre (Node pre) {
        this.pre = pre;
    }
    
    public void setpost (Node post) {
        this.post = post;
    }
    
    public int getn () {
        return this.n;
    }

    public Node getpre () {
        return this.pre;
    }
    
    public Node getpost () {
        return this.post;
    }
    
    public  Comparator<Item> NameComparator = new Comparator<Item>() {

        @Override
        public int compare(Item e1, Item e2) {
            return e1.getname().compareTo(e2.getname());
        }
    };
    
    public Comparator<Item> PriceComparator = new Comparator<Item>() {

        @Override
        public int compare(Item e1, Item e2) {
           double delta =  e1.getprice() - e2.getprice();
           if(delta > 0) return 1;
            if(delta < 0) return -1;
            return 0;
        }
    };
    
    
    
    static class Node<T> {
        private Item item;
        private Node next;
        private Node prev;
    }
    
     public ItemList() {
        n = 0;
        pre  = new Node();
        post = new Node();
      //  post.item = new Item("fuflic", 999999, 9999999.);
        pre.next = post;
        post.prev = pre;
       
    }
     
 
    class ItemIterator implements ListIterator<Item>{
        
        private Node current = pre.next;  // the node that is returned by next()
        private Node lastAccessed = null ;
        private int index = 0;

        private ItemIterator(int index) {
            this.index = index;
        }

        ItemIterator() {
        }
        
        
        @Override
        public boolean hasNext() {
            return index < n;
        }

        @Override
        public Item next() {
            try {
                if (!hasNext()) throw new NoSuchElementException();
                }
            catch (NoSuchElementException ex) {
                Logger.getLogger(ItemList.class.getName()).log(Level.SEVERE, null, ex);
                }
            lastAccessed = current;
            Item item = current.item;
            current = current.next;
            index++; 
            return item;
        }
        
        public Node Node_next() {
            try {
                if (!hasNext()) throw new NoSuchElementException();
                }
            catch (NoSuchElementException ex) {
                Logger.getLogger(ItemList.class.getName()).log(Level.SEVERE, null, ex);
                }
            lastAccessed = current;
            Item item = current.item;
            current = current.next;
            index++; 
            return lastAccessed;
        }

        @Override
        public boolean hasPrevious() {
           return index > 0;
        }

        @Override
        public Item previous() {
          if (!hasPrevious()) try {
              throw new NoSuchElementException();
          } catch (NoSuchElementException ex) {
              Logger.getLogger(ItemList.class.getName()).log(Level.SEVERE, null, ex);
          }
            current = current.prev;
            index--;
            lastAccessed = current;
            return current.item;   
        }

        @Override
        public int nextIndex() {
            return index;
        }

        public void remove(Item item) {
             
            Node x = current.prev;
            Node y = current.next;
            
            x.next = y;
            y.prev = x;
            n--;
            if (current == lastAccessed)
                current = y;
            else
                index--;
            lastAccessed = null;
        }

        @Override
        public void set(Item item) {
            if (lastAccessed == null) throw new IllegalStateException();
            lastAccessed.item = item;
        }

        @Override
        public void add(Item item) {
            Node x = current.prev;
            Node y = new Node();
            Node z = current;
            y.item = item;
            x.next = y;
            y.next = z;
            z.prev = y;
            y.prev = x;
            n++;
            index++;
            lastAccessed = null;
        }
        
        public Item getCurrent() {
            return current.item;
        }
        public void setCurrent(Node current2){
            this.current = current2;
        }
        
        public void addLast(Item item) {
            current = post.prev;
            
            Node y = new Node();
            Node z = current;
            y.item = item;
            y.next = null;
            z.next = y;
            y.prev = y;
            n++;
            index++;
            lastAccessed = null;
        }
        
        
        @Override
        public int previousIndex() {
            return index - 1;
        }

        @Override
        public void remove() {
            throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
        }

    }

    public abstract boolean add(Item element);
    
    public abstract boolean addAll(Collection <? extends Item> c);
    
    public Item getItem(int index){
        ItemIterator it = new ItemIterator();
        while (it.hasNext()) {
            if (it.nextIndex() == index)
                return it.next();
        }
        return null;
    }
    public Node<Item> getNode(int index){
        ItemIterator it = new ItemIterator();
        while (it.hasNext()) {
            if (it.nextIndex() == index)
                return it.current;
        }
        return null;
        
    }
    public int indexOf(Item item){
        ItemIterator it = new ItemIterator();
        while (it.hasNext()) {
            Item current_item = it.next();
            if (item.getID() == current_item.getID())
                return it.nextIndex();
        }
        return -1;
        
        
    }
    public int indexOf(Node<Item> node){
        ItemIterator it = new ItemIterator();
        while (it.hasNext()) {
            Node current_node = it.current;
            if (current_node.equals(node) == true)
                return it.nextIndex();
        }
        return -1;
    }
    
    public boolean contains(Node<Item> node){
        ItemIterator it = new ItemIterator();
         while (it.hasNext()) {
            Node current_node = it.current;
            if (current_node.equals(node) == true)
                return true;
         }
        return false;
    }
    
    public boolean contains(Item item){
       ItemIterator it = new ItemIterator();
        while (it.hasNext()) {
            Item current_item = it.next();
            if (item.getID() == current_item.getID())
                return true;
        }
        return false;
               
    }
    
    public abstract Item remove(int index);
    public abstract boolean remove(Item item);
    public abstract boolean removeAll(Collection <? extends Item> collection);
    public boolean isEmpty(){
        return n == 0;
        
    }
    public ListIterator <Item> listIterator(int index){
        return new ItemIterator(index);
       
        
    }
    public ListIterator<Item> listIterator(){
        return new ItemIterator();
        
    }
    public abstract Double getTotalPrice();
        
    
}
