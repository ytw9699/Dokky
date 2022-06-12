package org.my.visit;
	import javax.servlet.annotation.WebListener;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpSession;
	import javax.servlet.http.HttpSessionEvent;
	import javax.servlet.http.HttpSessionListener;
	import org.my.domain.VisitCountVO;
	import org.my.service.CommonService;
	import org.springframework.web.context.WebApplicationContext;
	import org.springframework.web.context.request.RequestContextHolder;
	import org.springframework.web.context.request.ServletRequestAttributes;
	import org.springframework.web.context.support.WebApplicationContextUtils;
	import lombok.extern.log4j.Log4j;

@Log4j  
@WebListener /* web.xml설정 안하고 @WebListener 어노테이션 설정함*/  
public class VisitSessionListener implements HttpSessionListener{
		
	 //@Setter(onMethod_ = @Autowired)
	 private CommonService service;
	
	 @Override //세션이 생성될 때 호출
	 public void sessionCreated(HttpSessionEvent sessionEvent) {
		
		 log.info("sessionCreated");
		 
		 int todayCount = 0; // 오늘 방문자 수
	     int totalCount = 0; // 전체 방문자 수
		 
		  HttpSession session = sessionEvent.getSession(); 	
		  WebApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(session.getServletContext());
		  service =  (CommonService) ctx.getBean("commonServiceImpl");
		   
		  HttpServletRequest request = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
			
		  VisitCountVO vo = new VisitCountVO();
					   vo.setIp(getClientIpAddr(request));
				       vo.setAgent(request.getHeader("User-Agent"));
				       vo.setRefer(request.getHeader("referer"));
	      
	      service.insertVisitor(vo);
	       
	      todayCount = service.getVisitTodayCount();
	      totalCount = service.getVisitTotalCount();
          
	      session.setAttribute("totalCount", totalCount); 
	      session.setAttribute("todayCount", todayCount);
	 }
	 
	 @Override  //세션이 폐기될 때 호출
	 public void sessionDestroyed(HttpSessionEvent sessionEvent) {
		 log.info("sessionDestroyed");
	 }
	 
	 public String getClientIpAddr(HttpServletRequest request) {//아이피가 정확히 안나올시
	        String ip = request.getHeader("X-Forwarded-For"); 
	        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	            ip = request.getHeader("Proxy-Client-IP");  
	        }  
	        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	            ip = request.getHeader("WL-Proxy-Client-IP");  
	        }  
	        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	            ip = request.getHeader("HTTP_CLIENT_IP");  
	        }  
	        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	            ip = request.getHeader("HTTP_X_FORWARDED_FOR");  
	        }  
	        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {  
	            ip = request.getRemoteAddr();  
	        }  
	        return ip;  
	    }
}
	

      
    
