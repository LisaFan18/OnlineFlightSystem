<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <script>
    $(function() {
      $("#accordion").accordion({
        active: parseInt(getAnchor(location.href)),
        heightStyle: "content"
      });
    });
    
    function getAnchor(url)
    {
      var index = url.lastIndexOf('#');
      if (index != -1)
        return url.substring(index+1);
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
</head>
<body>


<h2>Revenue Reports</h2>
<div id="accordion">
  <h3>Monthly Report</h3>
  <div class="content">
    <p>
      Obtain a sales report for a particular month.
    </p>
    <form name="monthlyreport" action="getSaleReportByMonth.jsp" method="post" 
          onsubmit="return checkForm(this);">
      <select name='month'>
        <option selected value=''>Month</option>
        <option value='1'>January</option>
        <option value='2'>February</option>
        <option value='3'>March</option>
        <option value='4'>April</option>
        <option value='5'>May</option>
        <option value='6'>June</option>
        <option value='7'>July</option>
        <option value='8'>August</option>
        <option value='9'>September</option>
        <option value='10'>October</option>
        <option value='11'>November</option>
        <option value='12'>December</option>
      </select>
      
      <select name='year'>
        <option selected value=''>Year</option>
        <% int thisYear = Calendar.getInstance().get(Calendar.YEAR) - 5;
           for(int i=0;i<=6;i++) { %>
        <option value='<%= thisYear+i%>'><%= thisYear+i%></option>
        <% } %>
      </select>
     <br><br> <button value="dummy" type="submit">Send</button>
    </form>
  </div>
  
   <p class='message'> <br><br>Go Back? <a href='managerHomePage.jsp'> Go Back</a></p>
</div>
</body>
</html>
