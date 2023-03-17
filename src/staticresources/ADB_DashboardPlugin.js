if (!window.$Lightning) {
	$Lightning = (function() {
		var delegateLoaded = false;
		var callQueue = [];
		generateDiv();
		
		//	generate a new div dynamically
		function generateDiv() {
			console.log('generating');
			var div = document.createElement("div");
			div.id = "dynamic_div_id";
			document.getElementById("lexcontainer").appendChild(div);
			//document.body.appendChild(div);
			console.log(div);
		}
		
		// util methods
		function getDelegateScriptUrl() {
			// load the delegate script based on stored version (got from aura nonce) or get latest version
			var url = "/lightning/lightning.out.delegate.js?v=" + getDelegateScriptVersion();
			
			var scripts = document.getElementsByTagName("script");
			for (var m = 0; m < scripts.length; m++) {
				var script = scripts[m].src;
				var i = script.indexOf("/lightning/lightning.out.js");
				if (i >= 0) {
					var basePath = script.substring(0, i);
					url = basePath + url;
					break;
				}
			}
			
			return url;
		}
		
		function getDelegateScriptVersion(){
			try {
				if(localStorage.lightningOutDelegateVersion){
					return localStorage.lightningOutDelegateVersion;
				}
			} catch (e) {}
			return (new Date()).getTime();
		}
		
		function loadDelegateScript() {
			var script = document.createElement('script');
			script.type = "text/javascript";
			script.src = getDelegateScriptUrl();
			script.onload = function() {
				delegateLoaded = true;
				while(callQueue.length) {
					$Lightning._delegate.use.apply(this, callQueue.shift());
				}
			}
			document.head.appendChild(script);
		}
		
		// load delegate
		loadDelegateScript();
		
		return {
			use: function() {
				var args = Array.prototype.slice.call(arguments);
				if (delegateLoaded) {
					return $Lightning._delegate.use.apply(this, args);
				} else {
					// queue the request
					return callQueue.push(args);
				}
			},
			createComponent: function() {
				return $Lightning._delegate.createComponent.apply(this, Array.prototype.slice.call(arguments));
			},
			getApplication: function() {
				return $Lightning._delegate.getApplication.apply(this, Array.prototype.slice.call(arguments));
			},
			lightningLoaded: function() {
				return $Lightning._delegate.lightningLoaded.apply(this, Array.prototype.slice.call(arguments));
			},
			ready: function() {
				return $Lightning._delegate.ready.apply(this, Array.prototype.slice.call(arguments));
			}
		}
	})();
}
	
$Lightning.use(
	"c:LightningOutTestApp",    // name of the Lightning app                                             
	function() {
	   $Lightning.createComponent(		// Callback once framework and app loaded
			"c:LightningOutTest", // top-level component of your app
		    { },                  // attributes to set on the component when created
		    "dynamic_div_id",	//"lexcontainer",   // the DOM location to insert the component
		    function(cmp) {
			   // callback when component is created and active on the page
		    }
	   );		
	},
	'https://styx-acet-uhg.cs62.force.com/iset'  // Community endpoint			  
);