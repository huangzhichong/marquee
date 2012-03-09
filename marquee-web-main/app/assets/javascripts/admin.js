function checkOnlySpace(field, rules, i, options){
  var patrn = /^(\s)+$/i;
  if (patrn.test(field.val())) {
      return "* Space only is not allowed";
  }
}
function checkOptionItems(field, rules, i, options){
  if(field[0].options && field[0].options.length == 0) {
    return "* This field is required";
  }
}