var projectJS = {
  find_in_hash: function (os, q){
      var ret = jQuery.grep(os, function(o, i) {
        return o.name == q;
      });
      return ret.length > 0;
    },

  filtero: function(projects, attr, value) {
      current_object = this; // save this for passing to find_in_hash
      return jQuery.grep(projects,
        function(p, i) {
           return current_object.find_in_hash(eval("p."+attr), value);
      })
    },
    
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
        o.push(current_object.filter_arr(projects, attr, value));
      else{
        console.log('o: ' + attr + ' value: ' + value);
        console.log(projects);
        var x = current_object.filter_str(projects, attr, value);
        o.push(x);
        console.log(x);
      }
        
    });
    if(o.length > 0)
      return o;
  },
  
  logProjects: function(projects){
    $.each(projects, function(ix, p){
      console.log(p);
      console.log(p[0]);
      console.log('Ttl: ' + p['slug']);
    });
  }

  // filter_disc: function(projects, attr, values) {
  //   current_object = this; // save this for passing to find_in_hash
  //   var o;
  //   
  //   $.each(values, function(ix, value) {
  // 
  //     if($.inArray(value, p.project_scope) != -1) return true;
  //   });
  // 
  // 
  //   return jQuery.grep(projects,
  //     function(p, i) {
  //       console.log('Project: ' + p.title + ' Scope: ' + p.project_scope);
  //       o = $.each(values, function(ix, value) {
  //         console.log(value);
  //         if($.inArray(value, p.project_scope) != -1) return true;
  //       });
  //       console.log("*****");
  //       console.log(o);
  //   });
  // }
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
    
    console.log('start all_projects.len: ' + all_projects.length);
    
    if(scopes.length > 0)
      scoped_prjs = projectJS.filter(all_projects, 'project_scope', scopes);
    else
      scoped_prjs = all_projects;
      
    //console.log('scoped_prjs');
    //console.log(scoped_prjs);
    
    if(cats.length > 0)
      category_prjs = projectJS.filter(scoped_prjs, 'categories', cats);
    else
      category_prjs = scoped_prjs;
    
    
   //   console.log('category_prjs');
  //  console.log(category_prjs);
    
    if(statuses.length > 0) {
      console.log('statuses.length: ' + statuses.length);
     // console.log(category_prjs);
      status_prjs = projectJS.filter(category_prjs, 'status', statuses);
  //    console.log('status_prjs');
  //    console.log(status_prjs);
    }
    else
      status_prjs = category_prjs
    
    console.log('end all_projects.len: ' + all_projects.length);
    
      
    console.log(status_prjs);
    return status_prjs;
  });
});