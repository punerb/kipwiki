jQuery(document).ready(function() {
    var input = $('#search_location');
    if(input.val().length == 0){
    input.val(placeholder);
    }     
    input.focus(function(){
      if(input.val() == 'Search') input.val('');
      }).blur(function(){
        if( $.trim(input.val()).length == 0 ) input.val('Search');
        });    
});   
