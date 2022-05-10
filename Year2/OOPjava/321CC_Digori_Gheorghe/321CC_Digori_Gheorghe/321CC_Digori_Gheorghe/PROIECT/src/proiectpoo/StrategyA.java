/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package proiectpoo;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.ListIterator;

/**
 *
 * @author gelud
 */
public class StrategyA implements Strategy{
    Customer name;
BookDepartment book;
MusicDepartment music;
VideoDepartment video;
SoftwareDepartment soft;

    
    public StrategyA(Customer name,BookDepartment book, MusicDepartment music, SoftwareDepartment soft, VideoDepartment video){
        this.name = name;
        this.book = book;
        this.music = music;
        this.video = video;
        this.soft = soft;
    }

    @Override
    public void execute(WishList wish) {
        ListIterator<Item> it = wish.listIterator();
        Item produs_ieftin = it.next();
        Item x = null;
        int minIndex = it.previousIndex();
        while(it.hasNext()){
            Item item= it.next();
            if(item.getprice().compareTo(produs_ieftin.getprice()) > 0){
                item = produs_ieftin;
                minIndex = it.previousIndex();
            }
            else
                x = item;
        }
        Double buget = name.getShoppingCart().getBuget();
        if(buget.compareTo(x.getprice()) > 0){
            name.getShoppingCart().add(x);
            name.getWishlist().remove(x);
            name.getShoppingCart().setBudget(buget-x.getprice());
            ArrayList<Item> b = book.getItems();
            ArrayList<Item> m = music.getItems();
            ArrayList<Item> v = video.getItems();
            ArrayList<Item> s = soft.getItems();
            ListIterator<Item> itb = b.listIterator();
            ListIterator<Item> itm = m.listIterator();
            ListIterator<Item> itc = v.listIterator();
            ListIterator<Item> its = s.listIterator();
            while(itb.hasNext()){ 
                Item i1 = (Item)itb.next();
                if(i1.getID().compareTo(x.getID()) == 0){
                    ArrayList<Customer> obs_book = book.getObservers();
                    obs_book.remove(name);
                                   
                }
            }
            while(itm.hasNext()){ 
                Item i1 = (Item)itm.next();
                if(i1.getID().compareTo(x.getID()) == 0){
                    ArrayList<Customer> obs_music = music.getObservers();
                    obs_music.remove(name);
                                   
                }
            }
            while(its.hasNext()){ 
                Item i1 = (Item)its.next();
                if(i1.getID().compareTo(x.getID()) == 0){
                    ArrayList<Customer> obs_soft = soft.getObservers();
                    obs_soft.remove(name);
                                   
                }
            }
            while(itc.hasNext()){ 
                Item i1 = (Item)itc.next();
                if(i1.getID().compareTo(x.getID()) == 0){
                    ArrayList<Customer> obs_video = video.getObservers();
                    obs_video.remove(name);
                                   
                }
            }
        }
    }
     
}
