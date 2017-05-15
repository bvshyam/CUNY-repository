var gauges = [];
			
			function createGauge(name, label, min, max)
			{
				var config = 
				{
					size: 120,
					label: label,
					min: undefined != min ? min : 0,
					max: undefined != max ? max : 500,
					minorTicks: 5
				}
				
				var range = config.max - config.min;
				config.yellowZones = [{ from: config.min + range*0.75, to: config.min + range*0.9 }];
				config.redZones = [{ from: config.min + range*0.9, to: config.max }];
				
				gauges[name] = new Gauge(name + "GaugeContainer", config);
				gauges[name].render();
			}
			
			function createGauges()
			{
				createGauge("memory", "Cylinder",0,12);
				createGauge("cpu", "Mileage",0,100);
				createGauge("network", "Savings",0,15000);
				//createGauge("test", "Test", -50, 50 );
			}
			
			function updateGauges(horsepower,mpg,price)
			{
				// for (var key in gauges)
				// {
				// 	//var value = getRandomValue(gauges[key])
				// 	console.log(key);
				// 	var value = data;
				// 	gauges[key].redraw(value);
				// }

					//var value = horsepower;
					gauges['memory'].redraw(horsepower);
					gauges['cpu'].redraw(mpg);
					gauges['network'].redraw(price);


			}
			
			function getRandomValue(gauge)
			{
				var overflow = 0; //10;
				return gauge.config.min - overflow + (gauge.config.max - gauge.config.min + overflow*2) *  Math.random();
			}
			
			function initialize()
			{
				createGauges();
				//setInterval(updateGauges, 5000);
			}


		function showimages(make){

d3.select("iframe").remove();

d3.select("#insert_images").append('iframe').attr("src","http://www.bing.com/images/search?q="+make)
	.attr("width","100%").attr("height","600px")

//d3.select("#insert_images").append('p').text(url_string);

		}