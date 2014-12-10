$(->
	$('.dropdown.line li a').click(->
		line = $(this).text()
		$(this).parents('ul').siblings('button').text(line)
		key = $(this).data('line')
		type = $(this).data('line-type')
		renderSite(key,type)
	)

	$('#startSite,#endSite').click(->
		if($(this).attr('id') == 'startSite')
			if($('#startLine').text() != '选择线路')
				$(this).next('ul').show()
			else
				$(this).next('ul').hide()
		else
			if($('#endLine').text() != '选择线路')
				$(this).next('ul').show()
			else
				$(this).next('ul').hide()
	)


	$('body').on('click','.start-site li,.end-site li',->
		site = $(this).text()
		ul   = $(this).parents('ul')
		btn  = ul.siblings('button')
		btn.text(site)
		ul.hide()
		if btn.attr('id') == 'startSite'
			$('input.origin').val(site)
		else
			$('input.destination').val(site)
	)


	$('body').on('click','.btn-query',->
		origin = $.trim($('input.origin').val())
		destination = $.trim($('input.destination').val())
		if origin.length > 0  && destination.length > 0
			if origin != '选择站点' && destination != 'destination'
				$('form').submit()
	)


	siteObj = {
		1:["苹果园", "古城", "八角游乐园", "八宝山", "玉泉路", "五棵松", "万寿路", "公主坟", "军事博物馆", "木樨地", "南礼士路", "复兴门", "西单", "天安门西", "天安门东", "王府井", "东单", "建国门", "永安里", "国贸", "大望路", "四惠", "四惠东"],
		2:["西直门", "积水潭", "鼓楼大街", "安定门", "雍和宫", "东直门", "东四十条", "朝阳门", "建国门", "北京站", "崇文门", "前门", "和平门", "宣武门", "长椿街", "复兴门", "阜成门", "车公庄"],
		4:["安河桥北", "北宫门", "西苑", "圆明园", "北京大学东门", "中关村", "海淀黄庄", "人民大学", "魏公村", "国家图书馆", "动物园", "西直门", "新街口", "平安里", "西四", "灵境胡同", "西单", "宣武门", "菜市口", "陶然亭", "北京南站", "马家堡", "角门西", "公益西桥", "新宫", "西红门", "高米店北", "高米店南", "枣园", "清源路", "黄村西大街", "黄村火车站", "义和庄", "生物医药基地", "天宫院"],
		5:["宋家庄", "刘家窑", "蒲黄榆", "天坛东门", "磁器口", "崇文门", "东单", "灯市口", "东四", "张自忠路", "北新桥", "雍和宫", "和平里北街", "和平西桥", "惠新西街南口", "惠新西街北口", "大屯路东", "北苑路北", "立水桥南", "立水桥", "天通苑南", "天通苑", "天通苑北"]
		6:["海淀五路居", "慈寿寺", "花园桥", "白石桥南", "车公庄西", "车公庄", "平安里", "北海北", "南锣鼓巷", "东四", "朝阳门", "东大桥", "呼家楼", "金台路", "十里堡", "青年路", "褡裢坡", "黄渠", "常营", "草房"]
		8:["朱辛庄", "育知路", "平西府", "回龙观东大街", "霍营", "育新", "西小口", "永泰庄", "林萃桥", "森林公园南门", "奥林匹克公园", "奥体中心", "北土城", "安华桥", "鼓楼大街", "什刹海", "南锣鼓巷"]
		9:["郭公庄", "丰台科技园", "科怡路", "丰台南路", "丰台东大街", "七里庄", "六里桥", "六里桥东", "北京西站", "军事博物馆", "白堆子", "白石桥南", "国家图书馆"],
		10:["巴沟", "苏州街", "海淀黄庄", "知春里", "知春路", "西土城", "牡丹园", "健德门", "北土城", "安贞门", "惠新西街南口", "芍药居", "太阳宫", "三元桥", "亮马桥", "农业展览馆", "团结湖", "呼家楼", "金台夕照", "国贸", "双井", "劲松", "潘家园", "十里河", "分钟寺", "成寿寺", "宋家庄", "石榴庄", "大红门", "角门东", "角门西", "草桥", "纪家庙", "首经贸", "丰台站", "泥洼", "西局", "六里桥", "莲花桥", "公主坟", "西钓鱼台", "慈寿寺", "车道沟", "长春桥", "火器营"],
		13:["西直门", "大钟寺", "知春路", "五道口", "上地", "西二旗", "龙泽", "回龙观", "霍营", "立水桥", "北苑", "望京西", "芍药居", "光熙门", "柳芳", "东直门"],
		14:["张郭庄", "园博园", "大瓦窑", "郭庄子", "大井", "七里庄", "西局"],
		15:["望京西", "望京", "崔各庄", "马泉营", "孙河", "国展", "花梨坎", "后沙峪", "南法信", "石门", "顺义", "俸伯"],
		'btx':["四惠", "四惠东", "高碑店", "传媒大学", "双桥", "管庄", "八里桥", "通州北苑", "果园", "九棵树", "梨园", "临河里", "土桥"],
		'cpx':["南邵", "沙河高教园", "沙河", "巩华城", "朱辛庄", "生命科学园", "西二旗"] ,
		'yzx':["宋家庄", "肖村", "小红门", "旧宫", "亦庄桥", "亦庄文化园", "万源街", "荣京东街", "荣昌东街", "同济南路", "经海路", "次渠南", "次渠"],
		'fsx':["郭公庄", "大葆台", "稻田", "长阳", "篱笆房", "广阳城", "良乡大学城北", "良乡大学城", "良乡大学城西", "良乡南关", "苏庄"]

	}

	renderSite = (key,type)->
		sites = siteObj[key]
		$('.start-site ul').empty().siblings('button').text('选择站点') if type == 'start'
		$('.end-site ul').empty().siblings('button').text('选择站点') if type == 'end' 
		listr = ''
		for site in sites
			listr += "<li role='presentation'><a role='menuitem' tabindex='-1' href='javascript:void(0);'>#{site}</a></li>"
			if type == 'start'
				$('.start-site ul').empty().append(listr)
			else
				$('.end-site ul').empty().append(listr)

)