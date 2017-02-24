// Custom Js 
 $(document).ready(function(){

 		
    $(".custom-select").each(function(){
        $(this).wrap("<span class='select-wrapper'></span>");
        $(this).after("<span class='holder'></span>");
    });
    
    $(".custom-select").change(function(){
        var selectedOption = $(this).find(":selected").text();
        $(this).next(".holder").text(selectedOption);
    }).trigger('change');

    setTimeout(function() {
		$(".custom-select").each(function(){
	        var selectedOption = $(this).find(":selected").text();
	        $(this).next(".holder").text(selectedOption);
	    });
	}, 1000);

	/* $('.responsive').slick({
		  dots: true,
		  infinite: false,
		  speed: 300,
		  slidesToShow: 4,
		  slidesToScroll: 4,
		  responsive: [
			{
			  breakpoint: 1024,
			  settings: {
				slidesToShow: 3,
				slidesToScroll: 3,
				infinite: true,
				dots: true
			  }
			},
			{
			  breakpoint: 600,
			  settings: {
				slidesToShow: 2,
				slidesToScroll: 2
			  }
			},
			{
			  breakpoint: 480,
			  settings: {
				slidesToShow: 1,
				slidesToScroll: 1
			  }
			}
		  ]
	}); */
		
		
})
.on('change', '.custom-select', function(){
	var selectedOption = $(this).find(":selected").text();
    $(this).next(".holder").text(selectedOption);
}); 
// Slick Slider JS

 
;
