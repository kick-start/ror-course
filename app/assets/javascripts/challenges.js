//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(function(){
	$(document).on('change', '#question_type', function(){
		$.get('/challenges/new?type='+$(this).val(), function(data){
			//alert(data);
			$('form').replaceWith(data);
		});
	})
});