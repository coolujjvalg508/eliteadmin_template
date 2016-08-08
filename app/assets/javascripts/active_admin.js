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
