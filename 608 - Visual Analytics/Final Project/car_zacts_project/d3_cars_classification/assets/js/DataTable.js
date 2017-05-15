window.dataTable = function(id, data, columns, colors, callback_highlight){
	var dataTable = {};
	var _data = data;
	var columns2 = [
		{ name: "Make", field: "model", id: "model", sortable: true, width: 350, resizable: false , headerCssClass: "prKeyHeadColumn", formatter: MakeFormatter },
		{ name: "Engine-Disp", field: "eng_display", id: "eng_display", sortable: true, width: 65, resizable: false , headerCssClass: "prKeyHeadColumn", formatter:FuelFormatter },
	    { name: "Cylinders", field: "cyl", id: "cyl", sortable: true, width: 90, resizable: false, headerCssClass: "prKeyHeadColumn", cssClass: "numericCell" },
	    { name: "Transmission", field: "transmission", id: "transmission", sortable: true, width: 90, resizable: false , headerCssClass: "prKeyHeadColumn", cssClass: "numericCell"},
	    { name: "City-Mpg (mi)", field: "mileage", id: "mileage", sortable: true, width: 65, resizable: false , headerCssClass: "prKeyHeadColumn", cssClass: "numericCell"},
	    { name: "Money Saved", field: "yousavespend", id: "yousavespend", sortable: true, width: 85, resizable: false, headerCssClass: "prKeyHeadColumn", cssClass: "numericCell", formatter: NumberFormatter }
	    
	];

	var options = {
        enableCellNavigation: true,
        enableColumnReorder : true,
      };

	var grid = new Slick.Grid("#" + id, _data, columns2, options)

	grid.onSort.subscribe(function (e, args) {
    	var field = args.sortCol.field;
	    _data.sort(function (a, b) {
	        var result =
	            a[field] > b[field] ? 1 :
	            a[field] < b[field] ? -1 :
	            0;

	        return args.sortAsc ? result : -result;
	    });
    	grid.invalidate();
	});

	grid.onMouseEnter.subscribe(function(e,args) {
		var selected = grid.getCellFromEvent(e).row;

		updateGauges(_data[selected].cyl, _data[selected].mileage, _data[selected].yousavespend);
    	showimages(_data[selected].model);


    });


    function MakeFormatter(row, cell, value, columnDef, dataContext) {
        if (value == null || value == "" || typeof value == "undefined"){
            return "";
        }
        else {
			return  "<svg width=\"20\" height=\"20\"> <circle style=\"width:80%; height:80%;\" cy=\"12\" cx=\"10\" r=\"7\" fill=\"" + colors[value] + "\"> </circle> </svg> <text>" + capitalize(value) + " </text>";
        }
    }

    function FuelFormatter(row, cell, value, columnDef, dataContext) {
		return  "<text>" + capitalize(value) + " </text>";
    }

     function NumberFormatter(row, cell, value, columnDef, dataContext) {
        if (value == null || value == "" || typeof value == "undefined"){
            return "";
        }
        else {
        	var priceWithDots = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

			return  "<text>" + priceWithDots + "</text>";
        }
    }

	dataTable.update = function(data){
		if (_.isEmpty(data)) return;
		_data = data;
		grid.setData(_data);
		grid.invalidate();
		grid.render();
	}

    return dataTable;

}