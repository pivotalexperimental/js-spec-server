var Require = {
  require: function(path_from_javascripts) {
    if(!Require.required_paths[path_from_javascripts]) {
      var full_path = path_from_javascripts + ".js?" + Require.cache_buster;
      document.write("<script src='" + full_path + "' type='text/javascript'></script>");
      Require.required_paths[path_from_javascripts] = true;
    }
  },

  required_paths: {},
  cache_buster: parseInt(new Date().getTime()/(1*1000))
}

var require = Require.require;

JSSpec.Logger.prototype.onRunnerEndWithoutServerNotification = JSSpec.Logger.prototype.onRunnerEnd;
JSSpec.Logger.prototype.onRunnerEndWithServerNotification = function() {
  this.onRunnerEndWithoutServerNotification();
  $.ajax({
    type: 'POST',
    url: '/results',
    data: {
      'text': "---------------------------------------------------------------------------------------\n\n+++++++++++++++++++++++++++++++++++++"
    }
  });  
}
JSSpec.Logger.prototype.onRunnerEnd = JSSpec.Logger.prototype.onRunnerEndWithServerNotification;