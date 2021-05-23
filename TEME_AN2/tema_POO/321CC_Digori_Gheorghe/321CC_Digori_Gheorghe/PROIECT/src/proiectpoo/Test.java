
package proiectpoo;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;
import java.util.StringTokenizer;


public class Test {
    public static void main(String[] args) throws FileNotFoundException, IOException {
        String line = null;
         //citesc datele din fisierul store si salvez in niste variabile
        BufferedReader br = new BufferedReader(new FileReader("store.txt"));
        line = br.readLine();
        ArrayList<Customer> Customer_list = new ArrayList<>();
        ArrayList<Department> department_list = new ArrayList<>();
        //Creez obiectul de tip Store
        Store store = new Store(line, Customer_list, department_list);
        //Instantiez obiecte de tip departament
        BookDepartment bookdepartment = null;
        MusicDepartment musicdepartment = null;
        SoftwareDepartment softwaredepartment = null;
        VideoDepartment videodepartment = null;
        while ((line = br.readLine()) != null) {
            StringTokenizer st = new StringTokenizer(line, ";");
            String dep_name = st.nextElement().toString();
            int dep_id = Integer.parseInt(st.nextElement().toString());
            int nr_items = Integer.parseInt(br.readLine());
            ArrayList<Item> produse = new ArrayList<Item>();
            
            for (int i = 0; i < nr_items; i++) {
                line = br.readLine();
                st = new StringTokenizer(line, ";");
                String item = st.nextElement().toString();
                Integer item_id = Integer.parseInt(st.nextElement().toString());
                Double item_price = Double.parseDouble(st.nextElement().toString());
                //Creez obiectul de tip Item cu parametrii citizi din fisierul store
                Item produs = new Item(item, item_id, item_price);
                //Adaug produsele in lista de produse a departamentului
                produse.add(produs);
            }
            //Creez vectorii de clienti si observatori din departamente
            ArrayList<Customer> clienti_dep = new ArrayList<Customer>();
            ArrayList<Customer>observatori_dep = new ArrayList<Customer>();
            //Creez obiectele de tip departament
            if (dep_name.compareTo("BookDepartment") == 0) {
                bookdepartment = new BookDepartment(dep_name, dep_id, produse, clienti_dep, observatori_dep );
                store.addDepartment(bookdepartment);
            }
            else if (dep_name.compareTo("MusicDepartment") == 0) {
                musicdepartment = new MusicDepartment(dep_name, dep_id, produse, clienti_dep, observatori_dep );
                store.addDepartment(musicdepartment);
            }
            else if (dep_name.compareTo("SoftwareDepartment") == 0) {
                softwaredepartment = new SoftwareDepartment(dep_name, dep_id, produse, clienti_dep, observatori_dep );
                store.addDepartment(softwaredepartment);
            }
            else if (dep_name.compareTo("VideoDepartment") == 0) {
                videodepartment = new VideoDepartment(dep_name, dep_id, produse, clienti_dep, observatori_dep);
                store.addDepartment(videodepartment);
            }
             
        }
        
        
        //citesc lista de clienti din fiesierul customers
        BufferedReader br2 = new BufferedReader(new FileReader("customers.txt"));
        int customers_nr = Integer.parseInt(br2.readLine());
        //parcurg fisierul rand cu rand si salvez datele in variabile
        for (int i = 0; i < customers_nr; i++) {
            line = br2.readLine();
            StringTokenizer st = new StringTokenizer(line, ";");
            String customer = st.nextElement().toString();
            Double budget = Double.parseDouble(st.nextElement().toString());
            String strategie = st.nextElement().toString();
            //Creez obiectele de tip ShoppingCart si WishList si lista de notificari
            ShoppingCart shp = new ShoppingCart(budget);
            WishList wsh = new WishList();
            ArrayList notifications = new ArrayList();
            //Creez obiectul de tip customer si le adaug in lista de clienti a magazinului
            Customer client = new Customer(customer, shp, wsh, notifications, strategie);
            store.clienti.add(client);
        }
        
        //Citesc din fisierul events evenimentele posibile si parsez comenzile
        BufferedReader br3 = new BufferedReader(new FileReader("events.txt"));
        int events_nr = Integer.parseInt(br3.readLine());
        //parcurg fisierul rand cu rand in functie de numarul de evenimente(linii)
        for (int i = 0; i < events_nr; i++) {
            line = br3.readLine();
            StringTokenizer st = new StringTokenizer(line, ";");
            String event = st.nextElement().toString();
            
            if (event.compareTo("addItem") == 0) {
                int item_ID = Integer.parseInt(st.nextElement().toString());
                String sw = st.nextElement().toString();
                String CustomerName = st.nextElement().toString();
                //Salvez listele de clienti si observatori din fiecare departament in niste liste de tip ArrayList
                ArrayList<Customer> obs_book = bookdepartment.getObservers();
                ArrayList<Customer> clienti_book = bookdepartment.getCustomers();
                ArrayList<Customer> obs_music = musicdepartment.getObservers();
                ArrayList<Customer> clienti_music = musicdepartment.getCustomers();
                ArrayList<Customer> obs_video = videodepartment.getObservers();
                ArrayList<Customer> clienti_video = videodepartment.getCustomers();
                ArrayList<Customer> obs_soft = softwaredepartment.getObservers();
                ArrayList<Customer> clienti_soft = softwaredepartment.getCustomers();
                //Itereaz prin lista de clienti
                ArrayList<Customer> lista_cl= store.getCustomers();
                ListIterator<Customer> iter = lista_cl.listIterator();
                while(iter.hasNext()){
                    Customer c = (Customer) iter.next();
                    if(c.getname().compareTo(CustomerName) == 0){
                        //daca am gasit clientul dat creez listele de produse pentru fiecare departament le creez iteratori si iterez prin ele
                        ArrayList<Item> b = bookdepartment.getItems();
                        ArrayList<Item> m = musicdepartment.getItems();
                        ArrayList<Item> v = videodepartment.getItems();
                        ArrayList<Item> s = softwaredepartment.getItems();
                        ListIterator<Item> it1 = b.listIterator();
                        ListIterator<Item> it2 = m.listIterator();
                        ListIterator<Item> it3 = v.listIterator();
                        ListIterator<Item> it4 = s.listIterator();
                        
                        while(it1.hasNext()){//iterez prin primul departament book department
                            Item i1 = (Item)it1.next(); 
                            if(i1.getID().equals(item_ID)){
                                //daca am gasit itemul cautat in departament verific daca trebuie adaugat in WishList sau ShoppingCart
                                if(sw.compareTo("ShoppingCart")== 0){
                                    c.shp.add(i1); //adauug produsul in ShoppingCartul Clientului                                 
                                    ListIterator cust = clienti_book.listIterator();
                                    int found = 0;
                                    while(cust.hasNext()){ 
                                        Customer CUST = (Customer) cust.next();
                                        if(CUST.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                    }//iterez prin lista de clienti a departamentului si vad daca exista deja, daca nu il adaug in lista de clienti a departamentului
                                    if (found == 0) {
                                        ArrayList cust2 = store.getCustomers();
                                        ListIterator it = cust2.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                clienti_book.add(c2);
                                            }
                                        }
                                    }      
                                    
                                }
                                else if(sw.compareTo("WishList")== 0){
                                    c.wsh.add(i1);//adaug in wishlist
                                    ListIterator obs = obs_book.listIterator();
                                    int found = 0;
                                    while(obs.hasNext()){ 
                                        Customer OBS = (Customer) obs.next();
                                        if(OBS.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                    }//iterez prin lista de observatori a departamentului si vad daca exista deja, daca nu il adaug in lista de observatori a departamentului
                                    if (found == 0) {
                                        ArrayList cust = store.getCustomers();
                                        ListIterator it = cust.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                obs_book.add(c2);
                                            }
                                        }
                                    }      
                                }
                            }
                        }//iterez prin urmatorul departament si fac acelasi lucru
                        while(it2.hasNext()){
                            Item i2 = (Item)it2.next();
                            //System.out.println(i2.getname());
                            if(i2.getID().equals(item_ID)){
                                if(sw.compareTo("ShoppingCart")== 0){
                                    c.shp.add(i2);
                                    ListIterator cust = clienti_music.listIterator();
                                    int found = 0;
                                    while(cust.hasNext()){ 
                                        Customer CUST = (Customer) cust.next();
                                        if(CUST.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                     }
                                    if (found == 0) {
                                        ArrayList cust2 = store.getCustomers();
                                        ListIterator it = cust2.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                clienti_music.add(c2);
                                            }
                                        }
                                    }      
                                    
                                }
                                else if(sw.compareTo("WishList")== 0){
                                    c.wsh.add(i2);
                                    ListIterator obs = obs_music.listIterator();
                                    int found = 0;
                                    while(obs.hasNext()){ 
                                        Customer OBS = (Customer) obs.next();
                                        if(OBS.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                     }
                                    if (found == 0) {
                                        ArrayList cust = store.getCustomers();
                                        ListIterator it = cust.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                obs_music.add(c2);
                                            }
                                        }
                                    }      
                                }
                            }
                        }
                        while(it3.hasNext()){
                            Item i3 = (Item)it3.next();
                            if(i3.getID().equals(item_ID)){
                                if(sw.compareTo("ShoppingCart")== 0){
                                    c.shp.add(i3);
                                    ListIterator cust = clienti_video.listIterator();
                                    int found = 0;
                                    while(cust.hasNext()){ 
                                        Customer CUST = (Customer) cust.next();
                                        if(CUST.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                     }
                                    if (found == 0) {
                                        ArrayList cust2 = store.getCustomers();
                                        ListIterator it = cust2.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                clienti_video.add(c2);
                                            }
                                        }
                                    }      
                                }
                                else if(sw.compareTo("WishList")== 0){
                                    c.wsh.add(i3);
                                    ListIterator obs = obs_video.listIterator();
                                    int found = 0;
                                    while(obs.hasNext()){ 
                                        Customer OBS = (Customer) obs.next();
                                        if(OBS.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                     }
                                    if (found == 0) {
                                        ArrayList cust = store.getCustomers();
                                        ListIterator it = cust.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                obs_video.add(c2);
                                            }
                                        }
                                    }      
                                }
                            }                                   
                        }
                        while(it4.hasNext()){
                            Item i4 = (Item)it4.next();
                            //System.out.println(i4.getname());
                            if(i4.getID().equals(item_ID)){
                                if(sw.compareTo("ShoppingCart")== 0){
                                   c.shp.add(i4);
                                   ListIterator cust = clienti_soft.listIterator();
                                    int found = 0;
                                    while(cust.hasNext()){ 
                                        Customer CUST = (Customer) cust.next();
                                        if(CUST.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                     }
                                    if (found == 0) {
                                        ArrayList cust2 = store.getCustomers();
                                        ListIterator it = cust2.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                clienti_soft.add(c2);
                                            }
                                        }
                                    }      
                                }
                                else if(sw.compareTo("WishList")== 0){
                                    c.wsh.add(i4);
                                    ListIterator obs = obs_soft.listIterator();
                                    int found = 0;
                                    while(obs.hasNext()){ 
                                        Customer OBS = (Customer) obs.next();
                                        if(OBS.getname().compareTo(CustomerName) == 0){
                                             found = 1;
                                        }
                                     }
                                    if (found == 0) {
                                        ArrayList cust = store.getCustomers();
                                        ListIterator it = cust.listIterator();
                                        while(it.hasNext()) {
                                            Customer c2 = (Customer) it.next();
                                            if (c2.getname().compareTo(CustomerName) == 0) {
                                                obs_soft.add(c2);
                                            }
                                        }
                                    }      
                                }
                            }                                   
                        }
                    }
                   
                }
  
            }// daca evenimentul e stergeitem parcurg aceeasi pasi ca si la add doar ca sterg din toate listele in care adaug la add
            else if (event.compareTo("delItem") == 0) {
                int itemID = Integer.parseInt(st.nextElement().toString());
                String swp = st.nextElement().toString();
                String CustomerName = st.nextElement().toString();
                //System.out.println(event + " " + itemID + " " + swp + " " + CustomerName);
                ArrayList<Customer> lista_clienti= store.getCustomers();
                ListIterator<Customer> iterator = lista_clienti.listIterator();
                
                ArrayList<Customer> obs_book = bookdepartment.getObservers();
                ArrayList<Customer> clienti_book = bookdepartment.getCustomers();
                ArrayList<Customer> obs_music = musicdepartment.getObservers();
                ArrayList<Customer> clienti_music = musicdepartment.getCustomers();
                ArrayList<Customer> obs_video = videodepartment.getObservers();
                ArrayList<Customer> clienti_video = videodepartment.getCustomers();
                ArrayList<Customer> obs_soft = softwaredepartment.getObservers();
                ArrayList<Customer> clienti_soft = softwaredepartment.getCustomers();
                
                while(iterator.hasNext()){
                    Customer c = (Customer) iterator.next();
                    if(c.getname().compareTo(CustomerName) == 0){
                        ArrayList<Item> b = bookdepartment.getItems();
                        ArrayList<Item> m = musicdepartment.getItems();
                        ArrayList<Item> v = videodepartment.getItems();
                        ArrayList<Item> s = softwaredepartment.getItems();
                        ListIterator<Item> it1 = b.listIterator();
                        ListIterator<Item> it2 = m.listIterator();
                        ListIterator<Item> it3 = v.listIterator();
                        ListIterator<Item> it4 = s.listIterator();
                        while(it1.hasNext()){
                            Item i1 = (Item)it1.next();
                            
                            //System.out.println(i1.getname() + i1.getID());
                            if(i1.getID().equals(itemID)){
                                if(swp.compareTo("ShoppingCart")== 0){
                                    c.shp.remove(i1);
                                    clienti_book.remove(c);
                                    //System.out.println(x);
                                    break;
                                    
                                }
                                else if(swp.compareTo("WishList")== 0){
                                    c.wsh.remove(i1);
                                    obs_book.remove(c);
                                    //System.out.println(y);
                                    break;
                                   
                                }
                            }
                        
                        }
                        while(it2.hasNext()){
                            Item i2 = (Item)it2.next();
                            //System.out.println(i2.getname());
                            if(i2.getID().equals(itemID)){
                                if(swp.compareTo("ShoppingCart")== 0){
                                    c.shp.remove(i2);
                                    clienti_music.remove(c);
                                    //System.out.println(x);
                                    break;
                                    
                                }
                                else if(swp.compareTo("WishList")== 0){
                                    c.wsh.remove(i2);
                                    obs_music.remove(c);
                                    break;
                                    
                                }
                            }
                        }
                        while(it3.hasNext()){
                            Item i3 = (Item)it3.next();
                            if(i3.getID().equals(itemID)){
                                if(swp.compareTo("ShoppingCart")== 0){
                                    c.shp.remove(i3);
                                    clienti_video.remove(c);
                                }
                                else if(swp.compareTo("WishList")== 0){
                                    c.wsh.remove(i3);
                                    obs_video.remove(c);
                                }
                            }                                   
                        }
                        while(it4.hasNext()){
                            Item i4 = (Item)it4.next();
                            //System.out.println(i4.getname());
                            if(i4.getID().equals(itemID)){
                                if(swp.compareTo("ShoppingCart")== 0){
                                   c.shp.remove(i4);
                                   clienti_soft.remove(c);

                                }
                                else if(swp.compareTo("WishList")== 0){
                                    c.wsh.remove(i4);
                                    obs_soft.remove(c);
                                }
                            }                                   
                        }
                    }
                   
                }
            }// adaug un produs cu ID-ul citit din fisier in lista de produse a departamentului cu ID citit
            else if (event.compareTo("addProduct") == 0) {
                int dep_ID = Integer.parseInt(st.nextElement().toString());
                int item_iD = Integer.parseInt(st.nextElement().toString());
                double price = Double.parseDouble(st.nextElement().toString());
                String product_name = st.nextElement().toString();
                //verific departamentele pe rand dupa ID cand gasesc departamentul adaug produl in lista de produse a departamentului
                if(bookdepartment.getId() == dep_ID){
                    ArrayList<Item> produse = bookdepartment.getItems();
                    produse.add(new Item(product_name,item_iD, price));
                    //Iterez prin lista de observatori si ii notific ca sa adaugat un produs nou
                    ArrayList<Customer> m = bookdepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.ADD, 20, dep_ID, item_iD);
                       client.update(n);
                    }
                }
                else if(musicdepartment.getId()== dep_ID){
                    ArrayList<Item> produse = musicdepartment.getItems();
                    produse.add(new Item(product_name,item_iD, price));
                    ArrayList<Customer> m = musicdepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.ADD, 20, dep_ID, item_iD);
                       client.update(n);
                    }
                }
                else if(videodepartment.getId() == dep_ID){
                    ArrayList<Item> produse = videodepartment.getItems();
                    produse.add(new Item(product_name,item_iD, price));
                    //System.out.println("S-a adaugat produs nou in dep: "+videodepartment.getId()+" "+x);
                    ArrayList<Customer> m = videodepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.ADD, 20, dep_ID, item_iD);
                       client.update(n);
                    }
                }
                else if(softwaredepartment.getId() == dep_ID){
                    ArrayList<Item> produse = softwaredepartment.getItems();
                    produse.add(new Item(product_name,item_iD, price));
                    //System.out.println("S-a adaugat produs nou in dep: "+softwaredepartment.getId()+" "+x);
                    ArrayList<Customer> m = softwaredepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.ADD, 20, dep_ID, item_iD);
                       client.update(n);
                    }
                }
            
            }//daca trebuie sa modific pretul produsului caut produsul in functie de ID-ul departamentului iterand prin lista de produse a departamentelor
            else if (event.compareTo("modifyProduct") == 0) {
                int depID = Integer.parseInt(st.nextElement().toString());
                int item_id = Integer.parseInt(st.nextElement().toString());
                double price = Double.parseDouble(st.nextElement().toString());
                if(bookdepartment.getId() == depID){
                    ArrayList<Item> produse_book = bookdepartment.getItems();
                    ListIterator<Item> it1 = produse_book.listIterator();
                    while(it1.hasNext()){ 
                        Item i1 = (Item)it1.next();
                        if(i1.getID() == item_id){
                            i1.setprice(price); //cand am gasit produsul ii setez noul pret
                        }
                    
                    }//Trimit notificare tuturor observatorilor departmentului dat despre modificarea produsului
                    ArrayList<Customer> m = bookdepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.MODIFY, 20, depID, item_id);
                       client.update(n);
                    }
                }//execut aceeasi pasi pentru urmatorul departament
                else if(musicdepartment.getId()== depID){
                    ArrayList<Item> produse_music = musicdepartment.getItems();
                    ListIterator<Item> it2 = produse_music.listIterator();
                    while(it2.hasNext()){ 
                        Item i2 = (Item)it2.next();
                        if(i2.getID() == item_id){
                            i2.setprice(price);
                        }
                    
                    }
                    ArrayList<Customer> m = musicdepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.MODIFY, 20, depID, item_id);
                       client.update(n);
                    }
                }
                
                else if(softwaredepartment.getId() == depID){
                   ArrayList<Item> produse_software = softwaredepartment.getItems();
                    ListIterator<Item> it3 = produse_software.listIterator();
                    while(it3.hasNext()){ 
                        Item i3 = (Item)it3.next();
                        if(i3.getID() == item_id){
                            i3.setprice(price);
                        }
                    
                    }
                    ArrayList<Customer> m = softwaredepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.MODIFY, 20, depID, item_id);
                       client.update(n);
                    }
                }
                else if(videodepartment.getId() == depID){
                    ArrayList<Item> produse_video = videodepartment.getItems();
                    ListIterator<Item> it4 = produse_video.listIterator();
                    while(it4.hasNext()){ 
                        Item i2 = (Item)it4.next();
                        if(i2.getID() == item_id){
                            i2.setprice(price);
                        }
                    
                    }
                    ArrayList<Customer> m = videodepartment.getObservers();
                    ListIterator it = m.listIterator();
                    while(it.hasNext()){ 
                       Customer client = (Customer)it.next();
                       Notification n = new Notification(Notification.NotificationType.MODIFY, 20, depID, item_id);
                       client.update(n);
                    }
                }
                
            }//daca produsul trebuie sters din lista de produse a departamentului dupa index , caut produsul dua index iterand pe rand in toate departamentule
            else if (event.compareTo("delProduct") == 0) {
                int item_index = Integer.parseInt(st.nextElement().toString());
                ArrayList<Item> b = bookdepartment.getItems();
                ArrayList<Item> m = musicdepartment.getItems();
                ArrayList<Item> v = videodepartment.getItems();
                ArrayList<Item> s = softwaredepartment.getItems();
                ListIterator<Item> it1 = b.listIterator();
                ListIterator<Item> it2 = m.listIterator();
                ListIterator<Item> it3 = v.listIterator();
                ListIterator<Item> it4 = s.listIterator();
                while(it1.hasNext()){ 
                    Item i1 = (Item)it1.next();
                    if(i1.getID().compareTo(item_index) == 0){
                        b.remove(i1);// sterg produsul din lista de produse a departamentului daca lam gasit
                        ArrayList<Customer> m2 = bookdepartment.getObservers();
                        ListIterator it5 = m2.listIterator();
                        //Trimit notificare de tip REMOVE tuturor observatorilor departamentului 
                        while(it5.hasNext()){ 
                            Customer client = (Customer)it5.next();
                            Notification n = new Notification(Notification.NotificationType.REMOVE, 20, bookdepartment.getId(), item_index);
                            client.update(n);
                        }//Sterg produsul din wishlist-ul clientilor ce au produsl respctiv
                        ArrayList<Customer> clienti = bookdepartment.getObservers();
                        ListIterator it = clienti.listIterator();
                        while(it.hasNext()){
                            Customer cl = (Customer)it.next();
                            WishList wish = cl.getWishlist();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);
                                }
                            }
                            
                        }//sterg produsul din ShoppingCartul clientilor ce au produsul respectiv
                        ArrayList<Customer> cli = bookdepartment.getCustomers();
                        ListIterator ito = cli.listIterator();
                        while(ito.hasNext()){
                            Customer cl = (Customer)ito.next();
                            ShoppingCart wish = cl.getShoppingCart();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);

                                }
                            }
                            
                        }
                    }
                }//procedez la fel pentru urmatorul departament 
                while(it2.hasNext()){ 
                    Item i2 = (Item)it2.next();
                    if(i2.getID().compareTo(item_index) == 0){
                        boolean x = m.remove(i2);
                        ArrayList<Customer> m2 = musicdepartment.getObservers();
                        ListIterator it5 = m2.listIterator();
                        while(it5.hasNext()){ 
                            Customer client = (Customer)it5.next();
                            Notification n = new Notification(Notification.NotificationType.REMOVE, 20, musicdepartment.getId(), item_index);
                            client.update(n);
                        }
                        ArrayList<Customer> clienti = musicdepartment.getObservers();
                        ListIterator it = clienti.listIterator();
                        while(it.hasNext()){
                            Customer cl = (Customer)it.next();                 
                            WishList wish = cl.getWishlist();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);
                                }
                            }
                        }
                        ArrayList<Customer> cli = musicdepartment.getCustomers();
                        ListIterator ito = cli.listIterator();
                        while(ito.hasNext()){
                            Customer cl = (Customer)ito.next();                      
                            ShoppingCart wish = cl.getShoppingCart();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);
                                }
                            }
                            
                        }
                    }
                }
                while(it3.hasNext()){ 
                    Item i3 = (Item)it3.next();
                    if(i3.getID().compareTo(item_index) == 0){
                        v.remove(i3);
                        ArrayList<Customer> m2 = videodepartment.getObservers();
                        ListIterator it5 = m2.listIterator();
                        while(it5.hasNext()){ 
                            Customer client = (Customer)it5.next();
                            Notification n = new Notification(Notification.NotificationType.REMOVE, 20, videodepartment.getId(), item_index);
                            client.update(n);
                        }
                        ArrayList<Customer> clienti = videodepartment.getObservers();
                        ListIterator it = clienti.listIterator();
                        while(it.hasNext()){
                            Customer cl = (Customer)it.next();
                 
                            WishList wish = cl.getWishlist();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);
                                }
                            }
                        }
                        ArrayList<Customer> cli = videodepartment.getCustomers();
                        ListIterator ito = cli.listIterator();
                        while(ito.hasNext()){
                            Customer cl = (Customer)ito.next();                      
                            ShoppingCart wish = cl.getShoppingCart();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);
                                }
                            }
                            
                        }
                    }
                }
                while(it4.hasNext()){ 
                    Item i4 = (Item)it4.next();
                    if(i4.getID().compareTo(item_index) == 0){
                        boolean x = s.remove(i4);
                        ArrayList<Customer> m2 = softwaredepartment.getObservers();
                            ListIterator it5 = m2.listIterator();
                            while(it5.hasNext()){ 
                                Customer client = (Customer)it5.next();
                                Notification n = new Notification(Notification.NotificationType.REMOVE, 20, softwaredepartment.getId(), item_index);
                                client.update(n);
                        }
                        ArrayList<Customer> clienti = softwaredepartment.getObservers();
                        ListIterator it = clienti.listIterator();
                        while(it.hasNext()){
                            Customer cl = (Customer)it.next();
                            WishList wish = cl.getWishlist();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);
                                }
                            }
                        }//System.out.println("S-a sters produsul din dep: "+softwaredepartment.getId()+" "+i4.getname()+" "+x);
                        ArrayList<Customer> cli = softwaredepartment.getCustomers();
                        ListIterator ito = cli.listIterator();
                        while(ito.hasNext()){
                            Customer cl = (Customer)ito.next();                      
                            ShoppingCart wish = cl.getShoppingCart();
                            ListIterator itw = wish.listIterator();
                            while (itw.hasNext()){
                                Item item = (Item)itw.next();
                                if(item.getID().equals(item_index)){
                                    wish.remove(item);
                                }
                            }
                            
                        }
                    }
                }
            }//Verific si aplic strategia de cumparare a clientului
            else if (event.compareTo("getItem") == 0) {
                String customer_name = st.nextElement().toString();
                ArrayList <Customer> lista_clienti= store.getCustomers();
                ListIterator it = lista_clienti.listIterator();
                while(it.hasNext()){//iterez prin lista de clienti a magazinului pana gasesc clientul cu numele dat
                    Customer client = (Customer)it.next();
                    if(client.getname().compareTo(customer_name) == 0){
                        if(client.getStrategy().compareTo("A") == 0){//daca clientul are strategia A apelez executia strategiei
                            StrategyA x = new StrategyA(client, bookdepartment, musicdepartment, softwaredepartment, videodepartment);
                            if(client.getWishlist().isEmpty() != true){//verific daca wishlistul clientului nu e gol
                            x.execute(client.getWishlist());
                            }
                        }//aplic aceasi pasi ca si in cazul A
                        else if(client.getStrategy().compareTo("B") == 0){
                            Strategy x = new StrategyB(client, bookdepartment, musicdepartment, softwaredepartment, videodepartment);
                            if(client.getWishlist().isEmpty() != true){
                            x.execute(client.getWishlist());
                            }
                        }
                        else if(client.getStrategy().compareTo("C") == 0){
                            StrategyC x = new StrategyC(client, bookdepartment, musicdepartment, softwaredepartment, videodepartment);
                            if(client.getWishlist().isEmpty() != true){
                            x.execute(client.getWishlist());
                            }
                        }
                    }
                }
            }//Afisez itemii din Wishlist-ul sau ShoppingCartul unui client in functie de nume
            else if (event.compareTo("getItems") == 0) {
                String cart = st.nextElement().toString();
                String CustomerN = st.nextElement().toString();
                System.out.print("[");
                ArrayList<Customer> lista_cl= store.getCustomers();
                ListIterator<Customer> iter = lista_cl.listIterator();
                while(iter.hasNext()){//iterez prin lista de clienti a magazinului
                    Customer c = (Customer) iter.next();
                    if(c.getname().compareTo(CustomerN) == 0){
                        if(cart.compareTo("ShoppingCart") == 0){//daca e shoppincart iterez prin lista si afisez
                            ShoppingCart pros_shp = c.getShoppingCart();
                            ListIterator it = pros_shp.listIterator();
                            while (it.hasNext()) {
                                Item item = (Item) it.next();
                                if(it.hasNext()){
                                    System.out.print(item.getname() + ";" + item.getID() + ";" + item.getprice()+", ");
                                }
                                else{
                                    System.out.print(item.getname() + ";" + item.getID() + ";" + item.getprice());
                                }
                            }
                        }
                        
                        else if(cart.compareTo("WishList") == 0){//daca e wishlist afisez lista de item-ri la momentul dat
                           WishList pros_wsh = c.getWishlist();
                            ListIterator it = pros_wsh.listIterator();
                            while (it.hasNext()) {
                                Item item = (Item) it.next();
                                if(it.hasNext()){
                                    System.out.print(item.getname() + ";" + item.getID() + ";" + item.getprice()+", ");
                                }
                                else{
                                    System.out.print(item.getname() + ";" + item.getID() + ";" + item.getprice());
                                }                            }
                        }
                    }
                }
                System.out.println("]");
                
            }
            else if (event.compareTo("getTotal") == 0) {//Afisez pretul total a produselor aflate la momentul dat in wishlistul sau shopingcartul clientului
                String swcart = st.nextElement().toString();
                String CustomerNam = st.nextElement().toString();
                ArrayList<Customer> lista_cl= store.getCustomers();
                ListIterator<Customer> iter = lista_cl.listIterator();
                while(iter.hasNext()){
                    Customer c = (Customer) iter.next();
                    if(c.getname().compareTo(CustomerNam) == 0){
                        if(swcart.compareTo("ShoppingCart") == 0){
                            c.shp.getTotalPrice();
                            System.out.println(c.shp.getTotalPrice());
                        }
                        else if(swcart.compareTo("WishList") == 0){
                             c.wsh.getTotalPrice();
                             System.out.println(c.wsh.getTotalPrice());
                           
                        }
                    }
                }
                
            }//Aplic metoda accept in functie de departament pentru produsele af;ate in shoppingcart-ul clientului dat
            else if (event.compareTo("accept") == 0) {
                int dep_ID = Integer.parseInt(st.nextElement().toString());
                String Customer_Nume = st.nextElement().toString();
                int dep_ID2 = bookdepartment.getId();
                //verific dupa ID daca am gasit departmantul 
                if(dep_ID == dep_ID2){
                    ArrayList<Customer> customers_dep = bookdepartment.getCustomers();
                    ListIterator<Customer> iter = customers_dep.listIterator();
                    while(iter.hasNext()){//Iterez prin lista de clienti a departamentului
                        Customer c = (Customer) iter.next();
                        if(c.getname().compareTo(Customer_Nume) == 0){
                            bookdepartment.accept(c.shp);//apelez metoda accept specifica departamentului pentru clientul gasit
                        }
                    }
                }
                else if(musicdepartment.getId() == dep_ID){
                    ArrayList<Customer> customers_dep = musicdepartment.getCustomers();
                    ListIterator<Customer> iter = customers_dep.listIterator();
                    while(iter.hasNext()){
                        Customer c = (Customer) iter.next();
                        if(c.getname().compareTo(Customer_Nume) == 0){
                            musicdepartment.accept(c.shp);
                        }
                    }
                }
                else if(videodepartment.getId() == dep_ID){
                    ArrayList<Customer> customers_dep = videodepartment.getCustomers();
                    ListIterator<Customer> iter = customers_dep.listIterator();
                    while(iter.hasNext()){
                        Customer c = (Customer) iter.next();
                        if(c.getname().compareTo(Customer_Nume) == 0){
                            videodepartment.accept(c.shp);
                        }
                    }
                }
                else if(softwaredepartment.getId() == dep_ID){
                    ArrayList<Customer> customers_dep = softwaredepartment.getCustomers();
                    ListIterator<Customer> iter = customers_dep.listIterator();
                    while(iter.hasNext()){
                        Customer c = (Customer) iter.next();
                        if(c.getname().compareTo(Customer_Nume) == 0){
                            softwaredepartment.accept(c.shp);
                        }
                    }
                }
            }//Afisez lista de observatori la momentul dat cautant prin departamentul cu indexul dat
            else if (event.compareTo("getObservers") == 0) {
                int dep_index = Integer.parseInt(st.nextElement().toString());
                System.out.print("[");
                if(bookdepartment.getId() == dep_index){
                    ArrayList<Customer> observatori = bookdepartment.getObservers();
                    ListIterator it = observatori.listIterator();
                    while (it.hasNext()) {
                        Customer c = (Customer)it.next();
                        if(it.hasNext()){
                            System.out.print(c.getname()+", ");
                        }
                        else{
                            System.out.print(c.getname());
                        }
                    }
                }    
                else if(musicdepartment.getId() == dep_index){
                    ArrayList<Customer> observatori = musicdepartment.getObservers();
                    ListIterator it = observatori.listIterator();
                    while (it.hasNext()) {
                        Customer c = (Customer)it.next();
                        if(it.hasNext()){
                            System.out.print(c.getname()+", ");
                        }
                        else{
                            System.out.print(c.getname());
                        }
                    }

                }
                else if(videodepartment.getId() == dep_index){
                    ArrayList<Customer> observatori = videodepartment.getObservers();
                    ListIterator it = observatori.listIterator();
                    while (it.hasNext()) {
                        Customer c = (Customer)it.next();
                      if(it.hasNext()){
                            System.out.print(c.getname()+", ");
                        }
                        else{
                            System.out.print(c.getname());
                        }
                    } 
                }
                else if(softwaredepartment.getId() == dep_index){
                    ArrayList<Customer> observatori = softwaredepartment.getObservers();
                    ListIterator it = observatori.listIterator();
                    while (it.hasNext()) {
                        Customer c = (Customer)it.next();
                        if(it.hasNext()){
                            System.out.print(c.getname()+", ");
                        }
                        else{
                            System.out.print(c.getname());
                        }
                    }
                }
                System.out.print("]\n");
            }//Afisez cl=olectia de notificari a unui client la momentul dat iterand prin lista de cliennti a magazinului
            else if (event.compareTo("getNotifications") == 0) {
                String Customer = st.nextElement().toString();
                //System.out.println(event + " " + Customer);
                ArrayList<Customer> lista_cl= store.getCustomers();
                ListIterator<Customer> iter = lista_cl.listIterator();
                System.out.print("[");
                while(iter.hasNext()){
                    Customer c = (Customer) iter.next();
                    if(c.getname().compareTo(Customer) == 0){
                        List notify = c.getcollectionn_otify();
                        ListIterator it = notify.listIterator();
                        while (it.hasNext()) {
                            Notification m = (Notification)it.next();
                            if(it.hasNext()){
                            System.out.print(m.getNotificationType() + ";" + m.getItemID() + ";" + m.getDepID() + ", ");  
                            }
                            else{
                            System.out.print(m.getNotificationType() + ";" + m.getItemID() + ";" + m.getDepID());
                            }

                        }
                    }
                }
                System.out.print("]\n");
            }
        }
       
    }
      
}
    

     
