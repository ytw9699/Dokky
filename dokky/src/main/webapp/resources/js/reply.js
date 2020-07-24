var replyService = (function() {

	function create(commonData, callback, error) {
		
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

	function readList(param, callback, error) { 
		
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
	
	function remove(reply_num, reply_id, callback, error) {
		
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

	function get(reply_num, callback, error) {

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
					if (error) {likeReply
						error(er);
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
	
	function deleteScrapData(scrapData, callback, error) {
		
		$.ajax({
				type : 'delete',
				url : '/board/scrapData/' + scrapData.board_num + '/' + scrapData.userId,
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
		create : create,
		get : get,
		readList : readList,
		remove : remove, 
		updateReply : updateReply,
		displayTime : displayTime,
		updateLike : updateLike,
		updateDisLike : updateDisLike,
		likeReply : likeReply,
		disLikeReply : disLikeReply,
		getUserCash : getUserCash,
		updateDonation : updateDonation,
		giveReplyWriterMoney : giveReplyWriterMoney,
		postScrapData : postScrapData,
		deleteScrapData : deleteScrapData,
		report : report,
		postAlarm : postAlarm
		/*download: download*/
	};

})();
