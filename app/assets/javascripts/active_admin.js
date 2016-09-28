//= require active_admin/base
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap
//= require bootsy
//= require jquery-ui-timepicker-addon
//= require active_admin_flat_skin
//= require marmoset
//= require sketchfab-viewer-1.0.0
//= require active_admin_datetimepicker
//= require chosen-jquery

$(document).ready(function() {
	
	
  $("#diplay-filter").html('Filter');
  /* jQuery('input.datepicker').datetimepicker({
		dateFormat: "dd-mm-yy",
  });
   */
   
   $(".chosen-input").chosen();
  
  
  $('#job_company_id').on('change',function(){
	 var value	=	$(this).val();
	  if(value == ''){
		   $("#job_company_attributes_name").attr('readonly',false);
	  }else{
		   $("#job_company_attributes_name").attr('readonly',true);
	   }
	  
  })
  
   
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='file'][id^=gallery_images_attributes_][id$=_image]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide();
    }
  });
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='file'][id^=gallery_images_attributes_][id$=_image]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show();
    }
  });

 $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='text'][id^=gallery_videos_attributes_][id$=_video]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide();
    }
  });
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='text'][id^=gallery_videos_attributes_][id$=_video]").length <= 20)
    {
		$("li.has_many_container a.has_many_add").show();
    }
  });



 $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='file'][id^=gallery_upload_videos_attributes_][id$=_uploadvideo]").length >= 19)
    {
		$("li.has_many_container a.has_many_add").hide();
    }
  });
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='file'][id^=gallery_upload_videos_attributes_][id$=_uploadvideo]").length <= 20)
    {
		$("li.has_many_container a.has_many_add").show();
    }
  });






 $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='text'][id^=gallery_sketchfebs_attributes_][id$=_sketchfeb]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide();
    }
  });
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='text'][id^=gallery_sketchfebs_attributes_][id$=_sketchfeb]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show();
    }
  });

 $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='file'][id^=gallery_marmo_sets_attributes_][id$=_marmoset]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide();
    }
  });
  
  $('form#new_gallery, form#edit_gallery').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='file'][id^=gallery_marmo_sets_attributes_][id$=_marmoset]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show();
    }
  });

   var gallery_post_type_category_id = $("#gallery_post_type_category_id").val();
   $.getJSON("/admin/subject_matters/categories",{id: gallery_post_type_category_id, ajax: 'true'}, function(response){
			
		  var options = '';
		  for (var i = 0; i < response.length; i++) {
			options += '<option value="' + response[i][1]+ '">' + response[i][0] + '</option>';
		  }
		 $("select#gallery_subject_matter_id").html('<option value="">Select Subject Matter</option>'+options);
		 $('#gallery_subject_matter_id option[value='+gallery_post_type_category_id+']').attr('selected', true);
	 })
  
    $("#gallery_post_type_category_id").change(function(e){
		$.getJSON("/admin/subject_matters/categories",{id: $(this).val(), ajax: 'true'}, function(response){
			
		  var options = '';
		  for (var i = 0; i < response.length; i++) {
			options += '<option value="' + response[i][1]+ '">' + response[i][0] + '</option>';
		  }
		
		  $("select#gallery_subject_matter_id").html('<option>Select Subject Matter</option>'+options);
	 })
  })
  
	var fieldval	=	$('#gallery_publish').val();
	  if(fieldval == 0){
		   $('li#gallery_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#gallery_schedule_time_input').css({'display':'none'});
	 }
  

   //$('#gallery_publish').css({'display':'none'});
   $("#gallery_publish").change(function(e){
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('li#gallery_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#gallery_schedule_time_input').css({'display':'none'});
	 }
  })
  
  
  
  
  
  $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='file'][id^=job_images_attributes_][id$=_image]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide()
    }
  });
  
  $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='file'][id^=job_images_attributes_][id$=_image]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show()
    }
  });

 $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='text'][id^=job_videos_attributes_][id$=_video]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide()
    }
  });
  
  $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='text'][id^=job_videos_attributes_][id$=_video]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show()
    }
  });



 $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='file'][id^=job_upload_videos_attributes_][id$=_uploadvideo]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide()
    }
  });
  
  $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='file'][id^=job_upload_videos_attributes_][id$=_uploadvideo]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show()
    }
  });

 $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='text'][id^=job_sketchfebs_attributes_][id$=_sketchfeb]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide()
    }
  });
  
  $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='text'][id^=job_sketchfebs_attributes_][id$=_sketchfeb]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show()
    }
  });

 $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_add', function() {
	  
    if($("input[type='file'][id^=job_marmo_sets_attributes_][id$=_marmoset]").length >= 19)
    {
      $("li.has_many_container a.has_many_add").hide()
    }
  });
  
  $('form#new_job, form#edit_job').on('click', 'li.has_many_container a.has_many_remove', function() {
    if($("input[type='file'][id^=job_marmo_sets_attributes_][id$=_marmoset]").length <= 20)
    {
      $("li.has_many_container a.has_many_add").show()
    }
  });
  
  
  var fieldval	=	$('#job_publish').val();
	  if(fieldval == 0){
		   $('li#job_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#job_schedule_time_input').css({'display':'none'});
	 }
  

   //$('#gallery_publish').css({'display':'none'});
   $("#job_publish").change(function(e){
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('li#job_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#job_schedule_time_input').css({'display':'none'});
	 }
   })
  
  
  
  
  
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


