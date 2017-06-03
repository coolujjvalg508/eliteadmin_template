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
//= require select2

//= require tinymce


$(document).ready(function() {
	
	
	  tinymce.init({
			  
			  selector: '.tinymce',
			  height: 500,
			  width: 935,
			  themes: "modern",
			  menubar: false,
			  /*uploadimage_form_url : '/admin/images/saveimage',*/ /* uploadimage */
			  
			  plugins: [
				'advlist autolink lists link image charmap print preview anchor',
				'searchreplace visualblocks code fullscreen',
				'insertdatetime media table contextmenu paste code'
			  ],
			  toolbar: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | uploadimage | media | code'

	  });
	  
	  $('#news_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#download_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#gallery_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#job_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#static_page_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#faq_answer_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#tutorial_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#challenge_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#challenge_awards_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#challenge_terms_condition_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#challenge_terms_condition_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#challenge_judging_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#challenge_faq_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	  $('#job_apply_instruction_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	   $('#system_email_content_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
	   $('#contest_description_input').parent('div').css({'margin-left':'250px','margin-top': '28px'});
  
});

	$(document).on('click','.has_many_add',function(){
		 setTimeout(function(){  
			$(".chosen-input").chosen();
			$(".js-example-tags").select2({
				  tags: true
			});
		}, 500);

	});



$(document).ready(function() {

	type_value  =  $("#license_type_dropdown_download").val();
	if(type_value == 'Custom'){
		 $('#download_license_custom_info_input').show();
	}else{
		$('#download_license_custom_info_input').hide();

	}

	$('#license_type_dropdown_download').on('change',function(){
		type_value  =  $(this).val();
		if(type_value == 'Custom'){
				$('#download_license_custom_info_input').show();
		}else{
			$('#download_license_custom_info_input').hide();

		}

	});




	$(".js-example-tags").select2({
	  tags: true
	});



  $('#deletecomment').on('click',function(){
	  userid	=	$(this).attr('title');
		if(confirm("Are you sure you want to delete comment of this user?")){
			$.getJSON("/admin/users/deletecomment",{id: userid, ajax: 'true'}, function(response){
					alert('Comment has successfully deleted.');
					//return false;
					window.location.reload(true);
			})
		}else{
			return false;
		}
  }) 
	 
	 
  $('#userbanned').on('click',function(){
	  userid	=	$(this).attr('title');
		if(confirm("Are you sure you want to banned this user?")){
			$.getJSON("/admin/users/user_ban",{id: userid, ajax: 'true'}, function(response){
					alert('User has successfully restricted.');
					//return false;
					window.location.reload(true);
			})
		}else{
			return false;
		}
  })	
  
  
   $('#removebanned').on('click',function(){
	  userid	=	$(this).attr('title');
		if(confirm("Are you sure you want to permit this user?")){
			$.getJSON("/admin/users/remove_user_ban",{id: userid, ajax: 'true'}, function(response){
					alert('User has successfully permitted.');
					//return false;
					window.location.reload(true);
			})
		}else{
			return false;
		}
  })
   
  	 
	 
  $("#diplay-filter").html('Filter');
  /* jQuery('input.datepicker').datetimepicker({
		dateFormat: "dd-mm-yy",
  });
   */
   
  $(".chosen-input").chosen();
  
  $('#job_company_id').on('change',function(){
	 var value	=	$(this).val();
	  if(value == ''){
		   $("#job_company_attributes_name_input").css({'display':'block'});
	  }else{
		   $("#job_company_attributes_name_input").css({'display':'none'});
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
  
    $("#gallery_post_type_category_id").change(function(e){
		$.getJSON("/admin/subject_matters/categories",{id: $(this).val(), ajax: 'true'}, function(response){
			
		  var options = '';
		  for (var i = 0; i < response.length; i++) {
			options += '<option value="' + response[i][1]+ '">' + response[i][0] + '</option>';
		  }
		  $("select#gallery_subject_matter_id").html('');
		  $("select#gallery_subject_matter_id").append(options);
		  $('select#gallery_subject_matter_id').trigger('chosen:updated');

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
  
  
     //$('#gallery_publish').css({'display':'none'});
   $("#user_professional_experiences_attributes_0_company_id").change(function(e){
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('li#job_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#job_schedule_time_input').css({'display':'none'});
	 }
   })
  
  
  
    var mediafieldval1	=	$('#news_media_type').val();
	  if(mediafieldval1 == 0){
		   $('#news_video_input').css({'display':'block'});
		   $('#news_image_input').css({'display':'none'});
	  }else if(mediafieldval1 == 1){
		   $('#news_video_input').css({'display':'none'});
		   $('#news_image_input').css({'display':'block'});
	 }else{
		   $('#news_video_input').css({'display':'none'});
		   $('#news_image_input').css({'display':'none'});
		 
		 }
  
  $('#news_media_type').on('change',function(){
	  
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('#news_video_input').css({'display':'block'});
		   $('#news_image_input').css({'display':'none'});
	  }else if(fieldval1 == 1){
		   $('#news_video_input').css({'display':'none'});
		   $('#news_image_input').css({'display':'block'});
	 }else{
		   $('#news_video_input').css({'display':'none'});
		   $('#news_image_input').css({'display':'none'});
		 
		 }
	  
  })
  
  
	var fieldval	=	$('#tutorial_publish').val();
	  if(fieldval == 0){
		   $('li#tutorial_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#tutorial_schedule_time_input').css({'display':'none'});
	 }
  
  
    $("#tutorial_publish").change(function(e){
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('li#tutorial_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#tutorial_schedule_time_input').css({'display':'none'});
	 }
   })
  
  
  /*	if($("#tutorial_is_paid").prop('checked') == true){
			 $('li#tutorial_price_input').css({'display':'block'});
	}else{
		 $('li#tutorial_price_input').css({'display':'none'});
	}
		
  
   $("#tutorial_is_paid").on('click',function(e){
		  
		if($("#tutorial_is_paid").prop('checked') == true){
			 $('li#tutorial_price_input').css({'display':'block'});
		}else{
			 $('li#tutorial_price_input').css({'display':'none'});
		}
	})
	*/ 
	
	
	var fieldval	=	$('#news_publish').val();
	  if(fieldval == 0){
		   $('li#news_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#news_schedule_time_input').css({'display':'none'});
	 }
  
  
    $("#news_publish").change(function(e){
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('li#news_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#news_schedule_time_input').css({'display':'none'});
	 }
   })
  
  
  	if($("#news_is_paid").prop('checked') == true){
			 $('li#news_price_input').css({'display':'block'});
	}else{
		 $('li#news_price_input').css({'display':'none'});
	}
		
  
   $("#news_is_paid").on('click',function(e){
		  
		if($("#news_is_paid").prop('checked') == true){
			 $('li#news_price_input').css({'display':'block'});
		}else{
			 $('li#news_price_input').css({'display':'none'});
		}
		  

   })
  
  
  
  var fieldval	=	$('#download_publish').val();
	  if(fieldval == 0){
		   $('li#download_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#download_schedule_time_input').css({'display':'none'});
	 }
  
  
    $("#download_publish").change(function(e){
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('li#download_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#download_schedule_time_input').css({'display':'none'});
	 }
   })
  
  if($("#download_free").prop('checked') == false){
			$('#download_price').val(0)
			$('#download_price').css({'border':'1px solid #FF0000'});
			$('#download_price').attr({'disabled':false});
		}else{
			$('#download_price').val(0)
			$('#download_price').css({'border':'1px solid #c9d0d6'});
			$('#download_price').attr({'disabled':true});
		}
  
  $("#download_free").on('click',function(e){
		if($("#download_free").prop('checked') == false){
			$('#download_price').val(0)
			$('#download_price').css({'border':'1px solid #FF0000'});
			$('#download_price').attr({'disabled':false});
		}else{
			$('#download_price').val(0)
			$('#download_price').css({'border':'1px solid #c9d0d6'});
			$('#download_price').attr({'disabled':true});
		}
	})
  
  
  if($("#tutorial_free").prop('checked') == false){
			$('#tutorial_price').val(0)
			$('#tutorial_price').css({'border':'1px solid #FF0000'});
			$('#tutorial_price').attr({'disabled':false});
		}else{
			$('#tutorial_price').val(0)
			$('#tutorial_price').css({'border':'1px solid #c9d0d6'});
			$('#tutorial_price').attr({'disabled':true});
		}
  
  $("#tutorial_free").on('click',function(e){
		if($("#tutorial_free").prop('checked') == false){
			$('#tutorial_price').val(0)
			$('#tutorial_price').css({'border':'1px solid #FF0000'});
			$('#tutorial_price').attr({'disabled':false});
		}else{
			$('#tutorial_price').val(0)
			$('#tutorial_price').css({'border':'1px solid #c9d0d6'});
			$('#tutorial_price').attr({'disabled':true});
		}
	})
  
  
  
  
  
  /*************************************************************************************************************/
  
    $('#download_post_type_id').on('change',function(){
			post_type_ids	=	$(this).val();
			$.getJSON("/admin/downloads/post_types",{id: post_type_ids, ajax: 'true'}, function(response){
				
				  var options = '';
				  for (var i = 0; i < response.length; i++) {
					options += '<option value="' + response[i][1]+ '">' + response[i][0] + '</option>';
				  }
				  
				  $("select#download_post_type_category_id").html('');
				  $("select#download_post_type_category_id").append(options);
				  $('select#download_post_type_category_id').trigger('chosen:updated');				  
			}) 
			
	 })
 
 
	 $('#download_post_type_category_id').on('change',function(){
			post_type_category_ids	=	$(this).val();
			$.getJSON("/admin/downloads/post_category_types",{id: post_type_category_ids, ajax: 'true'}, function(response){
				
				  var options = '';
				  for (var i = 0; i < response.length; i++) {
					options += '<option value="' + response[i][1]+ '">' + response[i][0] + '</option>';
				  }
				  
				  $("select#download_sub_category_id").html('');
				  $("select#download_sub_category_id").append(options);
				  $('select#download_sub_category_id').trigger('chosen:updated');				  
			}) 
			
	 })
	 
	 
	 
	 $('#news_category_id').on('change',function(){
			category_ids	=	$(this).val();
			$.getJSON("/admin/news/get_sub_category",{id: category_ids, ajax: 'true'}, function(response){
				
				  var options = '';
				  for (var i = 0; i < response.length; i++) {
					options += '<option value="' + response[i][1]+ '">' + response[i][0] + '</option>';
				  }
				  
				  $("select#news_sub_category_id").html('');
				  $("select#news_sub_category_id").append(options);
				  $('select#news_sub_category_id').trigger('chosen:updated');				  
			}) 
			
	 })
  
  
	$('#tutorial_topic').on('change',function(){
			topic_ids	=	$(this).val();
			$.getJSON("/admin/tutorials/get_sub_topic",{id: topic_ids, ajax: 'true'}, function(response){
				
				  var options = '';
				  for (var i = 0; i < response.length; i++) {
					options += '<option value="' + response[i][1]+ '">' + response[i][0] + '</option>';
				  }
				  
				  $("select#tutorial_sub_topic").html('');
				  $("select#tutorial_sub_topic").append(options);
				  $('select#tutorial_sub_topic').trigger('chosen:updated');				  
			}) 
			
	 })
  
  
  
  
    var fieldval	=	$('#challenge_publish').val();
	  if(fieldval == 0){
		   $('li#challenge_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#challenge_schedule_time_input').css({'display':'none'});
	 }
  
  
    $("#challenge_publish").change(function(e){
	  var fieldval1	=	$(this).val();
	  if(fieldval1 == 0){
		   $('li#challenge_schedule_time_input').css({'display':'block'});
	  }else{
		  $('li#challenge_schedule_time_input').css({'display':'none'});
	 }
   })
  
  
  
	var fieldval	=	$('#job_apply_type').val();
	   if(fieldval == 'email'){
			   $('li#job_apply_email_input').css({'display':'block'});
			   $('li#job_apply_url_input').css({'display':'none'});
			   $('li#job_apply_instruction_input').css({'display':'none'});
		  }else  if(fieldval == 'url'){
			   $('li#job_apply_email_input').css({'display':'none'});
			   $('li#job_apply_url_input').css({'display':'block'});
			   $('li#job_apply_instruction_input').css({'display':'none'});
		 
		  }else  if(fieldval == 'instruction'){
			   $('li#job_apply_email_input').css({'display':'none'});
			   $('li#job_apply_url_input').css({'display':'none'});
			   $('li#job_apply_instruction_input').css({'display':'block'});
		  
		  }else{
			  $('li#job_apply_email_input').css({'display':'none'});
			   $('li#job_apply_url_input').css({'display':'none'});
			   $('li#job_apply_instruction_input').css({'display':'none'});
		 }
  
  
    $("#job_apply_type").change(function(e){
	  var fieldval1	=	$(this).val();
		  if(fieldval1 == 'email'){
			   $('li#job_apply_email_input').css({'display':'block'});
			   $('li#job_apply_url_input').css({'display':'none'});
			   $('li#job_apply_instruction_input').css({'display':'none'});
		  }else  if(fieldval1 == 'url'){
			   $('li#job_apply_email_input').css({'display':'none'});
			   $('li#job_apply_url_input').css({'display':'block'});
			   $('li#job_apply_instruction_input').css({'display':'none'});
		 
		  }else  if(fieldval1 == 'instruction'){
			   $('li#job_apply_email_input').css({'display':'none'});
			   $('li#job_apply_url_input').css({'display':'none'});
			   $('li#job_apply_instruction_input').css({'display':'block'});
		  
		  }else{
			  $('li#job_apply_email_input').css({'display':'none'});
			   $('li#job_apply_url_input').css({'display':'none'});
			   $('li#job_apply_instruction_input').css({'display':'none'});
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


