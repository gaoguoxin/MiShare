$(->
	animal_user_id = new Fingerprint({canvas: true}).get()
	if window.controller == 'animals'
		$.get("/animals/check",{user_id:animal_user_id},(answer)->
			if(answer.continue)
				$('.start.animals').html('<h4>继续答题</h4>').attr('href',"/animals/answer?user_id=#{animal_user_id}").show()
			else
				$('.start.animals').html('<h4>开始答题</h4>').attr('href',"/animals/answer").show()
		)


	#变更选项
	$('.animal.radio').click(->
		$(this).addClass('active').siblings('.radio').removeClass('active').find('i').removeClass('fa-dot-circle-o').addClass('fa-circle-o')
		$(this).find('i').removeClass('fa-circle-o').addClass('fa-dot-circle-o')
		name   = $(this).data('name')
		value  = $(this).data('value')
		submit_animal($('.question:visible'),name,value)
	)

	submit_animal = (obj,name,value)->
		$.post('/animals/set_answer',{user_id:animal_user_id,name:name,value:value},(data)->
			console.log(data)
			if(data.success)
				if typeof data.q_idx == 'object' #回答完最后一题跳转到结果页面
					window.location.href = "/animals/result?user_id=#{animal_user_id}"
				else
					obj.hide().next('.question').show() #显示下一题
		)


)