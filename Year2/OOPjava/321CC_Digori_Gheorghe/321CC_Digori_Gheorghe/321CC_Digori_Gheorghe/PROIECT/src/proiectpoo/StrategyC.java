/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package proiectpoo;

import java.util.ArrayList;
import java.util.ListIterator;

/**
 *
 * @author gelud
 */
public class StrategyC implements Strategy {
Customer name;
BookDepartment book;
MusicDepartment music;
VideoDepartment video;
SoftwareDepartment soft;

    
    public StrategyC(Customer name,BookDepartment book, MusicDepartment music, SoftwareDepartment soft, VideoDepartment video){
        this.name = name;
        this.book = book;
        this.music = music;
        this.video = video;
        this.soft = soft;
    }


    @Override
    public void execute(WishList wish){
        ListIterator<Item> it = wish.listIterator();
        ListIterator<Item> it2 = wish.listIterator();
        Item last = wish.id_element.get(wish.id_element.size() - 1);
        Double buget = name.getShoppingCart().getBuget();
        if(buget.compareTo(last.getprice()) > 0){
            name.getShoppingCart().add(last);
            name.getWishlist().remove(last);
            name.getShoppingCart().setBudget(buget-last.getprice());
            
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
                if(i1.getID().compareTo(last.getID()) == 0){
                    ArrayList<Customer> obs_book = book.getObservers();
                    obs_book.remove(name);
                                   
                }
            }
            while(itm.hasNext()){ 
                Item i1 = (Item)itm.next();
                if(i1.getID().compareTo(last.getID()) == 0){
                    ArrayList<Customer> obs_music = music.getObservers();
                    obs_music.remove(name);
                                   
                }
            }
            while(its.hasNext()){ 
                Item i1 = (Item)its.next();
                if(i1.getID().compareTo(last.getID()) == 0){
                    ArrayList<Customer> obs_soft = soft.getObservers();
                    obs_soft.remove(name);
                                   
                }
            }
            while(itc.hasNext()){ 
                Item i1 = (Item)itc.next();
                if(i1.getID().compareTo(last.getID()) == 0){
                    ArrayList<Customer> obs_video = video.getObservers();
                    obs_video.remove(name);
                                   
                }
            }
        }
    }
}