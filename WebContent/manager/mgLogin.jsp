<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../css/login.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Rutgers Online Travel</title>

</head>
<body>

<p class="app-name"> Rutgers Online Travel </p>      

<div class="login-page">
  <div class="form">
    <form class="login-form" method="post" action="checkManager.jsp">
      <input type="text" placeholder="account" value="M39304" name="account"/>
      <input type="password"  placeholder="password" value="M39304" name="password"/>
      <button>login</button>
      <p class="message">Customer?<a href="../index.jsp"> Please log in here</a></p>
    </form>
  </div>
</div>
</body>
</html>