/***********************************************************************************************************************
DOCUMENT: includes/javascript.js
DEVELOPED BY: Ryan Stemkoski
COMPANY: Zipline Interactive
EMAIL: ryan@gozipline.com
PHONE: 509-321-2849
DATE: 3/26/2009
UPDATED: 3/25/2010
DESCRIPTION: This is the JavaScript required to create the accordion style menu.  Requires jQuery library
NOTE: Because of a bug in jQuery with IE8 we had to add an IE stylesheet hack to get the system to work in all browsers. I hate hacks but had no choice :(.
************************************************************************************************************************/
$(document).ready(function() {
	//ACCORDION BUTTON ACTION (ON CLICK DO THE FOLLOWING)
	$('ul.leftNavigation li ul.leftSub').slideUp('normal');
	//$("ul#leftNavigation li a").click(function(event) {event.preventDefault();

	$('ul.leftNavigation > li > a').click(function(event) {

		//REMOVE THE ON CLASS FROM ALL BUTTONS
		event.preventDefault();
		$('ul.leftNavigation li a').removeClass('on');
		  
		//NO MATTER WHAT WE CLOSE ALL OPEN SLIDES
	 	$('ul.leftNavigation li ul.leftSub').slideUp('normal');
   
		//IF THE NEXT SLIDE WASN'T OPEN THEN OPEN IT
		if($(this).next('ul').is(':hidden') == true) {
			
			//ADD THE ON CLASS TO THE BUTTON
			$(this).addClass('on');
			  
			//OPEN THE SLIDE
			$(this).next().slideDown('normal');
		 } 
		  
	 });
	  
	
	/*** REMOVE IF MOUSEOVER IS NOT REQUIRED ***/
	
	//ADDS THE .OVER CLASS FROM THE STYLESHEET ON MOUSEOVER 
	$('ul#leftNavigation li a').mouseover(function() {
		$(this).addClass('over');
		
	//ON MOUSEOUT REMOVE THE OVER CLASS
	}).mouseout(function() {
		$(this).removeClass('over');										
	});
	
	/*** END REMOVE IF MOUSEOVER IS NOT REQUIRED ***/
	
	
	/********************************************************************************************************************
	CLOSES ALL S ON PAGE LOAD
	********************************************************************************************************************/	
	$('ul#leftNavigation li ul.leftSub').hide();
	$('ul.leftNavigation').hide();
	$('ul.leftNavigation').prev().addClass('subMenuOff');
	$('ul.leftNavigation:first').show();
	$('ul.leftNavigation:first').prev().removeClass('subMenuOff');
	$(".navigationHeading").click(function () {
	//$(this).next("ul#leftNavigation").toggle("slow");
	if($(this).next('ul.leftNavigation').is(':hidden') == false) {
			$(this).addClass('subMenuOff');
			$(this).next('ul.leftNavigation').slideUp('normal');
		//alert('hi')
		 }else {
			 $(this).removeClass('subMenuOff');
			$(this).next('ul.leftNavigation').slideDown('normal');
		 }
});

});
