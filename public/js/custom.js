jQuery(document).ready(function(){
	//tfuse_form(); //controls the contact form locatet in frameork/functons/sendmail.js
	tfuse_custom_form();
});

function tfuse_custom_form(){
	var my_error;
	//var url = jQuery("input[name=temp_url]").attr('value');
	jQuery(".ajax_form #send").bind("click", function(){
		
	my_error = false;
	jQuery(".ajax_form input, .ajax_form textarea, .ajax_form radio, .ajax_form select").each(function(i)
	{
				var surrounding_element = jQuery(this).parent();
				var value 				= jQuery(this).attr("value"); 
				var check_for 			= jQuery(this).attr("id");
				var required 			= jQuery(this).hasClass("required"); 

				if(check_for == "email"){
					surrounding_element.removeClass("error valid");
					baseclases = surrounding_element.attr("class");
					if(!value.match(/^\w[\w|\.|\-]+@\w[\w|\.|\-]+\.[a-zA-Z]{2,4}$/)){
						surrounding_element.attr("class",baseclases).addClass("error");
						my_error = true;
					}else{
						surrounding_element.attr("class",baseclases).addClass("valid");	
					}
				}
				
				if(check_for == "message"){
					surrounding_element.removeClass("error valid");
					baseclases = surrounding_element.attr("class");
					if(value == ""){					
						surrounding_element.attr("class",baseclases).addClass("error");
						my_error = true;
					}else{
						surrounding_element.attr("class",baseclases).addClass("valid");	
					}
				}
				
				if(required && check_for != "email" && check_for != "message"){
					surrounding_element.removeClass("error valid");
					baseclases = surrounding_element.attr("class");
					if(value == ""){					
						surrounding_element.attr("class",baseclases).addClass("error");
						my_error = true;
					}else{
						surrounding_element.attr("class",baseclases).addClass("valid");	
					}
				}
				
	
			   if(jQuery(".ajax_form input, .ajax_form textarea, .ajax_form radio, .ajax_form select").length  == i+1){
					if(my_error == false){
						jQuery(".ajax_form").slideUp(400);
						
						var $datastring = "ajax=true";
						jQuery(".ajax_form input, .ajax_form textarea, .ajax_form radio, .ajax_form select").each(function(i)
						{
							var $name = jQuery(this).attr('name');	
							var $value = encodeURIComponent(jQuery(this).attr('value'));
							$datastring = $datastring + "&" + $name + "=" + $value;
						});
															
						
						jQuery(".ajax_form #send").fadeOut(100);	
						
						jQuery.ajax({
						   type: "POST",
						   url: "./sendmail.php",
						   data: $datastring,
						   success: function(response){
						   jQuery(".ajax_form").before("<div class='ajaxresponse' style='display: none;'></div>");
						   jQuery(".ajaxresponse").html(response).slideDown(400); 
						   jQuery(".ajax_form #send").fadeIn(400);
						   jQuery(".ajax_form input, .ajax_form textarea, .ajax_form radio, .ajax_form select").val("");
							   }
							});
						} 
				}
			   
			});
			return false;
	});
}




function dropdown_menu()
{
	jQuery("#nav a, .subnav a");
	jQuery(" #nav ul ").css({display: "none", opacity:"0.90"}); // fix for opera browser
	
	jQuery("#nav li").each(function()
	{	
		
		var $sublist = jQuery(this).find('ul:first');
		
		jQuery(this).hover(function()
		{	
			$sublist.stop().css({overflow:"hidden", height:"auto", display:"none"}).slideDown(200, function()
			{
				jQuery(this).css({overflow:"visible", height:"auto"});
			});	
		},
		function()
		{	
			$sublist.stop().slideUp(250, function()
			{	
				jQuery(this).css({overflow:"hidden", display:"none"});
			});
		});	
	});
}
