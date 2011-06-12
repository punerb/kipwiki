var projectJS = {
  filter_str: function(projects, attr, value) {
     return jQuery.grep(projects,
        function(p, i) {
           return value == eval('p.'+attr);
      })
    },

  filter_arr: function(projects, attr, value) {
      current_object = this; // save this for passing to find_in_hash

      return jQuery.grep(projects,
        function(p, i) {
           return (jQuery.inArray(value, eval('p.'+attr)) != -1);
      })
    },


  filter: function(projects, attr, values) {
    current_object = this; // save this for passing to find_in_hash
    var o = [];

    $.each(values, function(ix, value) {
      if(attr == 'categories')
        current_object.push_individual(o, current_object.filter_arr(projects, attr, value));
      else
        current_object.push_individual(o, current_object.filter_str(projects, attr, value));
    });
    return o;
  },
  
  push_individual: function(o, arr) {
    $.each(arr, function(ix, a){
      o.push(a);
    });
  },

	render_projects: function(projects){
		$('#project_list').children().hide();
		$.each(projects, function(index, project){
				console.log('#project_' + project['_id']);
				$('#project_' + project['_id']).show();
		});
		 
	}
}



$(document).ready(function(){
   var cats = []; 
   var scopes = [];
   var statuses = [];
	 $.each(all_projects, function(index, project){
     
		  if(project['categories'] != undefined){
				$.each(project['categories'], function(index,category){
					cats.push(category.replace(/\W+/, ''));
				});
			}

			if(project['status'] != undefined){
				statuses.push(project['status']);
			}

			if(project['project_scope'] != undefined){
				scopes.push(project['project_scope']);
			}

	});
	
	 $.each(cats, function(index,category){
		 $('#'+category).attr('checked', true);
	 });

	 $.each(scopes, function(index,scope){
		 $('#'+ scope).attr('checked', true);
	 });

	 $.each(statuses, function(index, stat){
		 $('#'+ stat).attr('checked', true);
	 });
 

  $('.filter').click(function(){
    var cats = $('.category').filter(":checked").map(function(){ return $(this).val(); });
    var scopes = $('.scope').filter(":checked").map(function(){ return $(this).val(); });
    var statuses = $('.status').filter(":checked").map(function(){ return $(this).val(); });
    
    var scoped_prjs, category_prjs, status_prjs;
    
    if(scopes.length > 0)
      scoped_prjs = projectJS.filter(all_projects, 'project_scope', scopes);
    else
      scoped_prjs = all_projects;
    
    if(cats.length > 0)
      category_prjs = projectJS.filter(scoped_prjs, 'categories', cats);
    else
      category_prjs = scoped_prjs;
    
    if(statuses.length > 0)
      status_prjs = projectJS.filter(category_prjs, 'status', statuses);
    else
      status_prjs = category_prjs
    
    console.log(status_prjs);
		projectJS.render_projects(status_prjs);
    return status_prjs;
  });
});


