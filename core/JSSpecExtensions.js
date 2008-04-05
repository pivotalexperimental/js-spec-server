function Spec() {
}

Spec.register = function(spec_constructor) {
  spec_constructor.describe = function(context, definition) {
    var custom_before = definition['before each'];
    if(custom_before) {
      definition['before each'] = function() {
        if(spec_constructor['before each']) spec_constructor['before each']();
        custom_before();
      }
    } else {
      definition['before each'] = function() {
        if(spec_constructor['before each']) spec_constructor['before each']();
      };
    }

    var custom_after = definition['after each'];
    if(custom_after) {
      definition['after each'] = function() {
        custom_after();
        if(spec_constructor['after each']) spec_constructor['after each']();
        Spec.reset();
      }
    } else {
      definition['after each'] = function() {
        if(spec_constructor['after each']) spec_constructor['after each']();
        Spec.reset();
      }
    }
    new spec_constructor();
    describe(spec_constructor.name.toString() + context.toString(), definition);
  }
}

Spec.reset = function() {}

var Assets = {
  require: function(path_from_javascripts, onload) {
    if(!Assets.required_paths[path_from_javascripts]) {
      var full_path = path_from_javascripts + ".js";
      if (Assets.use_cache_buster) {
        full_path += '?' + Assets.cache_buster;
      }
      document.write("<script src='" + full_path + "' type='text/javascript'></script>");
      if(onload) {
        var scripts = document.getElementsByTagName('script');
        scripts[scripts.length-1].onload = onload;
      }
      Assets.required_paths[path_from_javascripts] = true;
    }
  },

  stylesheet: function(path_from_stylesheets) {
    if(!Assets.included_stylesheets[path_from_stylesheets]) {
      var full_path = path_from_stylesheets + ".css";
      if(Assets.use_cache_buster) {
        full_path += '?' + Assets.cache_buster;
      }
      document.write("<link rel='stylesheet' type='text/css' href='" + full_path + "' />");
      Assets.included_stylesheets[path_from_stylesheets] = true;
    }
  },

  required_paths: {},
  included_stylesheets: {},
  use_cache_buster: false, // TODO: NS/CTI - make this configurable from the UI.
  cache_buster: parseInt(new Date().getTime()/(1*1000))
}
var require = Assets.require;
var stylesheet = Assets.stylesheet;

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
  var xml = window.ActiveXObject ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();
  xml.open("POST", '/suites/1/finish', true);
  xml.setRequestHeader("X-Requested-With", "XMLHttpRequest");
  var body = [];
  var href = window.location.href;
  var params = href.split("?")[1].split("&");
  for(var i=0; i < params.length; i++) {
    var param = params[i];
    if(param.match(/^guid=/)) {
      body.push(encodeURIComponent("guid") + "=" + encodeURIComponent( param.split('=')[1] ));
    }
  }
  body.push(encodeURIComponent("text") + "=" + encodeURIComponent( this.get_error_message_text() ));
  xml.send(body.join("&"));
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
