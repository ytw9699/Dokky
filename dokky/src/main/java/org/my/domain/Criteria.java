package org.my.domain;
	import lombok.Getter;
	import lombok.Setter;
	import lombok.ToString;
	
@ToString
@Setter
@Getter
public class Criteria {//349페이지 나중에다시봐보자

  private int category;
  
  private int pageNum;
  private int amount;
  
  private String type;
  private String keyword;

  public Criteria() {
    this(1, 10);
  }

  public Criteria(int pageNum, int amount) {
    this.pageNum = pageNum;
    this.amount = amount;
  }
  
  public String[] getTypeArr() {
    
    return type == null? new String[] {}: type.split("");
  }
}
