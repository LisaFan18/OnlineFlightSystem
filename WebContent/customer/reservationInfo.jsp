<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <script src="//code.jquery.com/jquery-1.10.2.js"></script>
  <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
  <link rel="stylesheet" type="text/css" href="/TravelAgencyWeb/css/bootstrap.min.css" />
  <link rel="stylesheet" type="text/css" href="/TravelAgencyWeb/css/style.css" />
   <link rel="stylesheet" type="text/css" href="/TravelAgencyWeb/logincss/textbox.css" />
 
  <script src="/TravelAgencyWeb/js/bootstrap.min.js"></script>
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

<h2>Customer Info</h2>
<div id="accordion">
  <h3>Current reservation</h3>
   <div class="content">
    <p>
      A customers current reservations means there is a leg that has still not taken off (based on DepTime in Leg table).
    </p>

        <%// out.println("<form name='eotm' action='customerCurrentReservations?accountNo=" + ano + "' method='post' > '");%>
    <form name="eotm" action="/TravelAgencyWeb/customer/customerCurrentReseravations" method="post">
        <input type="hidden" name="accountNo" /> 
      <button value="dummy" type="submit">Query</button>
    </form>
  </div>
  
  <h3>Travel itinerary given reservation</h3>
  <div class="content">
    <p>
      Produce a list of travel itinerary for a given reservation.
    </p>
    <% //out.println("<li><a href='TravelGivenReservation?accountNo=" + ano  + "'>Travel itinerary for a given reservation</a></li>");%>
    <form name="reservbyflight" action="/TravelAgencyWeb/customer/TravelGivenReservation" method="post">
      Reservation Number: <input class="textbox" type="text" name="reservationNo">
      <button value="dummy" type="submit">Query</button>
    </form>
  </div>
  
  <h3>Reservation history</h3>
  <div class="content">
    <p>
      Produce a list of reservation history
    </p>
    <%// out.println("<li><a href='historyAllReservations?accountNo=" + ano  + "'>A history of all current and past reservations a customer has made</a></li>");%>          
    <form name="cotm" action="/TravelAgencyWeb/customer/historyAllReservations" method="post">
      <input type="hidden" name="accountNo" />
      <button value="dummy" type="submit">Query</button>
    </form>
  </div>
  <h3>Best seller list of flight</h3>
  <div class="content">
    <p>
      Produce a list of best seller flight
    </p>
              <%// out.println("<li><a href='BestSellerFlights?accountNo=" + ano  + "'>Best-Seller list of flights</a></li>");%>
    <form name="cotm" action="/TravelAgencyWeb/customer/BestSellerFlights" method="post">
        <input type="hidden" name="accountNo" />
      <button value="dummy" type="submit">Query</button>
    </form>
  </div> 
  <h3>Personalized flight suggestion list</h3>
  <div class="content">
    <p>
      Produce a list of personalized flight suggestion list
    </p>
    <form name="cotm" action="/TravelAgencyWeb/customer/PersonalizedFlight" method="post">
          <% //out.println("<li><a href='PersonalizedFlight?accountNo=" + ano  + "'>Personalized flight suggestion list</a></li>");%>        
      <button value="dummy" type="submit">Query</button>
    </form>
  </div>   
</div>
</body>
</html>