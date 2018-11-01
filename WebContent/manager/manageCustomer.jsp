<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="../js/jquery.min.js"></script>
<script src="../js/bootstrap.min.js"></script> 
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

  <script>
    $(function() {
    $( "#accordion" ).accordion();
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
</head>
<body>
    
<%
	String mgAccount = session.getAttribute("account").toString();
	out.print( "<p class='message' > Welcome! Dear " + mgAccount + "</p>");
%>
<h2>Customer Management</h2>
<div id="accordion">
  <h3>Add Customer</h3>
  <div>
    <form name="AddCustomerForm" action="saveNewCustomer.jsp" method="post">
        <table>
            <tbody>
                <tr><td><font color="red">* field is required.</font></td></tr>
                <tr><td><label>First Name*:</label></td>
                    <td><input class="textbox" type="text" maxlength="15" name="firstName" /></td>
                </tr>
                <tr><td><label>Last Name*:</label></td>
                    <td><input class="textbox" type="text" maxlength="15" name="lastName" /></td>
                </tr>
                <tr><td><label>Address*:</label></td>
                    <td><input class="textbox" type="text" maxlength="50" name="address" /></td>
                </tr>
                <tr><td><label>City*:</label></td>
                    <td><input class="textbox" type="text" maxlength="20" name="city" /></td>
                </tr>
                <tr><td><label>State*:</label></td>
                    <td><input class="textbox" type="text" maxlength="20" name="state" /></td>
                </tr>
                <tr><td><label>Zip Code*:</label></td>
                    <td><input class="textbox" type="text"  maxlength="10" name="zipcode" /></td>
                </tr>
                <tr><td><label>Phone*:</label></td>
                    <td><input class="textbox" type="text"  maxlength="20" name="phone" /></td>
                </tr>
                <tr><td><label>Credit Card Number:</label></td>
                    <td><input class="textbox" type="text" maxlength="16" name="credit" /></td>
                </tr>
                <tr><td><label>E-mail*:</label></td>
                    <td><input class="textbox" type="text" maxlength="100" name="email" /></td>
                </tr>  
                <tr><td><label>Password*:</label></td>
                    <td><input class="textbox" type="text" maxlength="20" name="password" /></td>
                </tr>    
      </tbody>
        </table>      
      <button value="dummy" type="submit">Add</button>
    </form>
  </div>
  
  <h3>Edit Customer</h3>
  <div>
    <p>
      
    </p>
    <form name="EditCustomerForm" action="searchEditCustomer.jsp" method="post">
        <table>
       <tr><td><font color="red">* field is required.</font></td></tr>
                <tr><td><label>First Name*:</label></td>
                    <td><input type="text" maxlength="15" name="firstName"/></td>
                </tr>
                <tr><td><label>Last Name*:</label></td>
                    <td><input type="text" maxlength="15" name="lastName"/></td>
                </tr>
        </table>                
      <button value="dummy" type="submit">Search</button>
    </form>
  </div>
  
  <h3>Delete Customer</h3>
  <div>
    <p>
      
    </p>
    <form name="DeleteCustomerForm" action="searchDeleteCustomer.jsp" method="post">
        <table>
       <tr><td><font color="red">* field is required.</font></td></tr>
                <tr><td><label>First Name*:</label></td>
                    <td><input type="text" maxlength="15" name="firstName"/></td>
                </tr>
                <tr><td><label>Last Name*:</label></td>
                    <td><input type="text" maxlength="15" name="lastName"/></td>
                </tr>
        </table>                  
      <button value="dummy" type="submit">Search</button>
    </form>
  </div>
</div>
<br><br> Go back? <a href="managerHomePage.jsp"> go back </a>

</body>
</html>
