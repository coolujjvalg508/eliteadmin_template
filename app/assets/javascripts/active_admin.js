//= require active_admin/base
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require bootsy
//= require jquery-ui-timepicker-addon


$(document).ready(function() {

  jQuery('input.datepicker').datetimepicker({
    dateFormat: "dd-mm-yy",
  });
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='file'][id^=gallery_images_attributes_][id$=_image]").length >= 9)
    {
      $("li.has_many_container a.has_many_add").hide()
    }
  });
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='file'][id^=gallery_images_attributes_][id$=_image]").length <= 10)
    {
      $("li.has_many_container a.has_many_add").show()
    }
  });









  
  
/*
  // Admin email messages and notifications count as sub menu of the admin user
  $.ajax({
    type: "GET",
    url: "/admin/super_admins/notifications" ,
    success: function(data){
		//console.log("admin sub menu")
    }
  });
 */
});


