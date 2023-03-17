({
    
    fireworks : function(component, event, helper){
        var action = component.get('c.getsObjectCount'); 
        action.setParams({ 
            'recId':component.get("v.recordId")
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var response = a.getReturnValue();
                //setTimeout(function(){{!v.HeaderMessage}
                if(response != undefined && response != null){
                component.set("v.showSpinner", response.respstatus);
                component.set("v.HeaderMessage", response.headerMessage);
                component.set("v.SubHeaderMessage", response.subheaderMessage);
                //}, 1000);
                }
                if(component.get("v.showSpinner")){
                    
                    setTimeout(function(){
                        component.set("v.showSecText", true);
                    }, 5000);
                    
                    setTimeout(function(){
                        var end = Date.now() + (60 * 100);
                        
                        var interval = setInterval(function() {
                            if (Date.now() > end) {
                                return clearInterval(interval);
                            }
                            
                            confetti({
                                particleCount : 400,
                                startVelocity: 15,
                                spread: 360,
                                ticks: 60,
                                origin: {
                                    x: Math.random(),
                                    // since they fall down, start a bit higher than random
                                    y: Math.random() - 0.2
                                },
                                colors : component.get("v.colors")
                            });
                        }, 200);
                        
                    }, 100);
                    setTimeout(function(){
                        var end = Date.now() + (60 * 100);
                        
                        var interval = setInterval(function() {
                            if (Date.now() > end) {
                                return clearInterval(interval);
                            }
                            
                            confetti({
                                particleCount : 400,
                                startVelocity: 15,
                                spread: 360,
                                ticks: 60,
                                origin: {
                                    x: Math.random(),
                                    // since they fall down, start a bit higher than random
                                    y: Math.random() - 0.2
                                },
                                colors : component.get("v.colors")
                            });
                        }, 200);
                        
                    }, 5000);
                    setTimeout(function(){
                        var end = Date.now() + (60 * 100);
                        
                        var interval = setInterval(function() {
                            if (Date.now() > end) {
                                return clearInterval(interval);
                            }
                            
                            confetti({
                                particleCount : 400,
                                startVelocity: 15,
                                spread: 360,
                                ticks: 90,
                                origin: {
                                    x: Math.random(),
                                    // since they fall down, start a bit higher than random
                                    y: Math.random() - 0.2
                                },
                                colors : component.get("v.colors")
                            });
                        }, 200);
                        
                    }, 8500);
                    setTimeout(function(){
                        var end = Date.now() + (15 * 100);
                        
                        (function frame() {
                            confetti({
                                particleCount: 10,
                                angle: 60,
                                spread: 25,
                                origin: {
                                    x: 0,
                                    y : 0.65
                                },
                                colors: component.get("v.colors")
                            });
                            confetti({
                                particleCount: 10,
                                angle: 120,
                                spread: 25,
                                origin: {
                                    x: 1,
                                    y : 0.65
                                },
                                colors: component.get("v.colors")
                            });
                            
                            if (Date.now() < end) {
                                requestAnimationFrame(frame);
                            }
                        }());
                    }, 12000);
                    setTimeout(function(){
                        var end = Date.now() + (15 * 75);
                        
                        // go Buckeyes!
                        var colors = ['#610B0B','#FFFF00','#FF00BF','#0040FF','#585858','#00FFBF','#FE642E','#FFBF00','#0101DF','#FF8000','#00FF00','#FF0040','#A901DB','#0B0B3B','#FF0000'];
                        
                        (function frame() {
                            confetti({
                                particleCount: 10,
                                startVelocity: 15,
                                angle: 335,
                                spread: 10,
                                origin: {
                                    x: 0,
                                    y: 0,
                                },
                                colors: colors
                            }); 
                            confetti({
                                particleCount: 10,
                                startVelocity: 15,
                                angle: 205,
                                spread: 10,
                                origin: {
                                    x: 1,
                                    y: 0,
                                },
                                colors: colors
                            });
                            
                            confetti({
                                particleCount: 10,
                                startVelocity: 25,
                                angle: 140,
                                spread: 30,
                                origin: {
                                    x: 1,
                                    y: 1,
                                },
                                colors: colors
                            });
                            
                            confetti({
                                particleCount: 10,
                                startVelocity: 25,
                                angle: 40,
                                spread: 30,
                                origin: {
                                    x: 0,
                                    y: 1,
                                },
                                colors: colors
                            });
                            
                            if (Date.now() < end) {
                                requestAnimationFrame(frame);
                            }
                        }());
                        setTimeout(function(){
                            component.set("v.showSpinner", false);
                        }, 11500);
                    }, 15000);
                    setTimeout(function(){
                        confetti({
                            particleCount: 500,
                            startVelocity: 50,
                            spread: 150,
                            origin: {
                                y: 0.9
                            },
                            colors : component.get("v.colors")
                        });
                    }, 20000);
                    
                    setTimeout(function(){
                        var end = Date.now() + (15 * 100);
                        
                        (function frame() {
                            confetti({
                                particleCount: 10,
                                startVelocity: 5,
                                ticks: 300,
                                origin: {
                                    x: Math.random(),
                                    // since they fall down, start a bit higher than random
                                    y: 0
                                },
                                colors: component.get("v.colors")
                            });
                            
                            if (Date.now() < end) {
                                requestAnimationFrame(frame);
                            }
                        }());
                    }, 20200);
                }
            }
        });
        
        
        
        $A.enqueueAction(action);
    },
    
})