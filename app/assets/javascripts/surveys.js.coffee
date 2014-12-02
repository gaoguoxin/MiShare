$(->
	user_id = new Fingerprint({canvas: true}).get() #指纹识别

	$.get("/answers/check",{user_id:user_id},(answer)->
		if(answer.exist)
			qidx = answer.q_idx
			if (qidx.length >= 15)
				$('.result .score').text(answer.score)
				if(answer.score < 60)
					$('.result-desc').text('很遗憾，从得分来看，您的童年一定很无趣，是否怀念你的童年呢？时间已悄然流逝，赶快分享快乐，抓住遗失的美好吧')
				else if (answer.score >= 60 &&  answer.score <= 120)
					$('.result-desc').text('呃，您小的时候很宅么，那么多有趣的事儿，您居然很少参与，真是太可怜了，赶紧分享给好友，一起回忆和讨论一下你们童年都干过哪些糗事吧！')
				else
					$('.result-desc').text('哇塞，你居然还能想起来这么多，真的很了不起！您还想起了哪些童年的趣事呢？赶紧分享给好友吧，让我们一起怀念即将逝去的青春吧！')
				$('.result').show()
			else
				remove_prev_question(qidx)
		else
			$('.begin').css('display','block')
	)

	#根据用户答题进度，删除页面中已经回答过的问题并显示即将要回答的问题
	remove_prev_question = (qidx)->
		$("#question_#{qidx}").prevAll().remove()
		$("#question_#{qidx}").show()


	#开始答题
	$('button.start').click(->
		$('.begin').hide().siblings('#question_1').show()
	)

	#变更选项
	$('.radio').click(->
		$(this).addClass('active').siblings('.radio').removeClass('active').find('i').removeClass('fa-dot-circle-o').addClass('fa-circle-o')
		$(this).find('i').removeClass('fa-circle-o').addClass('fa-dot-circle-o')
		name   = $(this).data('name')
		value  = $(this).data('value')
		submit_answer($('.question:visible'),name,value)
	)
	#提交答案并进行下一题
	# $('button.next').click(->
	# 	answer = $('.question:visible  .radio.active')
	# 	name   = answer.data('name')
	# 	value  = answer.data('value')
	# 	submit_answer($('.question:visible'),name,value)
	# )

	$('button.share').click(->
		$('.modal').modal('show')
	)





	#提交答案
	submit_answer = (obj,name,value)->
		$.post('/answers/set_answer',{user_id:user_id,name:name,value:value},(data)->
			if(data.success)
				if data.idx == 'question_15'
					$('.result .score').text(data.score)
					if(data.score < 60)
						$('.result-desc').text('很遗憾，从得分来看，您的童年一定很无趣，是否怀念你的童年呢？时间已悄然流逝，赶快分享快乐，抓住遗失的美好吧')
					else if (data.score >= 60 &&  data.score <= 120)
						$('.result-desc').text('呃，您小的时候很宅么，那么多有趣的事儿，您居然很少参与，真是太可怜了，赶紧分享给好友，一起回忆和讨论一下你们童年都干过哪些糗事吧！')
					else
						$('.result-desc').text('哇塞，你居然还能想起来这么多，真的很了不起！您还想起了哪些童年的趣事呢？赶紧分享给好友吧，让我们一起怀念即将逝去的青春吧！')

					$('.question').hide().siblings('.result').show()
				else
					obj.hide().next('.question').show()
		)



)
