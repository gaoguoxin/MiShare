$(->
	animal_user_id = new Fingerprint({canvas: true}).get()
	if window.controller == 'animals'
		$.get("/animals/check",{user_id:animal_user_id},(answer)->
			if(answer.continue)
				$('.start.animals').html('<h4>继续答题</h4>').attr('href',"/animals/answer?user_id=#{animal_user_id}").show()
			else
				$('.start.animals').html('<h4>开始答题</h4>').attr('href',"/animals/answer").show()
		)

	WeixinApi.enableDebugMode()

	WeixinApi.ready((Api)-> 
		wxData = {
			"appId": "", 
			"imgUrl" : window.location.origin + '/' + window.img,
			"link" : '',
			"desc" : '',
			"title" : window.a_title
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
			if(data.success)
				if typeof data.q_idx == 'object' #回答完最后一题跳转到结果页面
					window.location.href = "/animals/result?user_id=#{animal_user_id}"
				else
					obj.hide().next('.question').show() #显示下一题
		)
)