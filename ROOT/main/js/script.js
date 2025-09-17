$(function(){
	var fileTarget = $('.filebox .upload_hidden'); 
	
	fileTarget.on('change', function(){ //
		if ($(this).val() == '') {
			var filename = "";
		} else if (window.FileReader) { // modern browser 
			var filename = $(this)[0].files[0].name; 
		} else { // old IE 
			var filename = $(this).val().split('/').pop().split('\\').pop(); 
		} //
		$(this).siblings('.upload_name').val(filename); 
	});

	// history.scrollRestoration = "manual";




	

		// $('#pc_gnb .depth1 > li').addClass('on');		
		// $('#pc_gnb .depth2 > li, .nav_back').addClass('on');		
		
	/* pc nav */
	$('.pc #pc_gnb .depth1, .nav_back').on('mouseenter focus', function() {
	// $('.pc #pc_gnb .depth1, .nav_back').on('mouseenter focus', function() {	
		$('#pc_gnb .depth1 > li, .nav_back').addClass('on');		//
	});

	$('.pc #pc_gnb, .nav_back').on('mouseleave', function() {
		$('#pc_gnb .depth1 > li, .nav_back').removeClass('on'); //
	});
	// $('.pc #pc_gnb a.last').on('focusout', function() {
	// 	$('#pc_gnb .depth1 > li, .nav_back').removeClass('on'); //
	// });
	
	
	$('#pc_gnb a').focus(function(){
		$('#pc_gnb .depth1 > li, .nav_back').addClass('on');		
	});
	
	
	$('#pc_gnb .depth1 > li').on('mouseenter focus', function() {
		$(this).children('a').css({"color":"#665242"});
	});
	$('#pc_gnb .depth1 > li').on('mouseleave focusout', function() {
		$(this).children('a').css({"color":"#333"});
	});

	$('#pc_gnb .depth2 > li:not(.no_child) > a').on('click', function(e) {
		e.preventDefault();
		var $target = $(this).next();
		$('.depth3').not($target).slideUp();
		$(this).siblings('.depth3').slideToggle();
	});



	/* mobile nav */	
	$('#mobile_gnb .depth1 > li > a').on('click', function(e) {
		e.preventDefault();
		var $target = $(this).parent();
		$('#mobile_gnb li').not($target).removeClass('on');
		$target.toggleClass('on');
	});	
	$('#mobile_gnb .depth2 > li:not(.no_child) > a').on('click', function(e) {
		e.preventDefault();
		var $target = $(this).parent();
		$('#mobile_gnb .depth2 > li').not($target).removeClass('on');
		$target.toggleClass('on');
	});
	$('#mobile_header .btn_menu').on('click', function(e) {
		e.preventDefault();
		$('#mobile_header').toggleClass('menu_open');
		$('#mobile_gnb li').removeClass('on');
		// $('.dimmed_bg').toggle();
	});
	// $('.dimmed_bg').on('click', function(e) {
	// 	e.preventDefault();
	// 	$('#mobile_header').removeClass('menu_open');
	// 	$('.dimmed_bg').hide();
	// });




	/* 서브 메뉴 */
	$('#lnb > ul > li:not(.no_child) > a').on('click', function(e) {
		e.preventDefault();
		var $target = $(this).parent();
		$('#lnb > ul > li').not($target).removeClass('on');
		$target.toggleClass('on');
	});
	$('body').on("click", function(e){
		if($(e.target).closest("#lnb").length == 0){
			$('#lnb li').removeClass('on');
		}
	});

	$('.tab_menu1 a').on('click', function(e) {
		e.preventDefault();
		var idx = $(this).parent().index();
		var $target = $(this).parents('.tab_cont').find('.cont');
		$('.tab_menu1 li').removeClass('on');
		$(this).parent().addClass('on');
		$('.tab_cont .cont').removeClass('on');
		$target.eq(idx).addClass('on');
	});
	

	$('.research_list_title').click(function(){
    $(this).next(".research_list").stop().slideToggle(300);
    $(this).toggleClass('active');
    // $(this).toggleClass('active').siblings().removeClass('active');
    // $(this).next(".research_list").siblings(".research_list").slideUp(300); // 1개씩 펼치기
  });


	// 명예의전당
  // $('.honors_container').hide();
  // $('.honors_tab a').click(function () {
  //   $('.honors_container').hide().filter(this.hash).fadeIn();
  //   $('.honors_tab').removeClass('on');
  //   $(this).closest(".honors_tab").addClass('on');
  //   return false;
  // }).filter(':eq(0)').click();

});