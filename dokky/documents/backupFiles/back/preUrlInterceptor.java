/*마지막 업데이트 2022-05-31
1. 로그인후 이전 페이지로 이동하기 위해 url을 세션에 저장
2. 인증이 되지 않은 사용자에 한하여 수행*/
package org.my.utils;

import java.util.Enumeration;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import lombok.extern.log4j.Log4j;

@Log4j
public class preUrlInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        log.info("인터셉터 시작");

        if (SecurityContextHolder.getContext().getAuthentication() == null || SecurityContextHolder.getContext().getAuthentication().getPrincipal() == "anonymousUser") {

            HttpSession session = request.getSession();

            String preURI = request.getRequestURI();

            Enumeration<String> e = request.getParameterNames();

            if (e.hasMoreElements()) {
                preURI = preURI + "?";
            }

            while (e.hasMoreElements()) {

                String nextElement = e.nextElement();
                preURI = preURI + nextElement + "=";
                preURI = preURI + request.getParameter(nextElement);

                if (e.hasMoreElements()) {
                    preURI = preURI + "&";
                }
            }

            session.setAttribute("preUrl", preURI);
        }

        log.info("인터셉터 끝");

        return true;
    }

    @Override//클라이언트의 요청을 가로채되 컨트롤러 처리 후 하는작업들
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

        log.info("postHandle ");
    }
}
