package org.my.controller;
	import org.my.domain.BoardVO;
	import org.my.domain.Criteria;
	import org.my.domain.PageDTO;
	import org.my.service.BoardService;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.ModelAttribute;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
	import org.springframework.web.bind.annotation.RequestParam;
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
	//public String list(@RequestParam("category") int category, Criteria cri, Model model) {
	public String list(Criteria cri, Model model) {
		//log.info("list: " + cri);
		/*model.addAttribute("list", service.getList(category));
		model.addAttribute("category", category);*/
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, 123));//123이라는 토탈수에의해서 몇페이지까지보여질지가 정해짐 일단123 임시
	
		return "board/list";
	}
	
	@GetMapping("/register")
	public String register() {
		
		return "board/register";
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {

		log.info("register: " + board);

		service.register(board);

		//rttr.addFlashAttribute("result", board.getNum());

		return "redirect:/board/get?num="+board.getNum();
	}
	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("num") Long num, @ModelAttribute("cri") Criteria cri, Model model) {

		//log.info("/get or modify");
		model.addAttribute("board", service.get(num));
	}

	 @PostMapping("/modify")
	 public String modify(BoardVO board, RedirectAttributes rttr) {
		 log.info("modify:" + board);
		
		 if (service.modify(board)) {
		 rttr.addFlashAttribute("result", "success");
		 }
	 return "redirect:/board/get?num="+board.getNum();   
	 }

	@GetMapping("/remove")
	public String remove(
			@RequestParam("num") Long num,
			@RequestParam("category") int category, RedirectAttributes rttr) {

		log.info("remove..." + num);
		if (service.remove(num)) {
			rttr.addFlashAttribute("result", "success");
		}
		return "redirect:/board/list?category="+category;   
	}
}
