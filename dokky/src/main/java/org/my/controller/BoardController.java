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
	
	/*@GetMapping("/list")
	public String list(Model model) {
	
		//log.info("list");
		model.addAttribute("list", service.getList());
	
		return "board/list";
	}*/
	
	@GetMapping("/list")
	public String list(@RequestParam("kind") int kind, Model model) {
	
		//log.info("list: " + cri);
		model.addAttribute("list", service.getList(kind));
		model.addAttribute("kind", kind);
	
		return "board/list";
	}

	/*@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		
		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, 123));//123이라는 토탈수에의해서 몇페이지까지보여질지가 정해짐 일단123 임시

		int total = service.getTotal(cri);

		log.info("total: " + total);

		//model.addAttribute("pageMaker", new PageDTO(cri, total));
		//void면 그냥 board/list jsp로 가게됨
	}*/

	// @GetMapping({ "/get", "/modify" })
	// public void get(@RequestParam("bno") Long bno, Model model) {
	//
	// log.info("/get or modify ");
	// model.addAttribute("board", service.get(bno));
	// }
	
	@GetMapping("/register")
	public String register() {
		
		return "board/register";
	}
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {//216p,246//RedirectAttributes일회성 데이터전달

		log.info("register: " + board);

		service.register(board);

		rttr.addFlashAttribute("result", board.getNUM());

		return "redirect:/board/main";
	}

	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {

		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
	}

	// @PostMapping("/modify")
	// public String modify(BoardVO board, RedirectAttributes rttr) {
	// log.info("modify:" + board);
	//
	// if (service.modify(board)) {
	// rttr.addFlashAttribute("result", "success");
	// }
	// return "redirect:/board/list";
	// }

	@PostMapping("/modify")//220p
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify:" + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());

		return "redirect:/board/list";
	}

	// @PostMapping("/remove")
	// public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr)
	// {
	//
	// log.info("remove..." + bno);
	// if (service.remove(bno)) {
	// rttr.addFlashAttribute("result", "success");
	// }
	// return "redirect:/board/list";
	// }

	@PostMapping("/remove")//221
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr) {

		log.info("remove..." + bno);
		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());

		return "redirect:/board/list";
	}

}
