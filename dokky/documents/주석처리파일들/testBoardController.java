/*private void deleteFiles(List<BoardAttachVO> attachList) {
    
    if(attachList == null || attachList.size() == 0) {
      return;
    }
    
    log.info("delete attach files........");
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
	      }
    });
	}*/