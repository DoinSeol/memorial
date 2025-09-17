
$(document).ready(function(){

 /*
	var slider = $('.bxslider').bxSlider();
	var mql = window.matchMedia("screen and (max-width: 768px)");
	mql.addListener(function(e) {
		if(!e.matches) { 
			slider.reloadSlider();
			}
		});
 */

/* 팝업창 */
function popup_setCookie( name, value, expiredays ){ 
  var todayDate = new Date();
  todayDate.setDate( todayDate.getDate() + expiredays ); 
  document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
}

function popup_closewin(){
  var form = document.popup_form;
  if(form.popup_chk.checked){  
    popup_setCookie("popup_" + form.idx.value , "done", 1); // 1 = 1하루 동안 이창을 열지 않음
  } 
  self.close();
}

function openPopup(idx, l, t, w, h, type){
  if(idx==null){ return; }
  
  if(type==0){
    w = 600;
    h = 400;
  }

  if(getCookie("popup_"+idx)!= "done"){
    var url = '/popup/read.action?idx='+idx;
    h = eval(h) + 40;   
    var popup = window.open(url, 'popup_'+idx, 'left='+l+',top='+t+',width='+w+',height='+h+',toolbar=no,status=no,scrollbars=no,resizeable=no');
    if(popup==null){
      //alert("팝업창을 활성화 해주세요");
    }else{
      popup.focus();
    }
  }
}

function openDivPopup(idx, l, t, w, h, type){
  if(idx==null){ return; }
  
  if(type==0){
    w = 600;
    h = 400;
  }

  if(getCookie("popup_"+idx)!= "done"){
    var url = '/popup/read.action?idx='+idx;
    h = eval(h) + 40;   
    var newDiv = document.createElement("div");
  newDiv.sytle.css = "position:absolute;width:450px;left:160;top:160;visibility:hidden;z-index:3";
  }
}


function openVod(url){
  var w = 760;
  var h = 320;
  var l = (screen.width/2)-(w/2); 
  var t = (screen.height/2)-(h/2);

  var vodPopup = window.open(url, 'vod', 'left='+l+',top='+t+',width='+w+',height='+h+',toolbar=no,status=no,scrollbars=no,resizeable=no');
  if(vodPopup==null){
    alert("VOD를 보시려면 팝업창을 활성화 해주세요");
  }else{
    vodPopup.focus();
  }
}

function addListener(element_name, name, observer, useCapture) {
  var element;
  if(element_name=="window") {
    element = window;
  } else  if(element_name=="body") {
    element = document.body;
  } 
  else {
    element = document.getElementById(element_name); 
  }

  useCapture = useCapture || false;
  if(element.addEventListener) {
    element.addEventListener(name, observer, useCapture);
  } else {
    element.attachEvent("on"+name, observer);
  }
}
 
	//글자 카운터 기능 S
	//페이지 내 글자카운터 클래스 수 만큼 기능실행
	$(".maxString").each(function(){
		//로드시 데이터가 있을시 글자수 초기화 세팅
		var wordMaxLength = $(this).attr("maxlength");
		$(this).parent().find(" .count_num").html("<span>"+$(this).val().length+"</span> / "+ wordMaxLength +"자");
	});
	
	//페이지 내 글자카운터 입력시 실시간 카운트
	$(function() {
	      $('.maxString').keyup(function (e){
	    	  var wordMaxLength = $(this).attr("maxlength");
	          var content = $(this).val();
	          $(this).parent().find(" .count_num").html('<span>'+content.length +'</span> / '+ wordMaxLength + '자');
	      });
	});
	//글자 카운터 기능 E


	// 탑버튼/* 상단 바로가기 */
    $(window).scroll(function () {
			if ($(this).scrollTop() > 100) {
				$('#cntTop').fadeIn();
			} else {
				$('#cntTop').fadeOut();
			}
		});

		$('#cntTop').click(function () {
			$('body,html').animate({
				scrollTop: 0
			}, 800);
			return false;
		});

	
	// 4dept - 셀렉트 박스
        var btn = $("nav[class='tabList']");
        if (btn.length > 0) {
            btn.find(".position").click(function (e) {
                btn.toggleClass("open");
                e.preventDefault();
            });
        }

	//서브페이지 서브메뉴	
	$(".slide-btn").click(function(){
		$('.active').removeClass('toggle');
		$(".sub_naviList").slideToggle("slow");
		$(this).toggleClass("active");
		return false;
	});

	//footer family site
	$(document).on('click', '.family-site > a', toggleLayer);
	
	//하단_패밀리사이트
	function toggleLayer(e){
		e.preventDefault();
		var click = $(this).hasClass("is-open");
		if(click){
			$(this).removeClass("is-open");
			$(this).addClass("is-close");
			$(this).next("ul").hide();
		} else{
			$(this).removeClass("is-close");
			$(this).addClass("is-open");
			$(this).next("ul").show();
		}

	$('.family-site > a').on('click', function(event){ 
		event.preventDefault();
		$(this).next('ul').slideDown('250', function(){
			$(this).find('a').click(function(){
				$('.family-site > ul').slideUp('200');
			});
		});
	});
	
	$('.family-site').mouseleave(function(){
		$(this).children('ul').slideUp('200');
	});

	}


	//drop-content
	$(".drop-content .drop-btn").click(function (e) {
		e.preventDefault();
		$(this).parent().toggleClass("selected", 500);
		var targetClass = $(this).parent().hasClass("selected");
		if(targetClass) {
			$(this).children("span").text("더보기");
		} else {
			$(this).children("span").text("닫기");
		}
	});

	
	//faq-열고닫기

	var faqTitle = $('.faq-list dt'),
		faqContent = $('.faq-list dd'),
		faqbtn = faqTitle.find(' > a');

	faqbtn.on('click', function(e) {
		e.preventDefault();

		var _this = $(this);


		if (_this.parent().hasClass('active')){
			faqTitle.removeClass('active');
			faqbtn.attr('title', '내용 보기');
			faqContent.removeAttr('tabindex');
		} else {
			_this.attr('title', '내용 닫기').parent().siblings().find('a').attr('title', '내용 보기');
			_this.parent().addClass('active').siblings().removeClass('active');
			_this.parent().next('dd').attr('tabindex', '0').focus().siblings().removeAttr('tabindex');
		}
	});


	// 아코디언
    var accoNum = 0;
    $(".acco li .titArea a").each(function(e){
        $(this).click(function(){
            if(accoNum != e){
                $(".acco > li").eq(accoNum).removeClass("on");
                $(".acco > li .txtArea").eq(accoNum).slideUp(200);
                accoNum = e;
                $(".acco > li").eq(accoNum).addClass("on");
                $(".acco > li .txtArea").eq(accoNum).slideDown(200);
            }else{
                $(".acco > li").eq(accoNum).removeClass("on");
                $(".acco > li .txtArea").eq(accoNum).slideUp(200);
                accoNum = -1;
            }
        });
    });
    
    var accoNum2 = 0;
    $(".acco2 > li").each(function(e){
        $(this).children("a").click(function(){
            if(accoNum2 != e){
                $(".acco2 > li").eq(accoNum2).removeClass("on");
                $(".acco2 > li .txtArea").eq(accoNum2).slideUp(200);
                accoNum2 = e;
                $(".acco2 > li").eq(accoNum2).addClass("on");
                $(".acco2 > li .txtArea").eq(accoNum2).slideDown(200);
            }else{
                $(".acco2 > li").eq(accoNum2).removeClass("on");
                $(".acco2 > li .txtArea").eq(accoNum2).slideUp(200);
                accoNum2 = -1;
            }
        });
    });

	//bPopup
	$(document).on('click', '.btn-modal', function(e) {
		// $(".btn-modal").click(function(e){
		e.preventDefault();
		$($(this).attr("href")).css({display:"block"});
		$("html").addClass("no-scroll");
		$(".dimd").css({display:"block"});
	});
	$(document).on('click', '.modal-pop .modal-close, .modal-pop .btn-close, .modal-pop .btn-modal-confirm', function(e) {
		// $(".modal-pop .modal-close, .dimd").click(function(e){
		e.preventDefault();
		$(".modal-pop").css({display:"none"});
		$("html").removeClass("no-scroll");
		$(".dimd").css({display:"none"});
	});


});

// SNS 연동
function toSNS(sns, Lang) 
{
 	var image = "http://www.jjwf.or.kr/images" + Lang + "/logo.jpg";
 	var strTitle = "JJWF";
 	var strURL = $(location).attr('href');
 	var lnkUrl = "";
  
 	switch(sns)
 	{
  		case "twitter":
  			 lnkUrl = "https://twitter.com/intent/tweet?text=&url=" + encodeURIComponent(strURL);
  			 break;
  			
  		case "facebook":
  			 lnkUrl = "http://www.facebook.com/share.php?u=" + encodeURIComponent(strURL);
  			 break;
  			 
  		default:
  			 break;
 	}
 
 	window.open(lnkUrl);
}






