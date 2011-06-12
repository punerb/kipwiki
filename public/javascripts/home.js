function find_in_hash(os, q){
  var ret = jQuery.grep(os, function(o, i){
    return o.name == q;
  });
  return ret.length > 0;
}
    
jQuery.grep(projects,
  function(p, i) {
     return find_in_hash(p.project_types, 'Property1');
})
