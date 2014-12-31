#require jquery.erasesr
$(->
	guess_user_id = new Fingerprint({canvas: true}).get()

	$.get("/guesses/check",{user_id:guess_user_id},(answer)->
		if(answer.continue)
			$('.start.guess').attr('href',"/guesses/#{answer.idx}?user_id=#{guess_user_id}")
		else
			$('.start.guess').attr('href',"/guesses/1")
	)


	$('.guess .list-group-item').click(->
		unless $(this).hasClass('disabled')
			$(this).addClass('active').siblings().removeClass('active').find('i').removeClass('fa-dot-circle-o').addClass('fa-circle-o')
			$(this).find('i').removeClass('fa-circle-o').addClass('fa-dot-circle-o')
			name = $(this).data('name')
			valu = $(this).data('value')
			$(this).parents('ul').find('li').addClass('disabled')
			submit_girl(name,valu)
	)

	submit_girl = (name,value)->
		$.post('/guesses',{name:name,value:value,user_id:guess_user_id},(data)->
			idx = parseInt(name.split('_')[1])	
			if(data.success)
				if idx < 8
					window.location.href = "/guesses/#{idx + 1}"
				else
					window.location.href = "/guesses/result?user_id=#{guess_user_id}"
		)


)