var Require = {
  require: function(path_from_javascripts) {
    if(!Require.required_paths[path_from_javascripts]) {
      var full_path = path_from_javascripts + ".js";
      if (Require.use_cache_buster) {
        full_path += '?' + Require.cache_buster;
      }
      document.write("<script src='" + full_path + "' type='text/javascript'></script>");
      Require.required_paths[path_from_javascripts] = true;
    }
  },

  required_paths: {},
  use_cache_buster: true, // TODO: NS/CTI - make this configurable from the UI.
  cache_buster: parseInt(new Date().getTime()/(1*1000))
}
var require = Require.require;

var URL_REGEX = /^((\w+):\/\/)(([^:]+):?([^@]+)?@)?([^\/\?:]*):?(\d+)?(\/?[^\?#]+)?\??([^#]+)?#?(.+)?/;
function parse_url(url) {
    var fields = ['url', null, 'protocol', null, 'username', 'password', 'host', 'port', 'pathname', 'search', 'hash'];
    var result = URL_REGEX.exec(url);
    if (!result) {
        throw new SeleniumError("Invalid URL: " + url);
    }
    var loc = new Object();
    for (var i = 0; i < fields.length; i++) {
        var field = fields[i];
        if (field == null) {
            continue;
        }
        loc[field] = result[i];
    }
    return loc;
}

JSSpec.Logger.prototype.onRunnerEndWithoutServerNotification = JSSpec.Logger.prototype.onRunnerEnd;
JSSpec.Logger.prototype.onRunnerEndWithServerNotification = function() {
  this.onRunnerEndWithoutServerNotification();
  var data = {
    'text': this.get_error_message_text(),
    'guid': 'foobar'
  };

  // current_location_params = parse_url(window.location.href);
  // if(current_location_params.guid) {
  //   data.guid = 'foobar'; // current_location_params.guid;
  // }
  jQuery.realAjax({
    type: 'POST',
    url: '/suites/1/finish',
    data: data
  });
}
JSSpec.Logger.prototype.onRunnerEnd = JSSpec.Logger.prototype.onRunnerEndWithServerNotification;

JSSpec.Logger.prototype.get_error_message_text = function() {
  var error_messages = [];
  for(var i=0; i < JSSpec.specs.length; i++) {
    var spec = JSSpec.specs[i];
    if(spec.hasException()) {
      for(var j=0; j < spec.getExamples().length; j++) {
        var example = spec.getExamples()[j];
        var error_message = spec.context + " " + example.name;
        if (example.exception) {
          error_message += "\n" + example.exception.message + "\n" + example.exception.fileName + ":" + example.exception.lineNumber;
        }
        error_messages.push(error_message);
      }
    }
  }

  var full_error_text = error_messages.join("\n");
  full_error_text = full_error_text.replace(/<\/p>/g, "\n");
  full_error_text = full_error_text.replace(/<(.|\n)*?>/g, "");
  return full_error_text;
}

// Custom Matchers

JSSpec.DSL.Subject.prototype.should_be_disabled = function() {
  if (!this.target.disabled) {
    JSSpec._assertionFailure = {message: "Element " + JSSpec.util.inspect(this.target) + " should have been disabled"};
    throw JSSpec._assertionFailure;
  }
};

JSSpec.DSL.Subject.prototype.should_be_enabled = function() {
  if (this.target.disabled) {
    JSSpec._assertionFailure = {message: "Element " + JSSpec.util.inspect(this.target) + " should have been enabled"};
    throw JSSpec._assertionFailure;
  }
};

JSSpec.DSL.Subject.prototype.should_raise = function(expected) {
  if("function" != typeof(this.target)) {
    JSSpec._assertionFailure = {message: 'should_raise expects value_of(target) to have a target that is a function'};
    throw JSSpec._assertionFailure;
  }

  var raised = false;
  try {
    this.target();
  }
  catch(e) {
    if (expected == null || expected == e) {
      raised = true;
    }
  }
  if(!raised) {
    var message = "should have raised an error but didn't";
    if(expected) {
      message = "should have raised '" + expected + "' but didn't";
    }
    JSSpec._assertionFailure = {message: message};
    throw JSSpec._assertionFailure;
  }
}

JSSpec.DSL.Subject.prototype.should_not_raise = function(expected) {
  if("function" != typeof(this.target)) {
    JSSpec._assertionFailure = {message: 'should_not_raise expects value_of(target) to have a target that is a function'};
    throw JSSpec._assertionFailure;
  }

  var raised = false;
  try {
    this.target();
  }
  catch(e) {
    if (expected == null || expected == e) {
      raised = true;
    }
  }
  if(raised) {
    var message = "should not have raised an error but did";
    if(expected) {
      message = "should not have raised '" + expected + "' but did";
    }
    JSSpec._assertionFailure = {message: message};
    throw JSSpec._assertionFailure;
  }
}




