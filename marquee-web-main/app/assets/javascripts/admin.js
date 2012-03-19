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