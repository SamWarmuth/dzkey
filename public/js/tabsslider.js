//slideshow_fnc

var slideTimeout = 4000;


function prevSlide(){

	var $next1 = $('.latest_project .project div.displayslide');

	nextnumber = parseInt($next1[0].id.substring(5,6));

	nextnumber--;
	if (nextnumber<1) nextnumber = 5;

	changeSlide2this(nextnumber);

}

function nextSlide(){

	var $next1 = $('.latest_project .project div.displayslide');

	nextnumber = parseInt($next1[0].id.substring(5,6));

	nextnumber++;
	if (nextnumber>5) nextnumber = 1;

	changeSlide2this(nextnumber);

}

function changeSlide2this(number){
	var maxnumber = 5;

	var $active1 = $('.latest_project .project div.displayslide');

	var $next1 = $('#slide'+number);

	$active1.addClass('last-active');




		nextnumber = parseInt($next1[0].id.substring(5,6));

		chengeSlideTab2this(nextnumber);



		if (1)
		{
			inanimation = true;

			$active1.css({opacity: 1.0})

			$next1.css({opacity: 0.0});

			$active1
				.removeClass('displaynone')
				.addClass('displayslide')
				.animate({opacity: 0.0}, 500, function() {
					if(!lockslide)
					{
					 $active1.removeClass('displayslide');
					 $active1.addClass('displaynone');
					

					 $next1.css({opacity: 0.0})
						.removeClass('displaynone')
						.addClass('displayslide')


					 jQuery('.parallax').jparallax({});

					 $next1.animate({opacity: 1.0}, 500, function() {
							if(!lockslide)
							{
								

							}
							lockslide=false;
							inanimation = false;

						});

					}
					lockslide=false;
					inanimation = false;
				});

			
		}
/*
	if(inanimation) lockslide = true;

	if(number == 5 && inanimation){
		$('#slide5').stop().css({opacity:1.0});
		
	}
//	jQuery('.parallax').jparallax({});
	clearInterval(slideTimer);
    slideTimer = setInterval( "slideSwitch()", slideTimeout );	
	*/
}

function chengeSlideTab2this(number){
	var maxnumber = 5;
	for(i =1;i<=maxnumber;i++)
	{
		if (number == i)
		{
			$('#slide-tab'+i)[0].className = 'active';
		}else{
			$('#slide-tab'+i)[0].className = '';
		}
	}
}

var lockslide = false;
var slideTimer = null;
var inanimation = false;
var slideshow = true;

$(document).ready(function() {
	slideTimer =setInterval( "slideSwitch()", slideTimeout );
	setSlidePause();
	preloadSlide();

//	if (jQuery.browser.msie)
//	{
//		var conss = document.createElement('div');
//		conss.setAttribute('style','position:absolute;background:#fff;left:0px;top:0px');
//		conss.setAttribute('id','consolelog');
//		conss.appendChild(document.createTextNode('debug:'));
//		$('#all')[0].appendChild(conss);
//		console = { log:function log(arg){
//				$('#consolelog')[0].innerHTML += arg+'<br/>';
//		   }
//		}
//	}


});

function preloadSlide() {
	$.preloadImages(
		'../images/page.png',
		"../images/selected_page.png");
}

jQuery.preloadImages = function()
{
  for(var i = 0; i<arguments.length; i++)
  {
    jQuery("<img>").attr("src", arguments[i]);
  }
}


function slideSwitch() {
	if (slideshow)
	{
		var $active1 = $('.latest_project .project div.displayslide');
		var lastone1 = false;


		if ( $active1.length == 0 ) {$active1 = $('.latest_project .project div.tabb:last'); }


		var $next1 =  $active1.next().length ? $active1.next()
			: $('.latest_project .project div.tabb:first');

		if (!$active1.next().length )	 lastone1 = true;


		$active1.addClass('last-active');

		nextnumber = parseInt($next1[0].id.substring(5,6));

		chengeSlideTab2this(nextnumber);



		if (1)
		{
			inanimation = true;

			$active1.css({opacity: 1.0})

			$next1.css({opacity: 0.0});

			$active1
				.removeClass('displaynone')
				.addClass('displayslide')
				.animate({opacity: 0.0}, 500, function() {
					if(!lockslide)
					{
					 $active1.removeClass('displayslide');
					 $active1.addClass('displaynone');
					

					 $next1.css({opacity: 0.0})
						.removeClass('displaynone')
						.addClass('displayslide')


					 jQuery('.parallax').jparallax({});

					 $next1.animate({opacity: 1.0}, 500, function() {
							if(!lockslide)
							{
								

							}
							lockslide=false;
							inanimation = false;

						});

					}
					lockslide=false;
					inanimation = false;
				});

			
		}/*else{
			$next1.removeClass('displaynone')
					.addClass('displayslide');

			inanimation = true;
			$active1.css({opacity: 1.0})
				.animate({opacity: 0.0}, 1000, function() {
					if(!lockslide)
					{
						$active1.css({opacity: 1.0});
						$active1.removeClass('displayslide last-active');
						$active1.addClass('displaynone');
					}else{
						$active1.css({opacity: 1.0});
					}
					lockslide=false;
					inanimation = false;
				});
		}*/
	}
}


function setSlidePause(){
	var maxnumber = 5;
	for(i =1;i<=maxnumber;i++)
	{
		$('#slide'+i).mouseenter(
			function() {
				clearInterval(slideTimer);
//				console.log('stoped');
			}
		);
		$('#slide'+i).mouseleave(
			function() { 
				clearInterval(slideTimer);
				slideTimer = setInterval( "slideSwitch()", slideTimeout );
//				console.log('started');
			}
		);
	}
	$('.sec_menu').mouseenter(
				function() {
			clearInterval(slideTimer);
//			console.log('stoped');
		}
	);
	$('.sec_menu').mouseleave(
		function() { 
			clearInterval(slideTimer);
			slideTimer = setInterval( "slideSwitch()", slideTimeout );
//			console.log('started');
		}
	);


}