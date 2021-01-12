package org.my.handler;
	import java.util.HashSet;

class Singleton {

	private HashSet<String> sessionsSet = new HashSet<>();
	 
    private static Singleton singleton = new Singleton();

    private Singleton(){
    	sessionsSet.add("WebSocketSession1");
    	sessionsSet.add("WebSocketSession2");
    	sessionsSet.add("WebSocketSession3");
    }

    public static Singleton getInstance(){
        return singleton;
    }

    public void readSession(){
    	
    	for(String session : sessionsSet){
    		
    		System.out.println("session="+session);
        }
    }
    
    public void removeSession(){
    	
    	 sessionsSet.remove("WebSocketSession3");
    }
}

public class chatNonThreadSafe{
	
    public static void main(String[] args) {
    	
        Singleton singleton = Singleton.getInstance();

        for(int i=0; i<10; i++) {
        	
        	new Thread(() -> {
                singleton.readSession();
            }).start();
        }
        
        singleton.removeSession();
    }
}