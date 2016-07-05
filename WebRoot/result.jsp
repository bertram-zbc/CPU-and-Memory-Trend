<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";


//获取表单提交的数据
String ip = request.getParameter("ip");
String username = request.getParameter("username");
String passwd = request.getParameter("password");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>CPU and Memory utilization trend</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script language="javascript" type="text/javascript" src="http://code.jquery.com/jquery.min.js"></script>  
    <script language="javascript" type="text/javascript" src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>  
    <script language="javascript" type="text/javascript" src="http://cdn.hcharts.cn/highcharts/modules/exporting.js"></script>
    
    <script type="text/javascript">
    
   var xmlHttp;
    var chart1;
    var result = "begin";//回调结果
    
    Highcharts.setOptions({global:{useUTC : false}});  
    $(function (){
    	$(document).ready(function(){
    		
    		chart1 = new Highcharts.Chart({
    			chart:{
    				renderTo: "container",
    				type: 'spline',
    				animation: Highcharts.svg,
    				mardinRight: 10,
    				events:{
    					load: function(){
    						chart1=this;
    						getData();
    					}
    				}
    			},
    			
    			title:{
    				text: 'CPU and Memory utilization trend'
    			},
    			
    			xAxis:{
    				title:{
    					text: 'time'
    				},
    				type: 'datetime',
    				tickPixelInterval: 150
    			},
    			
    			yAxis:{
    				title:{
    					text: 'utilization'
    				},
    				plotLines:[{
    					value: 0,
    					width: 1,
    					color: '#808080'
    				}],
    				min: 0,
    				max: 100
    			},
    			
    			tooltip: {
                    formatter: function () {
                        return '<b>' + this.series.name + '</b><br/>' +
                            Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + '<br/>' +
                            Highcharts.numberFormat(this.y, 2)+'%';
                    }
                },
                
                legend: {
                    enabled: false
            },
            
           		exporting: {
                	enabled: false
            },
            
            	series: [{
                	name: 'cpu utilization',
                	data: []
           		},{
           			name: 'memory utilization',
           			data:[]
           		}]      
    		});
    	});
    });
    
    var data=[];
    var data2=[];
    function getData(){
  		var showdata=[];
  		var showdata2=[];
  		
    	var time = (new Date()).getTime();

    	/*
    	data.push({
    		x: time,
    		y: Math.random()
    	});
    	*/
    	
    	send();
    	console.log(result);
    	if( result == "error"){
    		console.log("iserror");
    		var infor = document.getElementById("information");
    		infor.innerHTML="wrong IP or Username or Password";
    	}else if(result == "begin"){
    		var infor = document.getElementById("information");
    		infor.innerHTML="initialization finished";
    	}else{
    		var infor = document.getElementById("information");
    		infor.innerHTML="success";
        	strArr=result.split("&");
        	var cpu = parseFloat(strArr[0]);
        	var mem = parseFloat(strArr[1]);
        	console.log(cpu);
        	data.push({
        		x: time,
        		y: cpu
        	});
        	
        	data2.push({
        		x: time,
        		y: mem
        	});
        	    	
        	if(data.length<20){
        		for(var i=-19;i<=0;i++){
        			if(i+data.length>=0){
        				showdata[i+19]=data[data.length+i];
        			}else{
        				showdata.push({
        					x: time+30000*i,
        					y: 0
        				});
        			}
        		}
        	}else{
        		for(var i=-19;i<=0;i++){
            		showdata[i+19]=data[data.length+i];
            	};
        	}
        	
        	if(data2.length<20){
        		for(var i=-19;i<=0;i++){
        			if(i+data2.length>=0){
        				showdata2[i+19]=data2[data2.length+i];
        			}else{
        				showdata2.push({
        					x: time+30000*i,
        					y: 0
        				});
        			}
        		}
        	}else{
        		for(var i=-19;i<=0;i++){
            		showdata2[i+19]=data2[data2.length+i];
            	};
        	}
        	
        	chart1.series[0].setData(showdata);
        	chart1.series[1].setData(showdata2);
    	}
    	
    }
    
   var time;
    
    /*
    $(document).ready(function(){
    		window.setInterval(function(){
        		getData();
        	}, 1000);
    });
    */
    function autorefresh(){
    	console.log("begin!!!!");
    	getData();
    	time = window.setInterval(function(){
    		getData();
    	}, 30000);
    }
    
    function disable(){
    	console.log("end!!!!");
    	clearInterval(time);
    	
    	var btn = document.getElementById("btn1");
    	btn.disabled='disabled';
    }
    
    /*
    function autorefresh(){
    	console.log("begin!!!!");
    	window.setInterval(function(){
    		getData();
    	}, 1000);
    }
    */
    function test(){
    	var testbtn = document.getElementById("btn");
    	testbtn.value = "<%= ip%>";
    }
    
     function createXmlHttp(){
    	 if(window.XMLHttpRequest){
    		 xmlHttp = new XMLHttpRequest();
    	 }else if(window.ActiveXObject){
    		 xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    	 }
     }
     
     function send(){
    	 //创建XMLHttpRequest
    	 createXmlHttp();
    	 xmlHttp.onreadystatechange = callBack;
    	 
    	 var postStr = "ip=<%= ip%>&username=<%=username %>&password=<%=passwd%>";
    	 
    	 xmlHttp.open("POST", "back", true);
    	 xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=UTF-8");
    	 xmlHttp.send(postStr);
     }
     
     function callBack(){
    	 if(xmlHttp.readyState == 4) {
             //判断Http的交互是否成功
             if(xmlHttp.status == 200) {
               //获取服务器返回数据
               //获取服务器输出的纯文本格式
             	result = xmlHttp.responseText;
              //console.log(responseText);
             }
    	 }
     }
    </script>

  </head>
  
  <body>

    <div id="container"></div>
    
    <input id="btn1" type="button" value="auto refresh" onclick="autorefresh()">
    <input id="btn2" type="button" value="disabled" onclick="disable()">
    
    
    <p id="information"></p>
    
  </body>
  
  
</html>
