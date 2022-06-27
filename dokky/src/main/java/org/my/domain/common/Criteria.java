package org.my.domain.common;
	import org.springframework.web.util.UriComponentsBuilder;
	import lombok.Getter;
	import lombok.Setter;
	import lombok.ToString;
	
@ToString
@Setter
@Getter
public class Criteria {

  private int category;
  private int order;
  
  private int pageNum;//현재페이지
  private int amount;//현재 페이지에서 보여주는 데이터 수
  
  private String type;
  private String keyword;
  
  private String userId;
  private String nickName;

  public Criteria() {
    this(1, 10);
  }

  public Criteria(int pageNum, int amount) {
    this.pageNum = pageNum;
    this.amount = amount;
  }
  
  public String[] getTypeArr() {
    
	  return type == null ? new String[] {} : type.split("");
  }
  
  public String getListLink() {
	    //GET 방식 등의 파라미 터 전송에 시용되는 문자열(쿼리스트링 )을 손쉽게 처리할 수 있는 클래스
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
							.queryParam("category", this.category)
							.queryParam("pageNum", this.pageNum)
							.queryParam("amount", this.getAmount())
							.queryParam("type", this.getType())
							.queryParam("keyword", this.getKeyword());

		return builder.toUriString();//?pageNum=3&amount=20&type=TC&keyword=%EC%83%88%EB%Al%9C
  }
}
