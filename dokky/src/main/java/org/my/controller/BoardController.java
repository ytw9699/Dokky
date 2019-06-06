package org.my.controller;

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
	public String register() {
		
		return "board/register";
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {

		//log.info("register: " + board);

		service.register(board);

		//rttr.addFlashAttribute("result", board.getNum());
		 rttr.addAttribute("num", board.getNum());
		 rttr.addAttribute("category", board.getCategory());

		return "redirect:/board/get";
	}
	
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("num") Long num, @ModelAttribute("cri") Criteria cri, Model model) {

		//log.info("/get or modify");
		service.updateHitCnt(num);
		model.addAttribute("board", service.get(num));
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

	@GetMapping("/remove")
	public String remove(@RequestParam("num") Long num, Criteria cri, RedirectAttributes rttr) {

		//log.info("remove..." + num);
		/*if (service.remove(num)) {
			rttr.addFlashAttribute("result", "success");
		}*/
		service.remove(num); 
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		rttr.addAttribute("category", cri.getCategory());
		
		return "redirect:/board/list";
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
	
}
