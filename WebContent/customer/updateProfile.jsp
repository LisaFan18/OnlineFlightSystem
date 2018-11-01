<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">Update Profile</h3>
            </div>
            <div class="panel-body">
                <form name="saveUpdateProfileForm" action="saveUpdateProfile.jsp" method="post">
                <input type="hidden"  name="customer_account" value="<%=session.getAttribute("customer_account")%>"/>
                <input type="hidden"  name="customer_email" value="<%=session.getAttribute("customer_email")%>"/>
             <table border="0">
            <tbody>  
            		<tr><td><label style="color:red">* field is required.</label></td></tr>  
            		 <tr><td><label>Email *:</label></td>
                    <td><input class="textbox" type="text" maxlength="100" name="email" value="<%=request.getAttribute("email")%>"/></td>
                </tr>
                <tr><td><label>Password*:</label></td>
                    <td><input class="textbox" type="text" maxlength="20" name="password" value="<%=request.getAttribute("password")%>"/></td>
                </tr>
                <tr><td><label>First Name*:</label></td>
                    <td><input class="textbox" type="text" maxlength="15" name="firstname" value="<%=request.getAttribute("firstname")%>"/></td>
                </tr>
                <tr><td><label>Last Name*:</label></td>
                    <td><input class="textbox" type="text" maxlength="15" name="lastname" value="<%=request.getAttribute("lastname")%>"/></td>
                </tr>
                <tr><td><label>Address*:</label></td>
                    <td><input class="textbox" type="text" maxlength="45" name="address" value="<%=request.getAttribute("address")%>"/></td>
                </tr>
                <tr><td><label>City*:</label></td>
                    <td><input class="textbox" type="text" maxlength="45" name="city" value="<%=request.getAttribute("city")%>"/></td>
                </tr>
                <tr><td><label>State*:</label></td>
                    <td><input class="textbox" type="text" maxlength="45" name="state" value="<%=request.getAttribute("state")%>"/></td>
                </tr>
                <tr><td><label>Zip Code*:</label></td>
                    <td><input class="textbox" type="text" maxlength="7" name="zipcode" value="<%=request.getAttribute("zipcode")%>"/></td>
                </tr>
                <tr><td><label>Phone*:</label></td>
                    <td><input class="textbox" type="text" maxlength="20" name="phone" value="<%=request.getAttribute("phone")%>"/></td>
                </tr>
                <tr><td><label>Credit Card Number:</label></td>
                    <td><input class="textbox" type="text" maxlength="16" name="credit" value="<%=request.getAttribute("credit")%>"/></td>
                </tr>
      </tbody>
        </table>      
              <br><button type="submit" class="btn btn-lg btn-default">Change</button> 
              </form>
            </div>
          </div>
<br><br> Go back? <a href="customerHomePage.jsp"> go back </a>
</body>

</html>