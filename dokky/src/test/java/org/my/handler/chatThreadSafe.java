package org.my.handler;
	import java.util.Set;
	import java.util.concurrent.ConcurrentHashMap;

class Singleton2 {

	private Set<String> sessionsSet = ConcurrentHashMap.newKeySet();
	 
    private static Singleton2 singleton2 = new Singleton2();

    private Singleton2(){
    	sessionsSet.add("WebSocketSession1");
    	sessionsSet.add("WebSocketSession2");
    	sessionsSet.add("WebSocketSession3");
    }

    public static Singleton2 getInstance(){
        return singleton2;
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

public class chatThreadSafe{
	
    public static void main(String[] args) {
    	
        Singleton2 singleton = Singleton2.getInstance();

        for(int i=0; i<10; i++) {
        	
        	new Thread(() -> {
                singleton.readSession();
            }).start();
        }
        
        singleton.removeSession();
    }
}