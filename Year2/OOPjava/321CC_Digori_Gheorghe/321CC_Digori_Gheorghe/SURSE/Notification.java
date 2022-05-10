
package proiectpoo;


class Notification {
    private long timeStamp;

    Notification(String add) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    Notification(NotificationType notificationType) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    public enum NotificationType  {
        ADD,
        REMOVE,
        MODIFY
    };
    
    private int ID_dep;
    private int ID_item;
    private NotificationType n;
    
    public Notification(NotificationType n, long timeStamp, int ID_dep, int ID_item){
        this.n = n;
        this.ID_dep = ID_dep;
        this.ID_item = ID_item;
        this.timeStamp = timeStamp;
    }
    
    public int getDepID(){
        return this.ID_dep; 
    }
    public void setDepID(int ID){
        this.ID_dep = ID;
    }
    public int getItemID(){
        return this.ID_item; 
    }
    public void setItemID(int ID_item){
        this.ID_item = ID_item;
    }
    
    public void setTimeStamp(long timeStamp){
        this.timeStamp = timeStamp;
    }
    public long getTimeStamp(){
        return this.timeStamp;
    }
    public NotificationType getNotificationType() {
    return this.n;
    }
    public void settNotificationType() {
    this.n = n;
    }
}
