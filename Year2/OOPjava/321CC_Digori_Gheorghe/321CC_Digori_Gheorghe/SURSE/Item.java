
package proiectpoo;


class Item {
    private String name;
    private Integer ID;
    private Double price;
    
    public Item(String name, Integer ID, Double price){
        this.ID = ID;
        this.name = name;
        this.price = price;
    }

    public String toString1() {
    String result=  this.name+";"+this.ID+";"+ this.price+", ";
    return result;
    }
    
    public Integer getID(){
        return this.ID;
    }
    
    public String getname(){
        return this.name;
    }
    
    public Double getprice(){
        return this.price;
    }
    
    public void setID(Integer ID){
        this.ID = ID;
    }
    
    public void setname(String name){
        this.name = name;
    }
    
    public void setprice(Double p){
        this.price = p;
    }
}
