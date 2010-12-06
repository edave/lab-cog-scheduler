// For debugging purposes
// If the console doesn't exist (Safari, IE, etc), just create empty methods
if (!window.console) console = {};
console.log = console.log || function(){};
console.warn = console.warn || function(){};
console.error = console.error || function(){};
console.info = console.info || function(){};

var labcog = {
	sch: { exists:true }
} 

$.ajaxSetup({
  beforeSend: function(xhr) {
    xhr.setRequestHeader("Accept", "text/javascript");
  }
});

$(document).ready(function(){
  $('.ajax-form')
    .bind("ajax:success", function(evt, data, status, xhr){
      var $form = $(this);
		console.log("Form Success: %s", $(this).attr('id'));
	
      // Reset fields and any validation errors, so form can be used again, but leave hidden_field values intact.
      $form.find('textarea,input[type="text"],input[type="file"]').val("");
      $form.find('div.validation-error').empty();
 	})
    .bind("ajax:failure", function(evt, xhr, status, error){
      var $form = $(this),
          errors,
          errorText;
		console.log("Form Failure: %s", $(this).attr('id'));
		
      try {
        // Populate errorText with the comment errors
        errors = $.parseJSON(xhr.responseText);
      } catch(err) {
        // If the responseText is not valid JSON (like if a 500 exception was thrown), populate errors with a generic error message.
        console.error("Server Error for Form: %s", $(this).attr('id'))
		errors = {"Server Error": "Please reload the page and try again"};
      }

      // Build an unordered list from the list of errors
      errorText = "There were errors: \n<ul>";

      for ( error in errors ) {
        errorText += "<li>" + error + ': ' + errors[error] + "</li> ";
      }

      errorText += "</ul>";

      // Insert error list into form
      var errorDiv = $form.find("div.validation-error");
	  errorDiv.html(errorText);
	  errorDiv.show(300);
    });

	// Converts checkboxes into iPhone-style toggles
	$('input.toggle:checkbox').each(function(){
		var element = $(this);
		element.iphoneStyle({ checkedLabel: element.attr('data-checked-label'), 
							  uncheckedLabel: element.attr('data-unchecked-label') });
	});
});

/* Collapseable Functionality
   Finds any element that has a data-collapse-element-id attr
   and adds click bindings so that element will show/hide (toggle)
   the element with id=data-collapse-element-id
 */
$('[data-collapse-element-id]').live('click', function(e){
	var element = $(this);
	var collapseElementID = element.attr('data-collapse-element-id');
	$('#'+collapseElementID).slideToggle();
	element.toggleClass("collapsed");
	element.toggleClass("uncollapsed");
});

$('[data-destroy-url]').live('click', function(e){
	var element = $(this);
	var mapping = eval(element.attr("data-labcog-mapping"));
	var dialog = $("div#" + mapping.dialog);
	dialog.dialog('option', 'title', element.attr("data-destroy-title"));
	dialog.dialog("option", 
		"buttons", [
		{ text: "No",
		  click: function(){
			dialog.dialog('close');
		}
		},
	{ text: "Yes, do it!",
	  click: function() {
		dialog.dialog('close');
		$.destroy({
	  		url: element.attr('data-destroy-url'),
	  		success: mapping.success
		});
	}}
	]);
	dialog.dialog('open');
});

function passwordHelper(passwordElement, confirmElement, username){
	var validationElements = new Array();
	validationElements["confirm"] = jQuery("div#pwd-valid-confirm");
    validationElements["len"] = jQuery("div#pwd-valid-len");
    validationElements["caps"] = jQuery("div#pwd-valid-caps");
    validationElements["num"] = jQuery("div#pwd-valid-num");
    validationElements["login"] = jQuery("div#pwd-valid-login");
    
    if (typeof(username) == 'string') {
        new Form.Element.Observer(passwordElement.attr('id'), 0.3, function(element, value){
            passwordHelperComparer($(element).value, jQuery(confirmElement).attr('value'), username, validationElements);
        });
        new Form.Element.Observer(confirmElement.attr('id'), 0.3, function(element, value){
            passwordHelperComparer(jQuery(passwordElement).attr('value'), $(element).value, username, validationElements);
        });
    }
    else {
        new Form.Element.Observer(passwordElement.attr('id'), 0.3, function(element, value){
            passwordHelperComparer($(element).value, jQuery(confirmElement).attr('value'), jQuery(username).attr('value'), validationElements);
        });
        new Form.Element.Observer(confirmElement.attr('id'), 0.3, function(element, value){
			passwordHelperComparer(jQuery(passwordElement).attr('value'), $(element).value, jQuery(username).attr('value'), validationElements);
        });
        new Form.Element.Observer(username.attr('id'), 0.3, function(element, value){
            passwordHelperComparer(jQuery(passwordElement).attr('value'), jQuery(confirmElement).attr('value'), $(element).value, validationElements);
        });
    }
}

function passwordHelperComparer(passwordValue, confirmValue, usernameValue, validationElements){
    var successClassName = 'validation-success';
    var errorClassName = 'validation-error';
    
    var errorElements = new Array();
    var successElements = new Array();
    
	// Confirm password check
    if (passwordValue == confirmValue) {
        successElements.push(validationElements["confirm"]);
    }
    else {
        errorElements.push(validationElements["confirm"]);
    }
    
    //Length check
    if (passwordValue.length >= 6) {
        successElements.push(validationElements["len"]);
    }
    else {
        errorElements.push(validationElements["len"]);
    }
    
    // Username check    
    if (passwordValue != usernameValue) {
		 successElements.push(validationElements["login"]);
    }
    else {
        errorElements.push(validationElements["login"]);
    }
	
	// Confirm check
	if (passwordValue == confirmValue) {
        successElements.push(validationElements["confirm"]);
    }
    else {
        errorElements.push(validationElements["confirm"]);
    }
	
	// Num Check
	if (passwordValue.match(/\d+/)) {
        successElements.push(validationElements["num"]);
    }
    else {
        errorElements.push(validationElements["num"]);
    }
	
	// Caps Check
	if (passwordValue.match(/[A-Z]/)) {
        successElements.push(validationElements["caps"]);
    }
    else {
        errorElements.push(validationElements["caps"]);
    }
   
	 for (var i=0; i < errorElements.length; i++) {
	 	var errorElement = errorElements[i];
		errorElement.removeClass(successClassName);
        errorElement.addClass(errorClassName);
    }
   
	for (var j=0; j < successElements.length; j++) {
	 	var successElement = successElements[j];
		successElement.removeClass(errorClassName);
        successElement.addClass(successClassName);
    }
}