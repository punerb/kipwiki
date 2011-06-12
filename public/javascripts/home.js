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
  }
}



$(document).ready(function(){
  Array.prototype.flatten = function flatten(){
     var flat = [];
     for (var i = 0, l = this.length; i < l; i++){
         var type = Object.prototype.toString.call(this[i]).split(' ').pop().split(']').shift().toLowerCase();
         if (type) { flat = flat.concat(/^(array|collection|arguments|object)$/.test(type) ? flatten.call(this[i]) : this[i]); }
     }
     return flat;
  };
  
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
    return status_prjs;
  });
});