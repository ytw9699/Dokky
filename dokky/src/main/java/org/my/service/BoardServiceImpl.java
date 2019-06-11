package org.my.service;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.mapper.BoardAttachMapper;
	import org.my.mapper.BoardMapper;
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.stereotype.Service;
	import org.springframework.transaction.annotation.Transactional;
	import org.my.domain.BoardAttachVO;

	import lombok.Setter;
	import lombok.extern.log4j.Log4j;

@Log4j
@Service//비즈니스 영역담당 어노테이션
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Override
	public List<BoardVO> getList(Criteria cri) {

		log.info("get List with criteria: " + cri);

		return mapper.getList(cri);
	}
	
	@Transactional
	@Override
	public void register(BoardVO board) {

		//log.info("register......" + board);

		mapper.insertSelectKey(board); 

		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}

		board.getAttachList().forEach(attach -> {// attach는 BoardAttachVO

			attach.setNum(board.getNum());
			attachMapper.insert(attach);
		});
	}
	
	@Transactional
	@Override
	public BoardVO get(Long num) {

		log.info("get..." + num);
		
		log.info("updateHitCnt..." + num);
		
		mapper.updateHitCnt(num);//조회수 증가
		
		return mapper.read(num);
	}
	@Override
	public BoardVO getModifyForm(Long num) {

		log.info("getModifyForm" + num);
		
		return mapper.read(num);
	}

	@Override
	public boolean modify(BoardVO board) {

		log.info("modify......" + board);

		return mapper.update(board) == 1;
	}

	@Override
	public boolean remove(Long num) {

		log.info("remove...." + num);

		return mapper.delete(num) == 1;
	}

	@Override
	public int getTotalCount(Criteria cri) {

		log.info("get total count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public int updateLike(Long num) {//좋아요수 증가
		
		return mapper.updateLike(num);
	}
	
	@Override
	public List<BoardAttachVO> getAttachList(Long num) {

		log.info("get Attach list by num" + num);

		return attachMapper.findByNum(num);
	}

	/*@Override
	public void removeAttach(Long num) {

		log.info("remove all attach files");

		attachMapper.deleteAll(num);
	}*/
}
