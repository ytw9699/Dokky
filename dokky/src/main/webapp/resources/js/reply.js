console.log("Reply Module.....22");
 
var replyService = (function() {

	function add(reply, callback, error) {//reply를 객체,
		console.log("add reply..............."); 
		//console.log(JSON.stringify(reply));
		$.ajax({
			type : 'post',
			url : '/dokky/replies/new',
			data : JSON.stringify(reply),//{"reply":"1","replyer":"1","num":"41"}
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) { 
					/*console.log(222);  
					console.log(callback); 
					console.log(111);*/
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		})
	}

	function getList(param, callback, error) { 

		var num = param.num;
		var page = param.page || 1;

		  $.getJSON("/dokky/replies/pages/" + num + "/" + page + ".json",
				function(data) {
					if (callback) {
						callback(data);
					}
				}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}
	
	

/*	function getList(param, callback, error) {

	    var num = param.num;
	    var page = param.page || 1;
	    
	    $.getJSON("/dokky/replies/pages/" + num + "/" + page + ".json",
	        function(data) {
	    	
	          if (callback) {
	            //callback(data); // 댓글 목록만 가져오는 경우 
	            callback(data.replyCnt, data.list); //댓글 숫자와 목록을 가져오는 경우 
	          }
	        }).fail(function(xhr, status, err) {
	      if (error) {
	        error();
	      }
	    });
	  }
*/
	
	/*function remove(reply_num, callback, error) {
		
		$.ajax({
			type : 'delete',
			url : '/dokky/replies/' + reply_num,
			success : function(deleteResult, status, xhr) {
				if (callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}*/
	function remove(reply_num, user_id, callback, error) {
		/*console.log("--------------------------------------");  
		console.log(JSON.stringify({reply_num:reply_num, nickName:orginal_nickname}));  
		*/
		$.ajax({
			type : 'delete',
			url : '/dokky/replies/' + reply_num,
			data:  JSON.stringify({reply_num:reply_num, userId:user_id}),
		    contentType: "application/json; charset=utf-8",
			success : function(deleteResult, status, xhr) {
				if (callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}

	function update(reply, callback, error) {

		console.log("reply_num: " + reply.reply_num);

		$.ajax({
			type : 'put',
			url : '/dokky/replies/' + reply.reply_num,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}

	function get(reply_num, callback, error) {

		$.get("/dokky/replies/" + reply_num + ".json", function(result) {

			if (callback) {
				callback(result);
			}

		}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}

	function displayTime(timeValue) {

		var today = new Date();

		var gap = today.getTime() - timeValue;

		var dateObj = new Date(timeValue);
		var str = "";

		if (gap < (1000 * 60 * 60 * 24)) {

			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();

			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi,
					':', (ss > 9 ? '' : '0') + ss ].join('');

		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
			var dd = dateObj.getDate();

			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/',
					(dd > 9 ? '' : '0') + dd ].join('');
		}
	}
	;

	function updateLike(likeData, callback, error) {//좋아요 업데이트

		console.log("likeData: " + likeData.num);

		$.ajax({
			type : 'put', 
			url : '/dokky/board/likeCount', 
			data : JSON.stringify(likeData), 
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}
	
	function updateDisLike(dislikeData, callback, error) {//싫어요 업데이트

		console.log("dislikeData: " + dislikeData.num);

		$.ajax({
			type : 'put', 
			url : '/dokky/board/dislikeCount',  
			data : JSON.stringify(dislikeData), 
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}
	
	function updateReplyLike(likeData, callback, error) {//좋아요 업데이트

		console.log("likeData: " + likeData.num);

		$.ajax({
			type : 'put', 
			url : '/dokky/replies/likeCount', 
			data : JSON.stringify(likeData), 
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		});
	}
	
	return {
		add : add,
		get : get,
		getList : getList,
		remove : remove,
		update : update,
		displayTime : displayTime,
		updateLike : updateLike,
		updateDisLike : updateDisLike,
		updateReplyLike : updateReplyLike
		
	};

})();
