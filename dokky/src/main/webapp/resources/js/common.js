var commonService = (function() {
	
	function createReply(commonData, callback, error) {
		
			$.ajax({
				type : 'post',
				url : '/replies/reply',
				data : JSON.stringify(commonData),
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
								if (callback) { 
									callback(result,status);
								}
						  },
				error : function(xhr, status, er) {
							if (error) {
								error(status);
							}
						}
			})
	}

	function readReplyList(param, callback, error) { 
		
		var board_num = param.board_num;
		var page = param.page || 1;
		
		  $.getJSON("/replies/list/" + board_num + "/" + page,
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

/*	function readList(param, callback, error) {

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
	
	function removeReply(reply_num, reply_id, callback, error) {
		
		$.ajax({
			
				type : 'delete',
				url : '/replies/reply/' + reply_num,
				data:  JSON.stringify({ userId:reply_id }),
			    contentType: "application/json; charset=utf-8",
				success : function(deleteResult, status, xhr) {
					if (callback) {
						callback();
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

	function readReply(reply_num, callback, error) {

		$.get("/replies/reply/" + reply_num, function(result) {

			if (callback) {
				callback(result);
			}

		}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}

	function displayDayTime(timeValue) {

		var dateObj = new Date(timeValue);
		//var yy = dateObj.getFullYear();
		//var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
		//var dd = dateObj.getDate();
		var hh = dateObj.getHours();
		var mi = dateObj.getMinutes();
		var ss = dateObj.getSeconds();
		var time = hh < 12 ? "오전" : "오후";

		return time+" " + [(hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi].join('');
		
		/*return [ yy, '-', (mm > 9 ? '' : '0') + mm, '-',
				(dd > 9 ? '' : '0') + dd, ' ', (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi].join('');*/
	}
	
	function displayFullTime(timeValue) {

		var dateObj = new Date(timeValue);
		var yy = dateObj.getFullYear();
		var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
		var dd = dateObj.getDate();
		var hh = dateObj.getHours();
		var mi = dateObj.getMinutes();
		var ss = dateObj.getSeconds();
		var time = hh < 12 ? "오전" : "오후";
		
		return [ yy, '-', (mm > 9 ? '' : '0') + mm, '-',
				(dd > 9 ? '' : '0') + dd, ' ', (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi].join('');
	}
	
	function displayYearMonthTime(timeValue) {

		var dateObj = new Date(timeValue);
		var yy = dateObj.getFullYear();
		var mm = dateObj.getMonth() + 1;
		var dd = dateObj.getDate();
		
		return [ yy, '-', (mm > 9 ? '' : '0') + mm, '-',
				(dd > 9 ? '' : '0') + dd, ' '].join('');
	}
	
	function likeBoard(commonData, callback, error) {//좋아요 업데이트

		$.ajax({
				type : 'post', 
				url : '/board/likeBoard', 
				data : JSON.stringify(commonData), 
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
		});
	}
	
	function disLikeBoard(commonData, callback, error) {//싫어요 업데이트

		$.ajax({
				type : 'post', 
				url : '/board/disLikeBoard',  
				data : JSON.stringify(commonData), 
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
		});
	}
	
	function likeReply(commonData, callback, error) {//댓글 좋아요

		$.ajax({
				type : 'post', 
				url : '/replies/likeReply', 
				data : JSON.stringify(commonData), 
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
		});
	}
	
	function disLikeReply(commonData, callback, error) {//댓글 싫어요 업데이트

		$.ajax({
				type : 'post', 
				url : '/replies/disLikeReply',  
				data : JSON.stringify(commonData), 
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
		});
	}
	
	function getMyCash(userId, callback, error) {

		$.get("/board/myCash/" + userId, function(result, status) {

			if (callback) {
				callback(result, status);
			}

		}).fail(function(xhr, status, err) {
			if (error) {
				error(status);
			}
		});
	}
		
	/*function readList(param, callback, error) { 
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
	
	function giveBoardWriterMoney(commonData, callback, error) {//게시글 기부하기
		
		$.ajax({
			type : 'post', 
			url : '/board/giveBoardWriterMoney',  
			data : JSON.stringify(commonData), 
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
	}
		
	function giveReplyWriterMoney(commonData, callback, error) {
	
			$.ajax({
				type : 'post', 
				url : '/replies/giveReplyWriterMoney',  
				data : JSON.stringify(commonData), 
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
			});
	}
	
	function postScrapData(scrapData, callback, error) {
		
		$.ajax({
				type : 'post',
				url : '/board/scrapData/' + scrapData.board_num + '/' + scrapData.userId,
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
		});
	}
	
	function deleteScrapData(scrapData, callback, error) {
		
		$.ajax({
				type : 'delete',
				url : '/board/scrapData/' + scrapData.board_num + '/' + scrapData.userId,
				success : function(result, status, xhr) {
					if (callback) {
						callback(result, status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
		});
	}
	
	function report(reportData, callback, error) {
		
			$.ajax({
				type : 'post',
				url : '/board/report',
				data : JSON.stringify(reportData),
				contentType : "application/json; charset=utf-8",
				success : function(result, status, xhr) {
					if (callback) { 
						callback(status);
					}
				},
				error : function(xhr, status, er) {
					if (error) {
						error(status);
					}
				}
			})
	}
	
	function insertNote(noteData, callback, error) {
		
		$.ajax({
			type : 'post',
			url : '/note',
			data : JSON.stringify(noteData),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) { 
					callback(result, status);
				}
			},
			error : function(xhr, status, er) {
				if(status == "error"){
					openAlert("ServerError");
				}
			}
		})
	}
	
	function createSingleChat(commonData, callback, error) {
		
		$.ajax({
			type : 'post', 
			url : '/createSingleChat',  
			data : JSON.stringify(commonData), 
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
	}
	
	function createMultiChat(commonData, callback, error) {
		
		$.ajax({
			type : 'post', 
			url : '/createMultiChat',  
			data : JSON.stringify(commonData), 
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
	}
	
	function inviteChatMembers(commonData, callback, error) {
		
		$.ajax({
			type : 'post', 
			url : '/inviteChatMembers',  
			data : JSON.stringify(commonData), 
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
	}
	
	function getChat_type(chatRoomNum, callback, error){

		$.get("/chat_type?chatRoomNum=" + chatRoomNum, function(result, status){

			if (callback) {
				callback(result, status);
			}

		}).fail(function(xhr, status, err) {
			if (error) {
				error(status);
			}
		});
	}
	
	function getChatRoomMembers(chatRoomNum, callback, error) {
		
		$.ajax({
			type : 'get', 
			url : '/getChatRoomMembers?chatRoomNum='+chatRoomNum, 
			success : function(result, status, xhr) {
				if (callback) {
					callback(result, status);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(status);
				}
			}
		});
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
		createReply : createReply,
		readReply : readReply,
		readReplyList : readReplyList,
		removeReply : removeReply, 
		updateReply : updateReply,
		displayDayTime : displayDayTime,
		displayFullTime : displayFullTime,
		displayYearMonthTime : displayYearMonthTime,
		likeBoard : likeBoard,
		disLikeBoard : disLikeBoard,
		likeReply : likeReply,
		disLikeReply : disLikeReply,
		getMyCash : getMyCash,
		giveBoardWriterMoney : giveBoardWriterMoney,
		giveReplyWriterMoney : giveReplyWriterMoney,
		postScrapData : postScrapData,
		deleteScrapData : deleteScrapData,
		insertNote : insertNote,
		report : report,
		createSingleChat : createSingleChat,
		createMultiChat : createMultiChat,
		inviteChatMembers : inviteChatMembers,
		getChat_type : getChat_type,
		getChatRoomMembers : getChatRoomMembers
		/*download: download*/
	};

})();
