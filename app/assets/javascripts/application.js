// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require bootstrap-datetimepicker
//= require wow.min
//= require slick
//= require jquery.bootstrap-responsive-tabs.min
//= require pgwslideshow
//= require select2
//= require custom
//= require marmoset
//= require dropzone

//= require tether.min
//= require cropper
//= require jquery-ui-1.10.3.custom.min
//= require angular
//= require dirPagination
//= require angular-lazy-img
//= require moment-with-locales
//= require ui-bootstrap-tpls
//= require datetime-picker
//= require ng-dropzone






// require turbolinks
// require_tree .
// require bootstrap
// require chosen-jquery
// require bootsy
// require bootstrap-datetimepicker
// require scaffold
//= require tinymce

$(document).ready(function(){
  	$(".alert").fadeIn();
  	$(".alert").fadeOut(10000);

  	$ (".js-chosen-select-tags") .select2({
		tags: true
	});

	$ (".js-chosen-select-multi") .select2({
		tags: false
	});

	tinymce.init({
			  
			  selector: '.tinymce',
			  height: 300,
			  width: 935,
			  themes: "modern",
			  menubar: false,
			  /*uploadimage_form_url : '/admin/images/saveimage',*/ /* uploadimage */
			  
			  plugins: [
				'advlist autolink lists link image charmap print preview anchor',
				'searchreplace visualblocks code fullscreen',
				'insertdatetime media table contextmenu paste code'
			  ],
			  toolbar: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | uploadimage | media | code',
			   

	  });





});  