
var projectJS = {
  find_in_hash: function (os, q){
      var ret = jQuery.grep(os, function(o, i) {
        return o.name == q;
      });
      return ret.length > 0;
    },

  filter: function(projects, attr, value) {
      current_object = this; // save this for passing to find_in_hash
      return jQuery.grep(projects,
        function(p, i) {
           return current_object.find_in_hash(eval("p."+attr), value);
      })
    }
}

