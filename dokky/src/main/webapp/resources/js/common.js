var commonService = (function() {

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
	
	return {
		insertNote : insertNote
	};

})();
