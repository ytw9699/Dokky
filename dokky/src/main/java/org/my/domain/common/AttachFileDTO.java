package org.my.domain.common;
	import lombok.Data;

@Data
public class AttachFileDTO {
		private String fileName;
		private String uploadPath;
		private String uuid;
		private boolean image;
}
