package org.my.controller;

	import java.nio.file.Files;
	import java.nio.file.Path;
	import java.nio.file.Paths;
	import java.util.List;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.PageDTO;
	import org.my.service.BoardService;
	import org.springframework.http.HttpStatus;
	import org.springframework.http.MediaType;
	import org.springframework.http.ResponseEntity;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.ModelAttribute;
	import org.springframework.web.bind.annotation.PathVariable;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestBody;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestMethod;
	import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;
	import org.springframework.web.servlet.mvc.support.RedirectAttributes;
	import org.my.domain.BoardAttachVO;
	
	import lombok.AllArgsConstructor;
	import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	private BoardService service;
	
	@GetMapping("/list")
	public String list(Criteria cri, Model model) {
		//log.info("list: " + cri);
		
		model.addAttribute("list", service.getList(cri));
		
		int total = service.getTotalCount(cri);//total은 특정게시판의 총 게시물수
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	
		return "board/list";
	}
	
	@GetMapping("/register")
	public String register(@ModelAttribute("category") int category) {
		
		return "board/register";
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {

		//log.info("==========================");

		//log.info("register: " + board);
		
		/*if (board.getAttachList() != null) {

			board.getAttachList().forEach(attach -> log.info(attach));
		}*/
		
		//log.info("==========================");
		
		service.register(board);

		//rttr.addFlashAttribute("result", board.getNum());
		 rttr.addAttribute("num", board.getNum());
		 rttr.addAttribute("category", board.getCategory());

		return "redirect:/board/get";
	}
	
	@GetMapping("/get")
	public void get(@RequestParam("num") Long num, @ModelAttribute("cri") Criteria cri, Model model) {

		//log.info("/get");
		model.addAttribute("board", service.get(num));//조회수증가 + 하나의 글 상세 데이터 가져오기
	}
	
	@GetMapping("/modify")
	public void getModifyForm(@RequestParam("num") Long num, @ModelAttribute("cri") Criteria cri, Model model) {

		//log.info("/modify");
		model.addAttribute("board", service.getModifyForm(num));//수정폼+데이터 가져오기
	}
	

	 @PostMapping("/modify")
	 public String modify(BoardVO board, Criteria cri, RedirectAttributes rttr) {
		 //log.info("modify:" + board);
		
		 /*if (service.modify(board)) { 
		 rttr.addFlashAttribute("result", "success");
		 }*/
		 service.modify(board);
		 
		 rttr.addAttribute("pageNum", cri.getPageNum());
		 rttr.addAttribute("amount", cri.getAmount());
		 rttr.addAttribute("type", cri.getType());
		 rttr.addAttribute("keyword", cri.getKeyword());
		 rttr.addAttribute("category", cri.getCategory());
		 rttr.addAttribute("num", board.getNum());
		 
	 return "redirect:/board/get";
	 }

	/*@GetMapping("/remove")
	public String remove(@RequestParam("num") Long num, Criteria cri, RedirectAttributes rttr) {

		//log.info("remove..." + num);
		if (service.remove(num)) {
			rttr.addFlashAttribute("result", "success");
		}
		service.remove(num); 
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		rttr.addAttribute("category", cri.getCategory());
		
		return "redirect:/board/list";
	}*/
	 @PostMapping("/remove")
		public String remove(@RequestParam("num") Long num, Criteria cri, RedirectAttributes rttr) {

			log.info("remove..." + num);

			List<BoardAttachVO> attachList = service.getAttachList(num);

			if (service.remove(num)) {
				// delete Attach Files
				deleteFiles(attachList);

				rttr.addFlashAttribute("result", "success");
			}
			return "redirect:/board/list" + cri.getListLink();
		}
	
	@RequestMapping(method = { RequestMethod.PUT,RequestMethod.PATCH }, 
			value = "/like/{num}", consumes = "application/json", produces = {
					MediaType.TEXT_PLAIN_VALUE })
	@ResponseBody
	public ResponseEntity<String> updateLike(
			 @RequestBody BoardVO vo, 
			 @PathVariable("num") Long num) {

		vo.setNum(num);

		log.info("num: " + num);

		return service.updateLike(num) == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping(value = "/getAttachList",
		    produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long num) {
	
		log.info("getAttachList " + num);

	return new ResponseEntity<>(service.getAttachList(num), HttpStatus.OK);
}
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
	    
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }
	    
	    log.info("delete attach files...................");
	    log.info(attachList);
	    
	    attachList.forEach(attach -> {
	      try {        
	        Path file  = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\" + attach.getUuid()+"_"+ attach.getFileName());
	        
	        Files.deleteIfExists(file);
	        
	        if(Files.probeContentType(file).startsWith("image")) {
	        
	          Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_" + attach.getUuid()+"_"+ attach.getFileName());
	          
	          Files.delete(thumbNail);
	        }
	
	      }catch(Exception e) {
	        log.error("delete file error" + e.getMessage());
	      }//end catch
	    });//end foreachd
	  }
	
}
