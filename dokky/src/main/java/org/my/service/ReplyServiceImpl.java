package org.my.service;

	import java.util.List;
	
	import org.my.domain.Criteria;
	import org.my.domain.ReplyPageDTO;
	import org.my.domain.ReplyVO;
	import org.my.mapper.BoardMapper;
	import org.my.mapper.ReplyMapper;
	
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	
	import lombok.Setter;
	//import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Service
@Log4j
//@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService {
  
	@Setter(onMethod_ = @Autowired)
	private ReplyMapper mapper;

	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	
  /*@Override
  public int register(ReplyVO vo) {

    log.info("register......" + vo);

    return mapper.insert(vo);

  }*/
	
	//@Transactional
	@Override
	public int register(ReplyVO vo) {

		log.info("register......" + vo);

		//boardMapper.updateReplyCnt(vo.getNum(), 1);

		return mapper.insert(vo);

	}
	
  @Override
  public ReplyVO get(Long reply_num) {

    log.info("get......" + reply_num);

    return mapper.read(reply_num);

  }

  @Override
  public int modify(ReplyVO vo) {

    log.info("modify......" + vo);

    return mapper.update(vo);

  }

 /* @Override
  public int remove(Long reply_num) {

    log.info("remove...." + reply_num);

    return mapper.delete(reply_num);

  }*/
  
  //@Transactional
	@Override
	public int remove(Long reply_num) {

		log.info("remove...." + reply_num);

		//ReplyVO vo = mapper.read(reply_num);

		//boardMapper.updateReplyCnt(vo.getNum(), -1);
		
		return mapper.delete(reply_num);

	}
  

  @Override
  public List<ReplyVO> getList(Criteria cri, Long num) {

    log.info("get Reply List of a Board " + num);

    return mapper.getListWithPaging(cri, num);

  }
  
  @Override
  public ReplyPageDTO getListPage(Criteria cri, Long num) {
       
    return new ReplyPageDTO(
        mapper.getCountBynum(num), 
        mapper.getListWithPaging(cri, num));
  }


}

