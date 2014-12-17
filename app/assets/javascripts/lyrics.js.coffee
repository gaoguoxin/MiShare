$(->
	lyric_user_id = new Fingerprint({canvas: true}).get()
	if window.controller == 'lyrics'
		$.get("/lyrics/check",{user_id:lyric_user_id},(answer)->
			if(answer.continue)
				$('.start.lyrics').html('<h4>继续答题</h4>').attr('href',"/lyrics/answer?user_id=#{lyric_user_id}").show()
			else
				$('.start.lyrics').html('<h4>开始答题</h4>').attr('href',"/lyrics/answer").show()
		)


	#变更选项
	$('.lyrc.radio').click(->
		$(this).addClass('active').siblings('.radio').removeClass('active').find('i').removeClass('fa-dot-circle-o').addClass('fa-circle-o')
		$(this).find('i').removeClass('fa-circle-o').addClass('fa-dot-circle-o')
		name   = $(this).data('name')
		value  = $(this).data('value')
		submit_lyrc($('.question:visible'),name,value)
	)

	submit_lyrc = (obj,name,value)->
		$.post('/lyrics/set_answer',{user_id:lyric_user_id,name:name,value:value},(data)->
			console.log(data)
			if(data.success)
				if data.continue > 0 #继续答题
					if typeof data.q_idx == 'object' #回答完最后一题跳转到结果页面
						window.location.href = "/lyrics/result?user_id=#{lyric_user_id}"
					else
						obj.hide().next('.question').show() #显示下一题
				else # 回答某题错误，直接跳转到答案页面
					window.location.href = "/lyrics/result?user_id=#{lyric_user_id}"
		)


)