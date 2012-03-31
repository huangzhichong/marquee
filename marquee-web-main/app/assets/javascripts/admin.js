function checkOnlySpace(field, rules, i, options){
  var pattern = /^(\s)+$/i;
  if (pattern.test(field.val())) {
      return "* Space only is not allowed";
  }
}
function checkPositiveInteger(field, rules, i, options) {
  var pattern = /^[0-9]+$/
  if (!pattern.test(field.val())) {
      return "* Only zero or positive integer is permitted";
  }  
}
function checkNullSelectBox(field, rules, i, options) {
  if(!field[0].options || field[0].options.length == 0) {
    return "* Please add at least one item";
  }
}
function checkOptionItems(field, rules, i, options){
  if(field[0].options && field[0].options.length == 0) {
    return "* This field is required";
  }
}
function checkOptionSelected(field, rules, i, options) {
  var result = false;
  if(field[0].options) {
    for(var i=0; i<field[0].options.length; i++) {
      if(field[0].options[i].selected == true) {
        result = true;
      }
    }
  }
  if(!result) {
    return "* You must select one item"
  }
}