<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/login.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Rutgers Online Travel</title>

</head>
<body>

<%
    String customer_email = session.getAttribute("customer_email").toString();
	String customer_account = session.getAttribute("customer_account").toString();
	out.print( "<p class='message' > Welcome! Dear " + customer_email + "</p>");
%>

<h2>Find Multiple Stop Flights</h2><br>

  <div class="form">
  		<input id="rbOWId" type="radio" name="Air"  checked onclick="chooseAirType()" value="ONEWAYTRIP"> One Way 
		<input id="rbRTId" type="radio" name="Air" onclick="chooseAirType()" value="ROUNDTRIP"> Round Trip 
<!-- 		<input id="rbMCId" type="radio" name="Air" onclick="chooseAirType()" value="MULTICITY"> Multiple Cities  -->
		
		
 	<form id="oneWayFormId" method="post" action="findOneWayMultiStopFlightResult.jsp">
		<input id="DomesticId" type="radio" name="DomesticInter"  value="DOMESTIC"> Domestic 
		<input id="InternationalId" type="radio" name="DomesticInter" checked value="INTERNATIONAL"> International <br><br>
    		<b>From:&nbsp;</b> 
		<input type="text" name="dpAirport" value="LAX"><br><br>
		<b>To: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
		<input type="text" name="arAirport" value="SEA"><br><br>
		<b>Depart:&nbsp;</b> 
		<input id="departCalendarId" name="departCalendar" type=date min="2018-04-02" placeholder="Pick a Date"><br><br>
		 <input type="submit" value="Search Now"> 
    </form>
    
    <form id="twoWayFormId"  method="post" action="findRoundTripFlightResult.jsp">
    		<input id="DomesticId" type="radio" name="DomesticInter"   value="DOMESTIC"> Domestic 
		<input id="InternationalId" type="radio" name="DomesticInter" checked value="INTERNATIONAL"> International <br><br>
    		<b>From:&nbsp;</b> 
		<input type="text" name="dpAirport" value="EWR"><br><br>
		<b>To: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
		<input type="text" name="arAirport" value="PEK"><br><br>
		
		<b>Depart:&nbsp;</b> 
		<input id="departCalendarId" name="departCalendar" type=date min="2018-04-02" max="2018-06-04"  placeholder="Pick a Date"><br><br>
		<b>Return:&nbsp;</b> 
		<input id="returnCalendarId" name="returnCalendar" type=date min="2018-04-02" max="2018-06-04"  placeholder="Pick a Date"><br><br>
		 <input type="submit" value="Search Now"> 
    </form>
    
    <form id="multiCityFormId"  method="post" action="findMultiCityFlightResult.jsp">
    		<div id="flightId1">
			<label id="flight1" style="color:blue"> Flight 1 <br><br></label>
			<b>From:&nbsp;</b> 
			<input type="text" name="dpAirport" value="EWR"><br><br>
			<b>To: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
			<input type="text" name="arAirport" value="MIA"><br><br>
			
			<b>Depart:&nbsp;</b> 
			<input id="departCalendarId" name="departCalendar" type=date data-date-format="YYYYMMDD" placeholder="Pick a Date"><br><br>
    		</div>
    
	   	 <div id="flightId2">
	    		<label id="flight2" style="color:blue"> Flight 2 <br><br></label>
	    		<b>From:&nbsp;</b> 
			<input type="text" name="dpAirport2" value="EWR"><br><br>
			<b>To: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b>
			<input type="text" name="arAirport2" value="MIA"><br><br>
			
			<b>Depart:&nbsp;</b> 
			<input id="departCalendarId2" name="departCalendar2" type=date placeholder="Pick a Date"><br><br>	
	    </div>
	     <input type="submit" value="Search Now"> 
    </form>
<p class="message">Go Back? <a href="customerHomePage.jsp">Go Back</a></p>   
<!-- <p class="message">Logout? <a href="/Rutgers-Online-Travel/index.jsp">Logout</a></p> -->
</div>

<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script type="text/javascript">
$(document).ready(function(){
	$('#oneWayFormId').show();
	$('#twoWayFormId').hide();
	$('#multiCityFormId').hide();
	
// 	 $("#departCalendarId").click(function(){
//          var d1=new Date($(this).val());   
//          d1=FormatDate(d1);
// // 		   $("#departCalendarId").attr("value","2018");
// 		   $("#departCalendarId").attr("value",d1); 
// //     	 alert("Deapart Date " + $("#departCalendarId").attr("value"));

//  });
});



function chooseAirType() {
 	if (document.getElementById('rbOWId').checked) {
 		document.getElementById('oneWayFormId').style.display = 'block';
        document.getElementById('twoWayFormId').style.display = 'none';
        document.getElementById('multiCityFormId').style.display = 'none';
    }
 	if (document.getElementById('rbRTId').checked) {
        document.getElementById('oneWayFormId').style.display = 'none';
        document.getElementById('twoWayFormId').style.display = 'block';
        document.getElementById('multiCityFormId').style.display = 'none';
    }
 	if (document.getElementById('rbMCId').checked) {
        document.getElementById('oneWayFormId').style.display = 'none';
        document.getElementById('twoWayFormId').style.display = 'none';
        document.getElementById('multiCityFormId').style.display = 'block';
    }
 	
};

function FormatDate (strTime) {
    var date = new Date(strTime);
     var formatedMonth = ("0" + (date.getMonth() + 1)).slice(-2);
     var formatedDate = ("0" + (date.getDate())).slice(-2);
    return date.getFullYear()+""+formatedMonth+""+formatedDate;
}

function checkForm(oForm) {
  var filled = 0;
  for (var i = 0; i < oForm.elements.length; i++) {
    if (GetElementValue(oForm.elements[i]).length > 0)
      filled++;
  }
  if(filled!=oForm.elements.length) {
    alert("Please Fill Form Completely");
    return false;
  }
}

function GetElementValue(element) {
  if ((element.type === "checkbox" || element.type === "radio") && 
       element.checked === false)
    return "";
  return element.value;
}
</script>

</body>
</html>