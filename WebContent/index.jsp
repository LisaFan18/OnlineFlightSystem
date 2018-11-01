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
session.setAttribute("customer_email", "");
%>

<p class="app-name"> Rutgers Online Travel </p>      

<div class="login-page">
  <div class="form">
<!--    <form id="registerFormId" class="register-form" method="post" action="customer/addCustomer.jsp" onsubmit="return checkForm(registerFormId);"> -->
 	  <form id="registerFormId" class="register-form" method="post" action="customer/addCustomer.jsp">
      
      <input type="text" placeholder="email" maxlength="100"  name="email"/>
      <input type="password" placeholder="password" maxlength="20" name="password"/>
      <input type="text" placeholder="first name" maxlength="15" name="firstname"/>
      <input type="text" placeholder="last name" maxlength="15" name="lastname"/>
      <input type="text" placeholder="address" maxlength="50" name="address"/>
      <input type="text" placeholder="city" maxlength="20" name="city"/>
      <input type="text" placeholder="state" maxlength="20" name="state"/>
      <input type="text" placeholder="zip code" maxlength="10" name="zipcode"/>
      <input type="text" placeholder="phone" maxlength="20" name="phone"/>
      <input type="text" placeholder="credit card number" maxlength="16" name="credit"/>
      <button>create</button>
      <p class="message">Already registered? <a href="#">Sign In</a></p>
    </form>
    
    <form class="login-form" method="post" action="customer/checkCustomer.jsp">
      <input type="text" value="jingyi.gu@rutgers.edu"  name="cstEmail"/>
      <input type="password" value="1234" name="cstPassword"/>
      <button>login</button>
      <p class="message">Not registered? <a href="#">Create an account</a></p>
      <p class="message">Manager? <a href="manager/mgLogin.jsp">Please log in here</a></p>
      
    </form>
     
  </div>
</div>

<script src='http://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script type="text/javascript">
$(document).ready(function(){
	if (window.location.href.indexOf('signup')!=-1){
		$('.login-form').hide();
		$('.register-form').show();
	}
});

$('.message a').click(function(){
	   $('form').animate({height: "toggle", opacity: "toggle"}, "slow");
	});

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