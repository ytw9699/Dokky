var replyService = (function() {

	function add(commonData, callback, error) {
		
			$.ajax({
				type : 'post',
				url : '/replies/new',
				data : JSON.stringify(commonData),
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
			})
	}

	function getList(param, callback, error) { 
		
		var board_num = param.board_num;
		var page = param.page || 1;

		  $.getJSON("/replies/pages/" + board_num + "/" + page,
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
	    
	    $.getJSON("/replies/pages/" + num + "/" + page + ".json",
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
	
	function remove(reply_num, reply_id, board_num, callback, error) {
		
		$.ajax({
			
				type : 'delete',
				url : '/replies/' + reply_num,
				data:  JSON.stringify({reply_num:reply_num, userId:reply_id, board_num:board_num}),
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

	function updateReply(reply, callback, error) {

		$.ajax({
				type : 'put',
				url : '/replies/reply',
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

		$.get("/replies/" + reply_num + ".json", function(result) {

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

		var dateObj = new Date(timeValue);
		var yy = dateObj.getFullYear();
		var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
		var dd = dateObj.getDate();
		var hh = dateObj.getHours();
		var mi = dateObj.getMinutes();
		var ss = dateObj.getSeconds();
		
		return [ yy, '-', (mm > 9 ? '' : '0') + mm, '-',
				(dd > 9 ? '' : '0') + dd, ' ', (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi].join('');
	}

	function updateLike(commonData, callback, error) {//좋아요 업데이트

		$.ajax({
				type : 'put', 
				url : '/board/likeCount', 
				data : JSON.stringify(commonData), 
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
	
	function updateDisLike(commonData, callback, error) {//싫어요 업데이트

		$.ajax({
				type : 'put', 
				url : '/board/dislikeCount',  
				data : JSON.stringify(commonData), 
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
	
	function updateReplyLike(commonData, callback, error) {//댓글 좋아요 업데이트

		$.ajax({
				type : 'put', 
				url : '/replies/likeCount', 
				data : JSON.stringify(commonData), 
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
	
	function updateReplyDisLike(commonData, callback, error) {//댓글 싫어요 업데이트

		$.ajax({
				type : 'put', 
				url : '/replies/dislikeCount',  
				data : JSON.stringify(commonData), 
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
	
	function getUserCash(userId, callback, error) {

		$.get("/board/usercash/" + userId, function(result) {

			if (callback) {
				callback(result);
			}

		}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}
		
	/*function getList(param, callback, error) { 
		alert(3);
		var board_num = param.board_num;
		var page = param.page || 1;

		  $.get("/replies/pages/" + board_num + "/" + page + ".json",
				function(data) {
					if (callback) {
						callback(data);
					}
				}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}*/
	
	
	function updateDonation(commonData, callback, error) {//게시글 기부하기
		
		$.ajax({
			type : 'put', 
			url : '/board/donateMoney',  
			data : JSON.stringify(commonData), 
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
		
	function updateReplyDonation(commonData, callback, error) {//댓글 기부하기
	
			$.ajax({
				type : 'put', 
				url : '/replies/replyDonateMoney',  
				data : JSON.stringify(commonData), 
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
	
	function ScrapBoard(scrapData, callback, error) {
		
		$.ajax({
				type : 'post',
				url : '/mypage/scrapData/' + scrapData.board_num + '/' + scrapData.userId,
				success : function(result, status, xhr) {
					if (callback) {
						callback(result,xhr);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(xhr,er);
					}
				}
		});
	}
	
	function report(commonData, callback, error) {
		
			$.ajax({
				type : 'post',
				url : '/board/report',
				data : JSON.stringify(commonData),
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
			})
	}
	
	function postAlarm(alarmData, callback, error) {
		//console.log("postAlarm...............");  
		
		$.ajax({
			type : 'post',
			url : '/alarm',
			data : JSON.stringify(alarmData),
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
		})
	}
	/*function download(path, callback, error) {
		console.log("download...............");  
		 
		$.ajax({
			type : 'get',
			url : '/download?fileName='+path,
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
		})
	}*/
	
	return {
		add : add,
		get : get,
		getList : getList,
		remove : remove, 
		updateReply : updateReply,
		displayTime : displayTime,
		updateLike : updateLike,
		updateDisLike : updateDisLike,
		updateReplyLike : updateReplyLike,
		updateReplyDisLike : updateReplyDisLike,
		getUserCash : getUserCash,
		updateDonation : updateDonation,
		updateReplyDonation : updateReplyDonation,
		ScrapBoard : ScrapBoard,
		report : report,
		postAlarm : postAlarm
		/*download: download*/
	};

})();
