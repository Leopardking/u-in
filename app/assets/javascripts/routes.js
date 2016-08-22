(function() {
  var NodeTypes, ParameterMissing, Utils, createGlobalJsRoutesObject, defaults, root,
    __hasProp = {}.hasOwnProperty;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  ParameterMissing = function(message) {
    this.message = message;
  };

  ParameterMissing.prototype = new Error();

  defaults = {
    prefix: "",
    default_url_options: {}
  };

  NodeTypes = {"GROUP":1,"CAT":2,"SYMBOL":3,"OR":4,"STAR":5,"LITERAL":6,"SLASH":7,"DOT":8};

  Utils = {
    serialize: function(object, prefix) {
      var element, i, key, prop, result, s, _i, _len;

      if (prefix == null) {
        prefix = null;
      }
      if (!object) {
        return "";
      }
      if (!prefix && !(this.get_object_type(object) === "object")) {
        throw new Error("Url parameters should be a javascript hash");
      }
      if (root.jQuery) {
        result = root.jQuery.param(object);
        return (!result ? "" : result);
      }
      s = [];
      switch (this.get_object_type(object)) {
        case "array":
          for (i = _i = 0, _len = object.length; _i < _len; i = ++_i) {
            element = object[i];
            s.push(this.serialize(element, prefix + "[]"));
          }
          break;
        case "object":
          for (key in object) {
            if (!__hasProp.call(object, key)) continue;
            prop = object[key];
            if (!(prop != null)) {
              continue;
            }
            if (prefix != null) {
              key = "" + prefix + "[" + key + "]";
            }
            s.push(this.serialize(prop, key));
          }
          break;
        default:
          if (object) {
            s.push("" + (encodeURIComponent(prefix.toString())) + "=" + (encodeURIComponent(object.toString())));
          }
      }
      if (!s.length) {
        return "";
      }
      return s.join("&");
    },
    clean_path: function(path) {
      var last_index;

      path = path.split("://");
      last_index = path.length - 1;
      path[last_index] = path[last_index].replace(/\/+/g, "/");
      return path.join("://");
    },
    set_default_url_options: function(optional_parts, options) {
      var i, part, _i, _len, _results;

      _results = [];
      for (i = _i = 0, _len = optional_parts.length; _i < _len; i = ++_i) {
        part = optional_parts[i];
        if (!options.hasOwnProperty(part) && defaults.default_url_options.hasOwnProperty(part)) {
          _results.push(options[part] = defaults.default_url_options[part]);
        }
      }
      return _results;
    },
    extract_anchor: function(options) {
      var anchor;

      anchor = "";
      if (options.hasOwnProperty("anchor")) {
        anchor = "#" + options.anchor;
        delete options.anchor;
      }
      return anchor;
    },
    extract_trailing_slash: function(options) {
      var trailing_slash;

      trailing_slash = false;
      if (defaults.default_url_options.hasOwnProperty("trailing_slash")) {
        trailing_slash = defaults.default_url_options.trailing_slash;
      }
      if (options.hasOwnProperty("trailing_slash")) {
        trailing_slash = options.trailing_slash;
        delete options.trailing_slash;
      }
      return trailing_slash;
    },
    extract_options: function(number_of_params, args) {
      var last_el;

      last_el = args[args.length - 1];
      if (args.length > number_of_params || ((last_el != null) && "object" === this.get_object_type(last_el) && !this.look_like_serialized_model(last_el))) {
        return args.pop();
      } else {
        return {};
      }
    },
    look_like_serialized_model: function(object) {
      return "id" in object || "to_param" in object;
    },
    path_identifier: function(object) {
      var property;

      if (object === 0) {
        return "0";
      }
      if (!object) {
        return "";
      }
      property = object;
      if (this.get_object_type(object) === "object") {
        if ("to_param" in object) {
          property = object.to_param;
        } else if ("id" in object) {
          property = object.id;
        } else {
          property = object;
        }
        if (this.get_object_type(property) === "function") {
          property = property.call(object);
        }
      }
      return property.toString();
    },
    clone: function(obj) {
      var attr, copy, key;

      if ((obj == null) || "object" !== this.get_object_type(obj)) {
        return obj;
      }
      copy = obj.constructor();
      for (key in obj) {
        if (!__hasProp.call(obj, key)) continue;
        attr = obj[key];
        copy[key] = attr;
      }
      return copy;
    },
    prepare_parameters: function(required_parameters, actual_parameters, options) {
      var i, result, val, _i, _len;

      result = this.clone(options) || {};
      for (i = _i = 0, _len = required_parameters.length; _i < _len; i = ++_i) {
        val = required_parameters[i];
        if (i < actual_parameters.length) {
          result[val] = actual_parameters[i];
        }
      }
      return result;
    },
    build_path: function(required_parameters, optional_parts, route, args) {
      var anchor, opts, parameters, result, trailing_slash, url, url_params;

      args = Array.prototype.slice.call(args);
      opts = this.extract_options(required_parameters.length, args);
      if (args.length > required_parameters.length) {
        throw new Error("Too many parameters provided for path");
      }
      parameters = this.prepare_parameters(required_parameters, args, opts);
      this.set_default_url_options(optional_parts, parameters);
      anchor = this.extract_anchor(parameters);
      trailing_slash = this.extract_trailing_slash(parameters);
      result = "" + (this.get_prefix()) + (this.visit(route, parameters));
      url = Utils.clean_path("" + result);
      if (trailing_slash === true) {
        url = url.replace(/(.*?)[\/]?$/, "$1/");
      }
      if ((url_params = this.serialize(parameters)).length) {
        url += "?" + url_params;
      }
      url += anchor;
      return url;
    },
    visit: function(route, parameters, optional) {
      var left, left_part, right, right_part, type, value;

      if (optional == null) {
        optional = false;
      }
      type = route[0], left = route[1], right = route[2];
      switch (type) {
        case NodeTypes.GROUP:
          return this.visit(left, parameters, true);
        case NodeTypes.STAR:
          return this.visit_globbing(left, parameters, true);
        case NodeTypes.LITERAL:
        case NodeTypes.SLASH:
        case NodeTypes.DOT:
          return left;
        case NodeTypes.CAT:
          left_part = this.visit(left, parameters, optional);
          right_part = this.visit(right, parameters, optional);
          if (optional && !(left_part && right_part)) {
            return "";
          }
          return "" + left_part + right_part;
        case NodeTypes.SYMBOL:
          value = parameters[left];
          if (value != null) {
            delete parameters[left];
            return this.path_identifier(value);
          }
          if (optional) {
            return "";
          } else {
            throw new ParameterMissing("Route parameter missing: " + left);
          }
          break;
        default:
          throw new Error("Unknown Rails node type");
      }
    },
    visit_globbing: function(route, parameters, optional) {
      var left, right, type, value;

      type = route[0], left = route[1], right = route[2];
      if (left.replace(/^\*/i, "") !== left) {
        route[1] = left = left.replace(/^\*/i, "");
      }
      value = parameters[left];
      if (value == null) {
        return this.visit(route, parameters, optional);
      }
      parameters[left] = (function() {
        switch (this.get_object_type(value)) {
          case "array":
            return value.join("/");
          default:
            return value;
        }
      }).call(this);
      return this.visit(route, parameters, optional);
    },
    get_prefix: function() {
      var prefix;

      prefix = defaults.prefix;
      if (prefix !== "") {
        prefix = (prefix.match("/$") ? prefix : "" + prefix + "/");
      }
      return prefix;
    },
    _classToTypeCache: null,
    _classToType: function() {
      var name, _i, _len, _ref;

      if (this._classToTypeCache != null) {
        return this._classToTypeCache;
      }
      this._classToTypeCache = {};
      _ref = "Boolean Number String Function Array Date RegExp Object Error".split(" ");
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        this._classToTypeCache["[object " + name + "]"] = name.toLowerCase();
      }
      return this._classToTypeCache;
    },
    get_object_type: function(obj) {
      if (root.jQuery && (root.jQuery.type != null)) {
        return root.jQuery.type(obj);
      }
      if (obj == null) {
        return "" + obj;
      }
      if (typeof obj === "object" || typeof obj === "function") {
        return this._classToType()[Object.prototype.toString.call(obj)] || "object";
      } else {
        return typeof obj;
      }
    }
  };

  createGlobalJsRoutesObject = function() {
    var namespace;

    namespace = function(mainRoot, namespaceString) {
      var current, parts;

      parts = (namespaceString ? namespaceString.split(".") : []);
      if (!parts.length) {
        return;
      }
      current = parts.shift();
      mainRoot[current] = mainRoot[current] || {};
      return namespace(mainRoot[current], parts.join("."));
    };
    namespace(root, "Routes");
    root.Routes = {
// activities => /activities(.:format)
  activities_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"activities",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// activity => /activities/:id(.:format)
  activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// add_user_email => /users/:id/add_email(.:format)
  add_user_email_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"add_email",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// auth_billing_card => /auth/billing_card(.:format)
  auth_billing_card_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"billing_card",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// auth_card => /auth/:id/card(.:format)
  auth_card_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"card",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// auth_change_password => /auth/change_password(.:format)
  auth_change_password_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"change_password",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// auth_check_user_unique => /auth/check_user_unique(.:format)
  auth_check_user_unique_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"check_user_unique",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// auth_confirmation_success => /auth/confirmation_success(.:format)
  auth_confirmation_success_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"confirmation_success",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// auth_new_profile => /auth/new_profile(.:format)
  auth_new_profile_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"new_profile",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// book_activities => /activities/book(.:format)
  book_activities_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[6,"book",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// booked_activity => /activities/:id/booked(.:format)
  booked_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"booked",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// booking_calendars => /calendars/booking(.:format)
  booking_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"booking",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// calendar => /calendars/:id(.:format)
  calendar_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// calendars => /calendars(.:format)
  calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"calendars",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// cancel_booking_my_activities => /my_activities/cancel_booking(.:format)
  cancel_booking_my_activities_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"my_activities",false]],[7,"/",false]],[6,"cancel_booking",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// cancel_user_registration => /auth/cancel(.:format)
  cancel_user_registration_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"cancel",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// categories => /categories(.:format)
  categories_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"categories",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// category => /categories/:id(.:format)
  category_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"categories",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// check_categories_unique_categories => /categories/check_categories_unique(.:format)
  check_categories_unique_categories_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"categories",false]],[7,"/",false]],[6,"check_categories_unique",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// contact => /contact(.:format)
  contact_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"contact",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// contact_my_activity => /my_activities/:id/contact(.:format)
  contact_my_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"my_activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"contact",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// cus_month_calendars_activity => /activities/:id/cus_month_calendars(.:format)
  cus_month_calendars_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"cus_month_calendars",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// customer_contacts_promotion => /promotions/:id/customer_contacts(.:format)
  customer_contacts_promotion_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"customer_contacts",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// data_day_activity => /activities/:id/data_day(.:format)
  data_day_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"data_day",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// day_calendars => /calendars/day(.:format)
  day_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"day",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// delete_account_user => /users/:id/delete_account(.:format)
  delete_account_user_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"delete_account",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// delete_category => /categories/:id/delete(.:format)
  delete_category_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"categories",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"delete",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// destroy_promotion_calendars => /calendars/destroy_promotion(.:format)
  destroy_promotion_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"destroy_promotion",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// destroy_user_session => /auth/sign_out(.:format)
  destroy_user_session_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"sign_out",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_activity => /activities/:id/edit(.:format)
  edit_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_calendar => /calendars/:id/edit(.:format)
  edit_calendar_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_category => /categories/:id/edit(.:format)
  edit_category_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"categories",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_faq => /faqs/:id/edit(.:format)
  edit_faq_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"faqs",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_history_v_money => /history_v_moneys/:id/edit(.:format)
  edit_history_v_money_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"history_v_moneys",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_image => /images/:id/edit(.:format)
  edit_image_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"images",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_my_activity => /my_activities/:id/edit(.:format)
  edit_my_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"my_activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_promotion => /promotions/:id/edit(.:format)
  edit_promotion_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_user => /users/:id/edit(.:format)
  edit_user_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_user_password => /auth/password/edit(.:format)
  edit_user_password_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"password",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// edit_user_registration => /auth/edit(.:format)
  edit_user_registration_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"edit",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// faq => /faqs/:id(.:format)
  faq_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"faqs",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// faqs => /faqs(.:format)
  faqs_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"faqs",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// get_cus_email_promotions => /promotions/get_cus_email(.:format)
  get_cus_email_promotions_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[6,"get_cus_email",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// get_data_day_calendars => /calendars/get_data_day(.:format)
  get_data_day_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"get_data_day",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// get_data_month_calendars => /calendars/get_data_month(.:format)
  get_data_month_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"get_data_month",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// get_data_week_calendars => /calendars/get_data_week(.:format)
  get_data_week_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"get_data_week",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// get_del_pro_on_day_calendars => /calendars/get_del_pro_on_day(.:format)
  get_del_pro_on_day_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"get_del_pro_on_day",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// get_delete_promotion => /promotions/:id/get_delete(.:format)
  get_delete_promotion_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"get_delete",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// history_v_money => /history_v_moneys/:id(.:format)
  history_v_money_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"history_v_moneys",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// history_v_moneys => /history_v_moneys(.:format)
  history_v_moneys_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"history_v_moneys",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// image => /images/:id(.:format)
  image_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"images",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// images => /images(.:format)
  images_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"images",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// my_activities => /my_activities(.:format)
  my_activities_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"my_activities",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// my_activity => /my_activities/:id/destroy(.:format)
  my_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"my_activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"destroy",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_activity => /activities/new(.:format)
  new_activity_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_calendar => /calendars/new(.:format)
  new_calendar_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_category => /categories/new(.:format)
  new_category_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"categories",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_faq => /faqs/new(.:format)
  new_faq_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"faqs",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_history_v_money => /history_v_moneys/new(.:format)
  new_history_v_money_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"history_v_moneys",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_image => /images/new(.:format)
  new_image_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"images",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_my_activity => /my_activities/new(.:format)
  new_my_activity_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"my_activities",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_promotion => /promotions/new(.:format)
  new_promotion_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_step2_users => /users/new_step2(.:format)
  new_step2_users_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[6,"new_step2",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_user => /users/new(.:format)
  new_user_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_user_confirmation => /auth/confirmation/new(.:format)
  new_user_confirmation_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"confirmation",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_user_password => /auth/password/new(.:format)
  new_user_password_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"password",false]],[7,"/",false]],[6,"new",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_user_registration => /auth/sign_up(.:format)
  new_user_registration_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"sign_up",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// new_user_session => /auth/sign_in(.:format)
  new_user_session_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"sign_in",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// promotion => /promotions/:id(.:format)
  promotion_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// promotions => /promotions(.:format)
  promotions_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"promotions",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// promotions_update_image => /promotions/update_image(.:format)
  promotions_update_image_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[6,"update_image",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// promotions_upload_image => /promotions/upload_image(.:format)
  promotions_upload_image_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[6,"upload_image",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info => /rails/info(.:format)
  rails_info_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info_properties => /rails/info/properties(.:format)
  rails_info_properties_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[7,"/",false]],[6,"properties",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// rails_info_routes => /rails/info/routes(.:format)
  rails_info_routes_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"rails",false]],[7,"/",false]],[6,"info",false]],[7,"/",false]],[6,"routes",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// root => /
  root_path: function(options) {
  return Utils.build_path([], [], [7,"/",false], arguments);
  },
// send_reset_password_user => /users/:id/send_reset_password(.:format)
  send_reset_password_user_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"send_reset_password",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// set_cancel_reactive_status_promotions => /promotions/set_cancel_reactive_status(.:format)
  set_cancel_reactive_status_promotions_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[6,"set_cancel_reactive_status",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// set_status_promotion_calendars => /calendars/set_status_promotion(.:format)
  set_status_promotion_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"set_status_promotion",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// share_promotion => /promotions/:id/share(.:format)
  share_promotion_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"promotions",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"share",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user => /users/:id(.:format)
  user_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"users",false]],[7,"/",false]],[3,"id",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_confirmation => /auth/confirmation(.:format)
  user_confirmation_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"confirmation",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_omniauth_authorize => /auth/auth/:provider(.:format)
  user_omniauth_authorize_path: function(_provider, options) {
  return Utils.build_path(["provider"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"auth",false]],[7,"/",false]],[3,"provider",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_omniauth_callback => /auth/auth/:action/callback(.:format)
  user_omniauth_callback_path: function(_action, options) {
  return Utils.build_path(["action"], ["format"], [2,[2,[2,[2,[2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"auth",false]],[7,"/",false]],[3,"action",false]],[7,"/",false]],[6,"callback",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_password => /auth/password(.:format)
  user_password_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"password",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_registration => /auth(.:format)
  user_registration_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"auth",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// user_session => /auth/sign_in(.:format)
  user_session_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"auth",false]],[7,"/",false]],[6,"sign_in",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// users => /users(.:format)
  users_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[7,"/",false],[6,"users",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// view_day_activity => /activities/:id/view_day(.:format)
  view_day_activity_path: function(_id, options) {
  return Utils.build_path(["id"], ["format"], [2,[2,[2,[2,[2,[2,[7,"/",false],[6,"activities",false]],[7,"/",false]],[3,"id",false]],[7,"/",false]],[6,"view_day",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
// week_calendars => /calendars/week(.:format)
  week_calendars_path: function(options) {
  return Utils.build_path([], ["format"], [2,[2,[2,[2,[7,"/",false],[6,"calendars",false]],[7,"/",false]],[6,"week",false]],[1,[2,[8,".",false],[3,"format",false]],false]], arguments);
  },
};
    root.Routes.options = defaults;
    return root.Routes;
  };

  if (typeof define === "function" && define.amd) {
    define([], function() {
      return createGlobalJsRoutesObject();
    });
  } else {
    createGlobalJsRoutesObject();
  }

}).call(this);
