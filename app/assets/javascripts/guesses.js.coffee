#require jquery.erasesr
$(->
	guess_user_id = new Fingerprint({canvas: true}).get()
	console.log(window.score)
	WeixinApi.enableDebugMode()

	if window.controller == 'guesses'
		$.get("/guesses/check",{user_id:guess_user_id},(answer)->
			if(answer.continue)
				$('.start.guess').attr('href',"/guesses/#{answer.idx}?user_id=#{guess_user_id}")
			else
				$('.start.guess').attr('href',"/guesses/1")
		)

		WeixinApi.ready((Api)-> 
			if window.score
				str = '快来玩猜美女,我得了' + window.score + '分'
			else
				str = window.a_title
			wxData = {
				"appId": "", 
				"link" : window.location.origin + '/guess',
				"desc" : '',
				"title" : str
			}
	
	
			wxCallbacks = {
				#收藏操作不执行回调，默认是开启(true)的
				favorite : false,
		
				#分享操作开始之前
				ready: ()-> 
					#你可以在这里对分享的数据进行重组
					#alert("准备分享")
				
				#分享被用户自动取消
				cancel: (resp)-> 
					#你可以在你的页面上给用户一个小Tip，为什么要取消呢？
					#alert("分享被取消，msg=" + resp.err_msg)
				
				#分享失败了
				fail:(resp)-> 
					#分享失败了，是不是可以告诉用户：不要紧，可能是网络问题，一会儿再试试？
					#alert("分享失败，msg=" + resp.err_msg)
				
				#分享成功
				confirm: (resp)-> 
					#分享成功了，我们是不是可以做一些分享统计呢？
					#alert("分享成功，msg=" + resp.err_msg)
				
				#整个分享过程结束
				all: (resp,shareTo)-> 
					#如果你做的是一个鼓励用户进行分享的产品，在这里是不是可以给用户一些反馈了？
					#alert("分享" + (shareTo ? "到" + shareTo : "") + "结束，msg=" + resp.err_msg)
				
			}
		
			#用户点开右上角popup菜单后，点击分享给好友，会执行下面这个代码
			Api.shareToFriend(wxData, wxCallbacks)
		
			#点击分享到朋友圈，会执行下面这个代码
			Api.shareToTimeline(wxData, wxCallbacks)
		
			#点击分享到腾讯微博，会执行下面这个代码
			Api.shareToWeibo(wxData, wxCallbacks)
		
			#iOS上，可以直接调用这个API进行分享，一句话搞定
			Api.generalShare(wxData,wxCallbacks)
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