$(function () {
	
	if ( !($.browser.msie && $.browser.version < 7) ) {
	
		$.sifr({path:'js/fonts'});
				
		$('.frame #header h2').sifr({font:'nevis', textTransform:'uppercase'});
		$('.frame #header h3').sifr({font:'nevis', textTransform:'uppercase'});
		$('.article h3').sifr({font:'nevis', textTransform:'uppercase'});
		$('.gallery-container h3').sifr({font:'nevis', textTransform:'uppercase'});
		$('.contact-form .bottom h3').sifr({font:'nevis', textTransform:'uppercase'});
		$('.sidebar-form .bottom h3').sifr({font:'nevis', textTransform:'uppercase'});
		$('.buttons a').sifr({font:'nevis', textTransform:'uppercase'});
		$('.box .link p').sifr({font:'nevis'});
		$('.shell h2').sifr({font:'nevis', textTransform:'uppercase' });
		<!--$('.heading h3 span').sifr({font:'sifr'});
		<!-- $('#navigation li a').sifr({font:'nevis', hover:'#58b12f', textTransform:'uppercase'});
		<!-- $('#login-nav li a.login').sifr({font:'nevis', hover:'#2e790b', textTransform:'uppercase'});
		<!-- $('#login-nav li a.signup').sifr({font:'nevis', hover:'#2e790b', textTransform:'uppercase'});
		<!-- $('#footer li a').sifr({font:'nevis', textTransform:'uppercase', hover: '#c9e5c0'});
	}else {
		$('head').append('<link rel="stylesheet" href="css/ie6.css" type="text/css" media="all" />');
	}
});