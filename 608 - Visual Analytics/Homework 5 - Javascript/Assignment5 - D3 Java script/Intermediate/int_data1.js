var pres_dataset;



d3.csv("presidents.csv", function(data){ 
pres_dataset = data


var table = document.createElement("table");
table.id="main_data";

var row = table.insertRow(-1);

//For title
title_name = row.insertCell(-1);
title_name.appendChild(document.createTextNode("Name"));

title_ht = row.insertCell(-1);
title_ht.appendChild(document.createTextNode("Height"));

title_wt = row.insertCell(-1);
title_wt.appendChild(document.createTextNode("Weight"));

//For data

for (var i = 0; i < pres_dataset.length; i++) {

  var row = table.insertRow(-1);
  var pr_name = row.insertCell(-1);
  pr_name.appendChild(document.createTextNode(pres_dataset[i].Name));

  var pr_height = row.insertCell(-1);
  pr_height.appendChild(document.createTextNode(pres_dataset[i].Height));

   var pr_weight = row.insertCell(-1);
  pr_weight.appendChild(document.createTextNode(pres_dataset[i].Weight));
}

document.body.appendChild(table);


});

