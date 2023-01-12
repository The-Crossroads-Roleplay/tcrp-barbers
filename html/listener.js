window.addEventListener('message', (event) => {
	var telegram = event.data

	if (telegram.message == null) {
		$("body").hide();
		$('.telegram_sender').show()
		$('.telegram_message').show()
		$('.telegram_container_sending').hide()
		$('.telegram_buttons_send').hide()
		$('.telegram_buttons_read').show()
		$('.telegram_track_button').hide()
		// console.log("Null")
	} else if (telegram.message == false) {
		// console.log(telegram.message)
		$("body").show();
		$('.telegram_container_sending').hide()
		$('.telegram_buttons_send').hide()
		$('.telegram_buttons_read').show()
		$('.telegram_sender').html("<p>"+ telegram.recipient + " - " + telegram.station+"</p>");
		$('.telegram_message').html("<p>NO TELEGRAMS TO DISPLAY</p>");
		$('.telegram_sender').show()
		$('.telegram_message').show()
		$('.telegram_track_button').hide()
	} else {
		// console.log(telegram.sender)
		$("body").show();
		$('.telegram_container_sending').hide()
		$('.telegram_buttons_send').hide()
		$('.telegram_buttons_read').show()
		$('.telegram_sender').html("<p>" + telegram.sender + " to " + telegram.recipient + " - " + telegram.station + "</p>");
		$('.telegram_message').html("<p>"+telegram.message+"</p>");
		$('.telegram_sender').show()
		$('.telegram_message').show()
		if (telegram.restricted == true) {
			$('.telegram_track_button').show()
		} else {
			$('.telegram_track_button').hide()
		}
	}
	$(".telegram_back_button").unbind().click(function(){
		$.post('http://telegram/back', JSON.stringify({			
			restricted: telegram.restricted
		})
	  );
	});

	$(".telegram_next_button").unbind().click(function(){
		$.post('http://telegram/next', JSON.stringify({
			restricted: telegram.restricted
		})
	  );
	});

	$(".telegram_new_button").unbind().click(function(){
		$('.telegram_sender').hide()
		$('.telegram_message').hide()
		$('.telegram_buttons_read').hide()
		$('.telegram_container_sending').show()
		$('.telegram_buttons_send').show()
	});

	$(".telegram_send_button").unbind().click(function(){
		var station = document.getElementById('telegram_sender_sending_station').value;
		var recipientId = document.getElementById('telegram_sender_sending_identifier').value;
		var message = document.getElementById('telegram_message_sending_body').value;
	  $.post('http://telegram/new', JSON.stringify({
		  	station: station,
			recipientId: recipientId,
			message: message
	  }));
	});
	$(".telegram_close_button").unbind().click(function(){
		$.post('http://telegram/close', JSON.stringify({})
	  );
	});
	
	$(".telegram_delete_button").unbind().click(function(){
		$.post('http://telegram/delete', JSON.stringify({
			restricted: telegram.restricted
		})
	  );
	});

	$(".telegram_track_button").unbind().click(function(){
		$.post('http://telegram/track', JSON.stringify({})
	  );
	});

});

window.addEventListener('keydown', function(e){
    if((e.key=='Escape'||e.key=='Esc'||e.keyCode==27)){
		$('.telegram_sender').show()
		$('.telegram_message').show()
		$.post('http://telegram/close', JSON.stringify({}));
    }
}, true);